## All API methods should use the current user


get "/api" do
  current_user
  home_menu_nav_variables
  erb :api
end

get "/api/assignments" do
  current_user
  @assignments = Assignment.all_hash
  sleep 3
  json @assignments
end

get "/api/assignments/:id" do
  current_user
  @assignment = Assignment.create_from_database(params["id"])
  
  @a_hash = @assignment.self_hash
  
  @a_hash["collaborator"] = []
  @assignment.collaborators.each do |collaborator|
    @a_hash["collaborator"] << collaborator.self_hash
  end
  
  @a_hash["links"] = []
  @assignment.links.each do |link|
    @a_hash["links"] << link.self_hash
  end  
  json @a_hash
end

get "/api/links" do
  current_user
  @links = Link.all_hash
  json @links
end

get "/api/links/:id" do
  current_user
  @link = Link.create_from_database(params["id"]).self_hash
  json @link
end

get "/api/collaborators" do
  current_user
  @collaborators = Collaborator.all_hash
  json @collaborators
end

get "/api/collaborators/:id" do
  current_user
  @collaborator = Collaborator.create_from_database(params["id"]).self_hash
  json @collaborator
end

get "/api/users" do
  current_user
  @users = User.all_hash
  json @users
end

get "/api/users/:id" do
  current_user
  @user = User.create_from_database(params["id"])
  @a_hash = @user.self_hash
  
  @a_hash["assignments"] = []
  @user.assignments.each do |assignment|
    @a_hash["assignments"] << assignment.self_hash
  end
  json @a_hash
end

get "/api/:class_name/submit" do
  current_user
  class_variable(params["class_name"])
  @m = @class_name.new(params["create_form"])
  @m.save_record
  hash = @m.self_hash
  hash["errors"] = @m.errors  
  json hash
end

get "/api/:class_name/delete/:x" do
  current_user
  class_variable(params["class_name"])
  if @class_name.delete_record(params["x"].to_i)
    @all = @class_name.all_hash
    json @all
  else
    json []
  end
end