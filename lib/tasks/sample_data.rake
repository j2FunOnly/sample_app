namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  print 'Creating users.'

  User.create!(
    name: 'Example User',
    email: 'example@example.com',
    password: 'asdfqwerty',
    password_confirmation: 'asdfqwerty',
    admin: true
  )
  print '.'

  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n + 1}@example.com"
    password = 'password'

    User.create!(
      name: name,
      email: email,
      password: password,
      password_confirmation: password
    )
    print '.'
  end

  puts "\nUsers created."
end

def make_microposts
  print 'Creating microposts.'
  users = User.first(6)

  50.times do |n|
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
    print '.'
  end

  puts "\nMicroposts created."
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end
