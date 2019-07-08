require 'spec_helper'

describe MicropostsHelper do
  it 'deletes word gretater than 30 characters' do
    s = "a #{'a' * 30} b"
    expect(wrap(s)).to eq('a  b')
  end
end
