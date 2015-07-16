module LoginHelper


  def login_unsuccessful
  
  end

  def login_successful

  end

  def check_login
  
  end
  
  # sets the current user or redirects to the login screen
  #
  # returns the current user or redirects
  def current_user
    if session[:user_id] && session[:expires] > Time.now
      @current_user = User.create_from_database(session[:user_id].to_i)
    else
      session.clear
      @message = "You are not logged in.  Please log in."
      redirect "/login"
    end  
  end

end