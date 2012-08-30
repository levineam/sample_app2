class Micropost < ActiveRecord::Base
  attr_accessible :content #, :user_id --> don't want accessible
  belongs_to :user
  # this, plus has_many line in user.rb implements association between
  #users and their microposts
  
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  default_scope order: 'microposts.created_at DESC'
  #DESC is SQL for "descending" i.e. from newest to oldest
  
  def self.from_users_followed_by(user)
    #followed_user_ids = user.followed_user_ids
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    # (#{followed_user_ids})is an example of interpolation, meaning
    #the result of the code in the parens is inserted into the statement
    #though in this case escaping would have worked too (whatever that
    #means)
    
    #where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
    #the above line purs all the ids in memory, which doesn't scale well
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end
end

# followed_user_ids method is automatically created by Active Record based
#on the "has_many :followed_users association. Rails knows that if you
#add "_ids" this means you want the ids corresponding to the ids
#corresponding to the user.followed_users collection. To get this without
#using the _ids suffix you would do
#User.followed_users.map { |i| i.to_s }, though Rails allows you to
#shorten situations where the same method (here to_s) gets called on each
#element, to (&:to_s) for User.followed_users.map(&:to_s). This creates
#a string of the followed_users ids for User.
#User.followed_users.map(&:id) creates an array of the ids, and
#User.followed_users_ids, is Rails's shortcut for the same statement.
