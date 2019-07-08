require 'spec_helper'

describe 'User pages' do
  subject { page }

  describe 'index' do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe 'pagination' do
      before(:all) { 30.times { FactoryGirl.create :user } }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      it 'list each user' do
        User.paginate(page: 1) do |user|
          should have_selector('li', text: user.name)
        end
      end
    end

    describe 'delete links' do
      it { should_not have_link('delete') }

      describe 'as an admin user' do
        let(:admin) { FactoryGirl.create :admin }

        before(:each) do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }

        it 'able to delete another user' do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end

        it { should_not have_link('delete', href: users_path(admin)) }
      end
    end
  end

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
        it { should have_link('Sign out') }
      end
    end

    describe 'for signed in users' do
      let(:user) { FactoryGirl.create(:user) }

      describe 'redirect to root path' do
        before do
          sign_in user
          visit signup_path
        end

        it { should have_title('Home') }
      end

      describe 'submitting to Users#create action' do
        before do
          sign_in user, no_capybara: true
          post users_path
        end

        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end

  describe 'Profile page' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: 'Foo') }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: 'Bar') }

    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe 'microposts' do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe 'delete links' do
      before do
        sign_in user
        visit user_path(user)
      end

      it { should have_link('delete') }

      describe 'for other users' do
        before do
          sign_in FactoryGirl.create(:user)
          visit user_path(user)
        end

        it { should_not have_link('delete') }
      end
    end
  end

  describe 'edit' do
    let(:user) { FactoryGirl.create :user }

    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe 'page' do
      it { should have_content('Update your profile') }
      it { should have_title('Edit user') }
      it { should have_link('change', href: 'https://gravatar.com/emails') }
    end

    describe 'with valid information' do
      let(:new_name) { 'New Name' }
      let(:new_email) { 'new@example.com' }

      before do
        fill_in 'Name', with: new_name
        fill_in 'Email', with: new_email
        fill_in 'Password', with: user.password
        fill_in 'Password confirmation', with: user.password
        click_button 'Update my account'
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq(new_name) }
      specify { expect(user.reload.email).to eq(new_email) }
    end

    describe 'with invalid information' do
      before { click_button 'Update my account' }

      it { should have_content('error') }
    end

    describe 'forbidden attributes' do
      let(:params) do
        {
          user: {
            password: user.password,
            password_confirmation: user.password,
            admin: true
          }
        }
      end

      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end

      specify { expect(user.reload).not_to be_admin }
    end
  end
end
