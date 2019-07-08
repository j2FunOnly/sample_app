require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create :user }
  let(:micropost) { user.microposts.build(content: 'Lorem ipsum') }

  subject { micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  its(:user) { should eq(user) }

  it { should be_valid }

  describe 'when user is nil' do
    before { micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe 'when content is blank' do
    before { micropost.content = ' ' }
    it { should_not be_valid }
  end

  describe 'when content is too long' do
    before { micropost.content = 'a' * 141 }
    it { should_not be_valid }
  end
end
