require 'spec_helper'

describe Lightly do
  let(:lightly) { Lightly.new }

  before do 
    lightly.flush
  end

  describe '#new' do
    it "sets default properties" do
      expect(lightly).to be_enabled
      expect(lightly.life).to eq 3600
      expect(lightly.dir).to eq 'cache'
      expect(lightly.hash).to be true
    end

    it "accepts initialization properties" do
      lightly = Lightly.new dir: 'store', life: 120, hash: false
      expect(lightly.life).to eq 120
      expect(lightly.dir).to eq 'store'
      expect(lightly.hash).to be false
    end
  end

  describe '#get' do
    it "skips caching if disabled" do
      lightly.disable
      lightly.get('key') { 'content' }
      expect(Dir['cache/*']).to be_empty
    end

    it "creates a cache folder" do
      expect(Dir).not_to exist 'cache'
      lightly.get('key') { 'content' }
      expect(Dir).to exist 'cache'
    end

    it "saves a file" do
      lightly.get('key') { 'content' }
      expect(Dir['cache/*']).not_to be_empty
    end

    it "loads from cache" do
      lightly.get('key') { 'content' }
      expect(lightly).to be_cached 'key'
      expect(lightly).to receive(:load)
      lightly.get('key') { 'new, irrelevant content' }
    end

    it "returns content from cache" do
      lightly.get('key') { 'content' }
      expect(lightly).to be_cached 'key'
      content = lightly.get('key') { 'new, irrelevant content' }
      expect(content).to eq 'content'
    end
  end

  describe '#clear' do
    context "with an existing key" do
      before do
        lightly.flush
        lightly.get('key') { 'content' }    
        expect(Dir['cache/*']).not_to be_empty
      end


      it "deletes the cache file" do
        lightly.clear 'key'
        expect(Dir['cache/*']).to be_empty
      end
    end

    context "with a non existing key" do
      it "does not raise an error" do
        expect{lightly.clear 'im not there'}.not_to raise_error
      end
    end
  end

  describe '#cached?' do
    context 'with a cached key' do
      it "returns true" do
        lightly.get('key') { 'content' }
        expect(lightly).to be_cached 'key'
      end
    end

    context 'with an uncached key' do
      it "returns false" do
        expect(lightly).not_to be_cached 'key'
      end
    end

    context 'with an empty cache file' do
      it "returns false" do
        lightly.get('key') { 'content' }
        expect(lightly).to be_cached 'key'
        path = lightly.get_path 'key'
        File.write path, ''
        expect(File.size path).to eq 0

        expect(lightly).not_to be_cached 'key'
      end
    end
  end

  describe '#flush' do
    before do
      lightly.get('key') { 'content' }    
      expect(Dir).to exist 'cache'
    end

    it "deletes all files from the cache folder" do
      lightly.flush
      expect(Dir).not_to exist 'cache'
    end
  end

  describe '#enable' do
    it "enables cache handling" do
      lightly.enable
      expect(lightly).to be_enabled
    end
  end

  describe '#disable' do
    it "disables cache handling" do
      lightly.disable
      expect(lightly).not_to be_enabled
    end
  end

end