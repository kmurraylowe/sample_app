module SessionsHelper
  
  require "pry" 
  
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
     user = User.find_by(id: user_id) 
     #binding.pry
      @current_user ||= user if 
      session[:session_token] == user.session_token
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # Returns true if the given user is the current user
  def current_user?(user)
    user && user == current_user
  end
  
  
  def logged_in?
    !current_user.nil?
  end
    
  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
    
  
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end
  
  #stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
  
end
