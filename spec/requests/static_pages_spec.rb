require 'spec_helper'

describe 'StaticPages' do
  describe 'Home page' do
    before(:each) { visit '/' }

    it 'have the content "Sample App"' do
      expect(page).to have_content('Sample App')
    end

    it 'have "Home" title' do
      expect(page).to have_title('Ruby on Rails Tutorial Sample App | Home')
    end
  end

  describe 'Help page' do
    before(:each) { visit '/help' }

    it 'have the content "Help"' do
      expect(page).to have_content('Help')
    end

    it 'have "Help" title' do
      expect(page).to have_title('Ruby on Rails Tutorial Sample App | Help')
    end
  end

  describe 'About page' do
    before(:each) { visit '/about' }

    it 'have the content "About Us"' do
      expect(page).to have_content('About Us')
    end

    it 'have "About Us" title' do
      expect(page).to have_title('Ruby on Rails Tutorial Sample App | About Us')
    end
  end
end
