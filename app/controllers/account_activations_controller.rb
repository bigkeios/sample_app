class AccountActivationsController < ApplicationController
    def edit
        user = User.find_by(email: params[:email])
        # if found the user with the given email, they are not activated, and the token on the link matches the digest saved in the record of the user
        if user && !user.activated? && user.authenticated?(:activation, params[:id])
            user.activate
            log_in user
            flash[:success] = "Account activated!"
            redirect_to user_url(user)
        else
            flash[:danger] = "The activation link is invalid"
            redirect_to root_url
        end
    end
end
