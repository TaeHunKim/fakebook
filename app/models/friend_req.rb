class FriendReq < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 'User'
  attr_accessor :friend_email
  validates :friend_email, :presence => true

  before_save :check_email

  def check_email
    if friend_email.present?
      friend = User.find_by_email(friend_email)
      if friend
        if friend.id == self.user_id
          self.errors.add(:friend_email, 'cannot same as your email')
          return false
        else
          exist = FriendReq.where("user_id = ? AND friend_id = ?",self.user_id, friend.id).exists?
          if exist
            self.errors.add(:friend_email, 'is already required')
            return false
          end
          exist = Friendship.where("user_id = ? AND friend_id = ?",self.user_id, friend.id).exists? or Friendship.where("user_id = ? AND friend_id = ?",friend_id, self.user_id).exists? 
          if exist
            self.errors.add(:friend_email, 'is already friend')
            return false
          else
            self.friend_id = friend.id
            return true
          end
        end
      else
        self.errors.add(:friend_email, 'not exist')
        return false
      end
    end
  end
end
