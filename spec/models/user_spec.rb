require 'spec_helper'

describe User do
  subject { user }

  let(:user) do
    User.new(name: 'test name', email: 'test@example.com',
             password: '123456', password_confirmation: '123456')
  end

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should be_valid }
  it { should_not be_admin }

  describe 'with admin attribute set to true' do
    before do
      user.save!
      user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe 'name' do
    before { user.name = invalid_name }

    describe 'not present' do
      let(:invalid_name) { '     ' }
      it { should_not be_valid }
    end

    describe 'too long' do
      let(:invalid_name) { 'a' * 51 }
      it { should_not be_valid }
    end

    describe 'too short' do
      let(:invalid_name) { 'aa' }
      it { should_not be_valid }
    end
  end

  describe 'email' do
    describe 'not present' do
      before { user.email = ' ' }
      it { should_not be_valid }
    end

    describe 'format' do
      it 'invalid' do
        addresses = %w(user@foo,com user_at_foo.com us.er@foo. user@fo_o.#
                       user@fo+o.com user@foo..com)
        addresses.each do |address|
          user.email = address
          expect(user).not_to be_valid
        end
      end

      it 'valid' do
        addresses = %w(user@foo.COM U_S-ER@f.o.o.org us.er@foo.jp us+er@foo.ru)
        addresses.each do |address|
          user.email = address
          expect(user).to be_valid
        end
      end
    end

    describe 'when already taken' do
      before do
        user_w_same_email = user.dup
        user_w_same_email.email = user.email.upcase
        user_w_same_email.save!
      end

      it { should_not be_valid }
    end

    it 'should downcase email' do
      email = 'FOO@BAR.COM'
      user.update_attribute(:email, email)

      expect(user.email).to eq(email.downcase)
    end
  end

  describe 'password' do
    describe 'is not present' do
      before { user.password = user.password_confirmation = '' }
      it { should_not be_valid }
    end

    describe 'does not match confirmation' do
      before { user.password_confirmation = user.password.reverse }
      it { should_not be_valid }
    end

    describe 'too short' do
      before { user.password = user.password_confirmation = 'a' * 5 }
      it { should_not be_valid }
    end

    describe 'authenticate' do
      before { user.save }
      let(:found_user) { User.find_by_email(user.email) }

      describe 'with valid password' do
        it { should eq(found_user.authenticate(user.password)) }
      end

      describe 'with invalid password' do
        let(:user_invalid_password) { found_user.authenticate('invalid') }

        it { should_not eq(user_invalid_password) }
        it { expect(user_invalid_password).to be_falsy }
      end
    end
  end

  describe 'remember_token' do
    before { user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe 'microposts association' do
    before { user.save }

    let!(:older_post) do
      FactoryGirl.create(:micropost, user: user, created_at: 1.day.ago)
    end
    let!(:newer_post) do
      FactoryGirl.create(:micropost, user: user, created_at: 1.hour.ago)
    end

    it 'microposts order' do
      expect(user.microposts.to_a).to eq([newer_post, older_post])
    end

    it 'destroy associated posts when user destroyed' do
      posts = user.microposts.to_a
      user.destroy

      expect(posts).not_to be_empty

      posts.each do |post|
        expect(Micropost.where(id: post.id)).to be_empty
      end
    end

    describe 'status' do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      let(:followed_user) { FactoryGirl.create :user }

      before do
        user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: 'Lorem ipsum') }
      end

      its(:feed) { should include(newer_post) }
      its(:feed) { should include(older_post) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |post|
          should include(post)
        end
      end
    end
  end

  describe 'following' do
    let(:other_user) { FactoryGirl.create :user }

    before do
      user.save
      user.follow! other_user
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe 'followed users' do
      subject { other_user }

      its(:followers) { should include(user) }
    end

    describe 'and unfollowing' do
      before { user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end
end
