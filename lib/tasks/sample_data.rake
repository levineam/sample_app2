namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    #ensures that the Rake task has access to the local Rails environment
    #including the User model (and hence User.create!)
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
    admin = User.create!(name: "Example User",
    #User.create! is like the create method, except it raises an
    #exception for an invalid user rather than returning false. This
    #noisier construction makes debugging easier by avoiding silent errors
                         email:    "example@railstutorial.org",
                         password: "foobar",
                         password_confirmation: "foobar")
    admin.toggle!(:admin)
    #  I believe the above code ("admin" through "admin.toggle!")
    #represents the first user we are creating
    #  We added "admin = " to the beginning and "admin.toggle!(:admin) to
    #the end to make the first user an admin by default
    #  Why not add "admin: true to the initialization hash
    #(rails generate migration add_admin_to_users admin:boolean)
    #to make user? Because only attr_accessible attributes can be assigned
    #through mass assignment, and the admin attribute isn't accessible. Go
    #to app/models/user.rb for list of attr_accessible attributes. This is
    #a security measure, if we didn't do it, one could submit a PUT
    #making any user they choose an admin
    99.times do |n|
        name  = Faker::Name.name
        email = "example-#{n+1}@railstutorial.org"
        password  = "password"
        User.create!(name:     name,
                     email:    email,
                     password: password,
                     password_confirmation: password)
    end
end

def make_microposts
    users = User.all(limit: 6)
    50.times do
        content = Faker::Lorem.sentence(5)
        users.each { |user| user.microposts.create!(content: content) }
    end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end

