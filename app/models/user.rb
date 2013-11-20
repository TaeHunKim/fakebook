class User < ActiveRecord::Base
  #validates :name, :hashed_password, :email, presence: true
  #validates :email, uniqueness: true

  has_many :friendships
  has_many :friend_reqs
  has_many :posts
  #has_many :friend_newsfeeds, :through => :friendships, :source => :post 
  has_many :friend_reqeds, foreign_key: 'friend_id', :class_name=> 'FriendReq'
  has_many :friends, :through => :friendships 
  has_many :req_friends, :through => :friend_reqs, :source => :friend
  has_many :reqed_friends, :through => :friend_reqeds, :source => :user 

  attr_accessor :password
  EMAIL_REGEX = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
  validates :name, :presence => true
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :confirmation => true, :presence => true, :length => { :minimum => 6 }, :on => :create
  validates :password_confirmation, :presence => true, :on => :create
  #validates_length_of :password, :in => 6..20, :on => :create
  #validates_confirmation_of :password
  before_save :hash_password
  after_save :clear_password
  def hash_password
    if password.present?
      #self.salt = BCrypt::Engine.generate_salt
      self.hashed_password= Base64.encode64(password)
    end
  end
  def clear_password
    self.password = nil
  end
  def newsfeeds
    Post.where('user_id IN (?) or user_id = ?', self.friendships.select('friend_id'), self.id)
    #Post.where(user_id: self.id)
  end
end
