module LoginHelper


  def login_unsuccessful
    home_menu_nav_variables
    @message = "That user name and/or password was incorrect.  Please try again."
    erb :login
  end

  def login_successful(params)
    session[:user_id] = @user.id
    if params["keep_me_logged"] == "on"
      session[:expires] = Chronic.parse("tomorrow");
    else
      session[:expires] = Chronic.parse("four hours from now");
    end
    redirect "/api"
  end

  def check_login(params)
    @user = User.where_match("email", params["contact_info"], "==").first;
    if BCrypt::Password.new(@user.password) == params["password"]
      login_successful(params)
    else
      login_unsuccessful
    end
  end
  
  # sets the current user or redirects to the login screen
  #
  # returns the current user or redirects
  def current_user
    if session[:user_id] # Do not know how to check for nil session expires.  #TODO - figure out session expires
      @current_user = User.create_from_database(session[:user_id].to_i)
    else
      session.clear
      @message = "You are not logged in.  Please log in."
      redirect "/login"
    end  
  end

end