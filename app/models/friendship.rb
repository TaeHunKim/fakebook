class Friendship < ActiveRecord::Base
  has_many :post, foreign_key: 'user_id', primary_key: 'friend_id'
  belongs_to :user
  belongs_to :friend, :class_name => 'User'
end
