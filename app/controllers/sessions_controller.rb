class SessionsController < ApplicationController
  # GET /login = session/new
  def new
  end

  # POST /login = session/create
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in if the password is correct and the account is activated
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or_to user_url(user)
      else
        flash[:warning] = "Account not activated. Please check your emaill for activation link"
        redirect_to root_url
      end
    else
      # Show error
      flash.now[:danger] = 'Invalid login information'
      render :new
    end
  end

  # DELETE /logout
  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
  
end
