require 'spec_helper'

describe 'User pages' do
  subject { page }

  describe 'signup page' do
    before { visit signup_path }
    let(:submit) { 'Create my account' }

    it { should have_content('Sign Up') }
    it { should have_title('Sign Up') }

    describe 'with invalid info' do
      it 'should not create user' do
        expect { click_button submit}.not_to change(User, :count)
      end

      describe 'after submission' do
        before { click_button submit }

        it { should have_title('Sign Up') }
        it { should have_content('error') }
      end
    end

    describe 'with valid info' do
      before do
        fill_in 'Name', with: 'Test User'
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'asdfqwerty'
        fill_in 'Password confirmation', with: 'asdfqwerty'
      end

      it 'should create user' do
        expect { click_button submit }.to change(User, :count)
      end

      describe 'after saving the user' do
        before { click_button submit }
        let(:user) { User.find_by_email('test@example.com') }

        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe 'Profile page' do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end
end
