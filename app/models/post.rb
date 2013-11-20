class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :friendship, foreign_key: 'friend_id'

  validates :content, :presence => true
  validates :user_id, :presence => true
end
