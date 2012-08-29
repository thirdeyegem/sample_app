# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Micropost < ActiveRecord::Base
  attr_accessible :content #:user_id should not be accessible
  
  belongs_to :user
  
  default_scope :order => 'microposts.created_at DESC'
  
  validates :content,   :presence => true,
                        :length   => { :maximum => 140 }
                        
  validates :user_id,   :presence => true
  
  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  
  private
  
    def self.followed_by(user)
      # followed_ids = user.following.map(&:id).join(", ") #original statement pulls all data from db before interpolating
      followed_ids = %(SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id)  #this statement pushes the task of getting the right set of ids for the current_user
      where("user_id IN (#{followed_ids}) OR user_id = :user_id", 
            :user_id => user) #pagination for the feed is taking place in the User model; 'feed' method
    end
  
end
