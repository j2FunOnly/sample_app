require 'spec_helper'

describe 'StaticPages' do
  subject { page }
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  shared_examples_for 'all static pages' do
    it { should have_selector('h1', text: heading) }
    it { should have_title("#{base_title} | #{title}") }
  end

  describe 'Home page' do
    before(:each) { visit root_path }
    let(:heading) { 'Sample App' }
    let(:title) { 'Home' }

    it_should_behave_like 'all static pages'

    describe 'for signed in users' do
      let(:user) { FactoryGirl.create :user }

      before do
        FactoryGirl.create(:micropost, user: user, content: 'Lorem ipsum')
        FactoryGirl.create(:micropost, user: user, content: 'dolor sit amet')
        sign_in user
        visit root_path
      end

      it 'should render the users feed' do
        user.feed.each do |item|
          expect(page).to have_selector("li#micropost_#{item.id}", text: item.content)
        end
      end
    end
  end

  describe 'Help page' do
    before(:each) { visit help_path }
    let(:heading) { 'Help' }
    let(:title) { 'Help' }

    it_should_behave_like 'all static pages'
  end

  describe 'About page' do
    before(:each) { visit about_path }
    let(:heading) { 'About Us' }
    let(:title) { 'About Us' }

    it_should_behave_like 'all static pages'
  end

  describe 'Contact page' do
    before(:each) { visit contact_path }
    let(:heading) { 'Contact Us' }
    let(:title) { 'Contact Us' }

    it_should_behave_like 'all static pages'
  end

  it 'have right links on the layout' do
    visit root_path
    click_link 'About'
    should have_selector('h1', text: 'About')
    click_link 'Help'
    should have_selector('h1', text: 'Help')
    click_link 'Contact'
    should have_selector('h1', text: 'Contact')
    click_link 'Home'
    click_link 'Sign up now!'
    should have_selector('h1', text: 'Sign Up')
    click_link 'Sample App'
    should have_selector('h1', text: 'Sample App')
  end
end
