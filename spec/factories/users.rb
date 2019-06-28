FactoryGirl.define do
  factory :user do
    name "Test User"
    email "test_user@example.com"
    password "asdfqwerty"
    password_confirmation "asdfqwerty"
  end
end
