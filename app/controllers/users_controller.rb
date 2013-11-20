class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "You signed up succesfully"
      flash[:color] = "valid"
      redirect_to "root_path"
    else
      flash[:notice] = "Form is invalid"
      flash[:color] = "invalid"
      render "new"
    end
  end

  def edit
    @permission = false
    if @user.id == params[:id].to_f
      @user = User.find(params[:id])
      @permission = true
    end
  end

  def update
    @user = User.find(params[:id])
    if(@user.update(user_params))
      redirect_to root_path
    else
      render action: 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
