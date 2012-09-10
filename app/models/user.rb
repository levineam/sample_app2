# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

# the code below defines the @user variable
#Variables that start with the @ sign, called instance variables, are
#automatically available in the view
class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation #makes email and name attributes accessible to OUTSIDE USERS
  has_secure_password
  has_many :microposts, dependent: :destroy
  # this, plus belongs_to line in user.rb implements association between
  #users and their microposts
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  # An id used to connect two database tables is known as
  #a foreign key, and when the foreign key for a User model object is
  #user_id, Rails infers the association automatically: by default,
  #Rails expects a foreign key of the form <class>_id, where <class> is
  #the lower-case version of the class name. In the present case,
  #although we are still dealing with users, they are now identified
  #with the foreign key follower_id, so we have to tell that to Rails
  # dependent: :destroy makes sure that destroying a user destroys his/
  #her relationships
  has_many :followed_users, through: :relationships, source: :followed
  # could write this way: has_many :followeds, through: :relationships,
  #but "followeds" is awkward, so instead we create :followed_users,
  #and define "followed" as its source using the source parameter,
  #thereby replacing "followed" w/"followed_users"
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  # we exploit the underlying symmetry between followers and followed
  #users to simulate a reverse_relationships table by passing
  #followed_id as the primary key. I.e. where the relationships
  #association uses the follower_id foreign key, the
  #reverse_relationships association uses followed_id
  # NOTE: have to include a class_name, because otherwise Rails would
  #look for a ReverseRelationship class, which doesn't exist
  # Also we could have omitted the source: key because Rails will
  #properly singularize followers
  
  #before_save { self.email.downcase! }-->replaced with below from 8.18
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  #causes Rails to look for a method called create_remember_token and
  #run it before saving the user
  
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
                    #replaced "true" with { case_sens... } rails infers "true"
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  def feed
    # This is preliminary. See "Following users" for full implement
    Micropost.from_users_followed_by(self)
  end
  # The ? ensures that id is properly escaped before being in the
  #underlying SQL query, thereby escaping a serious security hole called
  #a SQL injection
  
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end
  
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  # the following? method takes in a user, called other_user, and checks
  #to see if a followed user with that id exists in the database; the
  #follow! method calls create! through the relationships association
  #to create the following relationship
  # note: relationships.create!... = self.relationships.create!...,
  #i.e. self is implied
  
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  #unfollows a user by destroying user relationship
  
  private
  #using the "private" keyword makes sure the methods below are only
  #used internally by the User model and aren't exposed to outside users
  #they are automatically hidden, so trying to find the methods in the
  #rails console will fail
    def create_remember_token
      #Creates the token
      self.remember_token = SecureRandom.urlsafe_base64
      #note: the capital "R" here, and caps in general MATTER
      
      #w/o the "self" assignment, would create local variable called
      #remember_token, using self ensures that assignment sets the
      #user's remember_token in the database with its other attributes
      #when the user is saved
      
      #SecureRandom is a module in the Ruby standard library that
      #creates a Base64 string safe for us in URIs (and therefore
      #cookies), it returns a random 16 character string, each character
      #has 64 possibilities
    end
end
