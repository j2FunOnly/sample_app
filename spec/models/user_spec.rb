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
  it { should be_valid }

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
end
