namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
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

    print 'Creating microposts.'
    users = User.first(6)
    50.times do |n|
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
      print '.'
    end
    puts "\nMicroposts created."
  end
end
