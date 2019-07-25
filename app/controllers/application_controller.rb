class ApplicationController < ActionController::Base
    include SessionsHelper
    protect_from_forgery with: :exception
    def hello
        render html: "Hello world!"
    end
    # method to confirm a logged in user
    def logged_in_user
        if !logged_in?
          store_location
          flash[:danger] = 'Please log in to continue'
          redirect_to login_url
        end
    end
end
