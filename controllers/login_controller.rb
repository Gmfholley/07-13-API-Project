get "/login" do
  # "yes"
  home_menu_nav_variables
  erb :login
end

post "/login/submit" do
  @user = User.where_match("email", params["log_in"]["contact_info"], "==").first;
  binding.pry
  if BCrypt::Password.new(@user.password) == params["log_in"]["password"]
    session[:user_id] = @user.id
    if params["log_in"]["keep_me_logged"] == "on"
      session[:expires] = Chronic.parse("tomorrow");
    else
      session[:expires] = Chronic.parse("four hours");
    end
    redirect "/api"
  else
    home_menu_nav_variables
    @message = "That user name and/or password was incorrect.  Please try again."
    erb :login
  end
end


get "/login/forgot" do
  "I'm sorry.  I don't know enough about authentication to help you.  Create a new account."
end

get "/logout" do
  session.clear
  redirect "/home"
end