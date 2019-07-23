module SessionsHelper
    # Log in a user
    def log_in(user)
        session[:user_id] = user.id
    end

    # Remember a user in a persistant session
    def remember(user)
        user.remember
        # save user_id and remember token into the cookie
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    def current_user
        if (user_id = session[:user_id])
            @current_user  = @current_user || User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id])
            user = User.find_by(id: user_id)
            if user && user.authenticated?(:remember, cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end

    def correct_user?(user)
        user == current_user
    end

    def logged_in?
        !current_user.nil?
    end

    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    def log_out
        forget(current_user)
        session.delete(:user_id) #put this behind to preserve @current_user to use in forget or else it will goes to the elsif and login again
        @current_user = nil
    end

    def redirect_back_or_to(default)
        redirect_to (session[:fowarding_url] || default)
        session.delete(:fowarding_url)
    end

    def store_location
        session[:fowarding_url] = request.original_url  if request.get?
    end
    
end
