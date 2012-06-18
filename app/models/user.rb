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

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation #makes email and name attributes accessible to OUTSIDE USERS
  has_secure_password
  
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
