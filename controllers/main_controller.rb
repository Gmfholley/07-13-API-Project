get "/home" do
  home_menu_nav_variables
  home_menu_local_variables
  erb :menu
end

###############################
# Show the menu for this class
get "/:class_name" do
  home_menu_nav_variables
  class_variable(params["class_name"])
  if @class_name.nil?
    erb :not_appearing
  else
    crud_menu_local_variables(@class_name)
    erb :menu
  end
end

########################
# Do something to this class

get "/:class_name/:action" do
  
  home_menu_nav_variables
  class_variable(params["class_name"])
  case params["action"]
  when "update", "delete"
    table_menu_local_variables(params["action"], true)
    erb :menu
  when "show"
    table_menu_local_variables(params["action"], false)
    erb :menu
  when "create"
    # create an object so you can get its instance variables
    @m = @class_name.new
    date_array_for_this_class(@class_name)
    erb :create
    
  when "submit"
    class_variable(params["class_name"])
    @m = @class_name.new(params["create_form"])
    
    if @m.save_record
      @message = "Successfully saved!"
      table_menu_local_variables("show", false)
      erb :menu
    else
      date_array_for_this_class(@class_name)
      erb :create
    end
  else
    erb :not_appearing
  end
end

################################
# Do something to this object in the class

get "/:class_name/:action/:x" do
  home_menu_nav_variables
  @class_name = menu_to_class_name[params["class_name"]]

  case params["action"]
  when "update"
    @m = @class_name.create_from_database(params["x"].to_i)
    date_array_for_this_class(@class_name)
    erb :create
  when "delete"
    if @class_name.delete_record(params["x"].to_i)
      @message = "Successfully deleted."
    else
      @message = "This #{@class_name} cannot be deleted because it is currently used in another table."
    end
    table_menu_local_variables("show", false)
    erb :menu
  
  when "show"
    @m = @class_name.create_from_database(params["x"].to_i)
    if @class_name == User
      @associated_objects = [@m.collaborators]
    elsif @class_name == Assignment
      @associated_objects = [@m.collaborators, @m.links]
    else
      @associated_objects = []
    end
    erb :show
  else
    erb :not_appearing
  end
  
end

get "/:not_listed" do
  home_menu_nav_variables
  erb :not_appearing
end