class FriendshipController < ApplicationController
  def index
    @friendship = Friendship.new
    @friends = @user.friends
    @req_friends = @user.req_friends
    #@reqed_friends_id = FriendReq.where("friend_id = ?",@user.id)
    @reqed_friends = @user.reqed_friends
  end

  def add
    @req_friend = FriendReq.new
  end

  def find_and_require
    @req_friend = FriendReq.new(friend_req_params)
    if @req_friend.save
      redirect_to friend_path
    else
      render action: 'add'
    end
  end

  def allow
    @friendship = Friendship.new(allow_params)
    req_friend_delete = FriendReq.where(user_id: @friendship.friend_id, friend_id: @friendship.user_id).first
    if req_friend_delete.destroy
      friendship_reverse = Friendship.create(user_id: @friendship.friend_id,friend_id: @friendship.user_id)
      if @friendship.save and friendship_reverse.save
        redirect_to friend_path
      else
        render action: 'index'
      end
    else
      render action: 'index'
    end
  end

  private
  def friend_req_params
    params.require(:friend_req).permit(:user_id, :friend_email)
  end 
  def allow_params
    params.require(:friendship).permit(:user_id, :friend_id)
  end 
end
