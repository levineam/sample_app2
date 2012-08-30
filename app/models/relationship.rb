class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # Rails infers the names of the foreign keys from the corresponding
  #symbols (i.e., follower_id from :follower, and followed_id from
  #:followed), but since there is neither a Followed nor a Follower model
  #we need to supply the class name User
  
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  #adding the Relationship model validations
end
