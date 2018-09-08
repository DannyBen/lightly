require 'spec_helper'

describe Lightly do
  subject { described_class }

  it "has good defaults" do
    expect(subject.dir).to eq 'cache'
    expect(subject.life).to eq 3600
    expect(subject.hash?).to be true
  end

  it "is enabled by default" do
    expect(subject).to be_enabled
  end

  it "behaves as a Lightly instance" do
    instance_methods = subject.new.methods - Object.methods
    class_methods    = subject.methods - Object.methods

    expect(instance_methods).to eq class_methods
  end
end