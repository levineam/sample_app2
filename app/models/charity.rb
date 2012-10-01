class Charity < ActiveRecord::Base
  attr_accessible :name, :description, :summary
  
  before_save { |charity| charity.name = name.downcase }
  belongs_to :user
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 40 }
  validates :summary, presence: true, length: { maximum: 140 }
  validates :description, presence: true
  validates :user_id, presence: true
  
  default_scope order: 'charities.created_at DESC'
end
