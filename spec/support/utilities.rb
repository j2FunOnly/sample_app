def sign_in(user, options = {})
  if options[:no_capybara]
    token = User.new_remember_token
    cookies[:remember_token] = token
    user.update_attribute(:remember_token, User.encrypt(token))
  else
    visit signin_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end
end
