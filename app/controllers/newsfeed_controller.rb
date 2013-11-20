class NewsfeedController < ApplicationController
  def index
    @newsfeeds = @user.newsfeeds.order('updated_at DESC')
  end

  #def show
  #  @permission = false
  #  @newsfeed = Post.find(params[:id])
  #  if @newsfeed.user_id == @user.id or Friendship.where(user_id: @user.id).exists?(friend_id: @newsfeed.user_id)
  #    @permission = true
  #  else
  #    @newsfeed = nil
  #    @permission = false
  #  end
 # end
end
