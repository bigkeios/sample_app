class UsersController < ApplicationController
  before_action :logged_in_user, only:[:index, :edit, :update, :destroy]
  before_action :correct_user, only:[:edit, :update]
  before_action :admin_user, only:[:destroy]

  #GET users
  def index
    @users = User.paginate(page: params[:page])
    # using paginate of will-paginate to make it work. page is auto passed by will-paginate
  end

  # GET users/new
  def new
    @user = User.new
  end

  # GET users/1
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  #POST users
  def create
    @user = User.new(user_params)
    if @user.save
      # log_in @user
      # flash[:success] = "Welcome to the sample app"
      # redirect_to user_url(@user)
      # send activation email instead of login
      @user.send_activation_email
      flash[:info] = "Please check your mail box for activation email"
      redirect_to root_url
    else
      render :new
    end
  end

  # GET users/1/edit
  def edit
    @user = User.find_by(id: params[:id])
  end

  #PATCH users/1/edit
  def update 
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # do something when saving changes is successful
      flash[:success] = "Changes saved"
      redirect_to user_url(@user)
    else
      # saving failed
      render :edit
    end
  end

  # DELETE users/1
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Delete user successfully"
    redirect_to users_url
  end
  # GET /users/1/following
  def following
    @title = "Following"
    @user = User.find_by(id: params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  # GET /users/1/followers
  def followers
    @title = "Followers"
    @user = User.find_by(id: params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    # before filters  

    # method to confirm the correct user is editing
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless correct_user?(@user)
    end

    # method to make sure it is admin making the action
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
