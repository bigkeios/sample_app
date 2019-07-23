class UsersController < ApplicationController
  before_action :logged_in_user, only:[:index, :edit, :update]
  before_action :correct_user, only:[:edit, :update]

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
  end

  #POST users
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the sample app"
      redirect_to user_url(@user)
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

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    # before filters

    # method to confirm a logged in user
    def logged_in_user
      if !logged_in?
        store_location
        flash[:danger] = 'Please log in to continue'
        redirect_to login_url
      end
    end

    # method to confirm the correct user is editing
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless correct_user?(@user)
    end
end
