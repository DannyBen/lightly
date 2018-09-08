require 'spec_helper'

describe Lightly do
  before { subject.flush }

  describe '#new' do
    it "sets default properties" do
      expect(subject).to be_enabled
      expect(subject.life).to eq 3600
      expect(subject.dir).to eq 'cache'
      expect(subject.hash?).to be true
    end

    context "with initialization parameters" do
      subject { described_class.new dir: 'store', life: 120, hash: false }

      it "sets properties" do
        expect(subject.life).to eq 120
        expect(subject.dir).to eq 'store'
        expect(subject.hash?).to be false
      end
    end
  end

  describe '#get' do
    it "skips caching if disabled" do
      subject.disable
      subject.get('key') { 'content' }
      expect(Dir['cache/*']).to be_empty
    end

    it "skips caching if block returns false" do
      subject.get('key') { false }
      expect(Dir['cache/*']).to be_empty
      expect(subject.cached? 'key').to be false
    end

    it "creates a cache folder" do
      expect(Dir).not_to exist 'cache'
      subject.get('key') { 'content' }
      expect(Dir).to exist 'cache'
    end

    it "saves a file" do
      subject.get('key') { 'content' }
      expect(Dir['cache/*']).not_to be_empty
    end

    it "loads from cache" do
      subject.get('key') { 'content' }
      expect(subject).to be_cached 'key'
      expect(subject).to receive(:load)
      subject.get('key') { 'new, irrelevant content' }
    end

    it "returns content from cache" do
      subject.get('key') { 'content' }
      expect(subject).to be_cached 'key'
      content = subject.get('key') { 'new, irrelevant content' }
      expect(content).to eq 'content'
    end
  end

  describe '#clear' do
    context "with an existing key" do
      before do
        subject.flush
        subject.get('key') { 'content' }    
        expect(Dir['cache/*']).not_to be_empty
      end

      it "deletes the cache file" do
        subject.clear 'key'
        expect(Dir['cache/*']).to be_empty
      end
    end

    context "with a non existing key" do
      it "does not raise an error" do
        expect{subject.clear 'im not there'}.not_to raise_error
      end
    end
  end

  describe '#cached?' do
    context 'with a cached key' do
      it "returns true" do
        subject.get('key') { 'content' }
        expect(subject).to be_cached 'key'
      end
    end

    context 'with an uncached key' do
      it "returns false" do
        expect(subject).not_to be_cached 'key'
      end
    end

    context 'with an empty cache file' do
      it "returns false" do
        subject.get('key') { 'content' }
        expect(subject).to be_cached 'key'
        path = subject.get_path 'key'
        File.write path, ''
        expect(File.size path).to eq 0

        expect(subject).not_to be_cached 'key'
      end
    end
  end

  describe '#flush' do
    before do
      subject.get('key') { 'content' }    
      expect(Dir).to exist 'cache'
    end

    it "deletes all files from the cache folder" do
      subject.flush
      expect(Dir).not_to exist 'cache'
    end
  end

  describe '#enable' do
    it "enables cache handling" do
      subject.enable
      expect(subject).to be_enabled
    end
  end

  describe '#disable' do
    it "disables cache handling" do
      subject.disable
      expect(subject).not_to be_enabled
    end
  end

  describe '#save' do
    it "saves a file" do
      subject.save('key', 'content')
      expect(Dir['cache/*']).not_to be_empty
    end
  end

  describe '#get_path' do
    context "when using hash" do
      before { subject.hash = true }

      it "returns a hashed path" do
        expect(subject.get_path 'hello').to eq "cache/5d41402abc4b2a76b9719d911017c592"
      end
    end

    context "when not using hash" do
      before { subject.hash = false }

      it "returns a non hashed path" do
        expect(subject.get_path 'hello').to eq "cache/hello"
      end
    end
  end

  describe '#life=' do
    it "handles plain numbers" do
      subject.life = 11
      expect(subject.life).to eq 11
    end

    it "handles 11s as seconds" do
      subject.life = '11s'
      expect(subject.life).to eq 11
    end

    it "handles 11m as minutes" do
      subject.life = '11m'
      expect(subject.life).to eq 11 * 60
    end

    it "handles 11h as hours" do
      subject.life = '11h'
      expect(subject.life).to eq 11 * 60 * 60
    end

    it "handles 11d as days" do
      subject.life = '11d'
      expect(subject.life).to eq 11 * 60 * 60 * 24
    end
  end

end