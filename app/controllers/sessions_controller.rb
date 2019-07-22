class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in if the password is correct
      log_in user
      redirect_to user_url(user)
    else
      # Show error
      flash.now[:danger] = 'Invalid login information'
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
  
end
