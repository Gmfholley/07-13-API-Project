get "/api/assignments" do
  @assignments = Assignment.all_hash
  json @assignments
end

get "/api/assignments/:id" do
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
  @links = Link.all_hash
  json @links
end

get "/api/links/:id" do
  @link = Link.create_from_database(params["id"]).self_hash
  json @link
end

get "/api/users" do
  @users = User.all_hash
  json @users
end

get "/api/users/:id" do
  @user = User.create_from_database(params["id"])
  @a_hash = @user.self_hash
  
  @a_hash["assignments"] = []
  @user.assignments.each do |assignment|
    @a_hash["assignments"] << assignment.self_hash
  end
  json @a_hash
end

get "/api/:class_name/submit" do
  class_variable(params["class_name"])
  @m = @class_name.new(params["create_form"])
  @m.save_record
  json @m.errors
end