module SessionsHelper
    def current_user
        @current_use ||= User.find_by(id: session[:user_id])
    end
    
    def logged_in?
        !!current_user
    end
end
