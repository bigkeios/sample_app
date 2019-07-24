class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  # GET password_resets/new -> form to enter email
  def new
  end

  # POST /password_resets -> trigger generating token and digest and sending email, send email w/ link to reset, redirect
  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      @user.create_pw_reset_digest
      @user.send_pw_reset_email
      flash[:info] = 'Check your email for reset link'
      redirect_to root_url
    else
      flash.now[:danger] = 'Invalid email'
      render :new
    end
  end

  # GET password_resets/<token>/edit -> form to enter new password
  def edit
  end

  # POST password_resets/<token> -> send request to save new password
  def update 
    if params[:user][:password].empty? #empty password
      @user.errors.add(:password, "can\' be empty" )
      render :edit
    elsif @user.update_attributes(user_params) #unsuccessful update
      log_in @user
      flash[:success] = 'Password was reset successfully'
      redirect_to user_url(@user)
    else #password not valid
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end
  # check if a user is activated and the token from the link they clicked matches
  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:pw_reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.pw_reset_expired?
      flash[:danger] = "The reset link has expired"
      redirect_to new_password_reset_url
    end
  end
end
