get "/login" do
  # "yes"
  home_menu_nav_variables
  erb :login
end

post "/login/submit" do
  check_login(params["log_in"])
end


get "/login/forgot" do
  "I'm sorry.  I don't know enough about authentication to help you.  Create a new account."
end

get "/logout" do
  session.clear
  redirect "/home"
end