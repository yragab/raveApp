class Micropost < ActiveRecord::Base
  # Necessary for site security so no one can mess around with user_id
  attr_accessible :content
  
  belongs_to :user
  
  validates :user_id, :presence => true
  validates :content, :presence => true, :length => {:maximum => 140}
  
  # DESC is SQL for descending
  default_scope :order => 'microposts.created_at DESC'
  
end
