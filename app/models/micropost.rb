class Micropost < ActiveRecord::Base
  attr_accessible :content #, :user_id --> don't want accessible
  belongs_to :user
  # this, plus has_many line in user.rb implements association between
  #users and their microposts
  
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  default_scope order: 'microposts.created_at DESC'
  #DESC is SQL for "descending" i.e. from newest to oldest
end
