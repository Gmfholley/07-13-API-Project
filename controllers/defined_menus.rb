module DefinedMenus
  # Here are my static menus to run my menu.erb file
  #
  # Menus are either defined manually here or created with all of a class's objects
  # Menus are from the Menu class.
  #     Menus have a menu title and an Array of MenuItems
  #     MenuItems have a key_to_respond (String), MethodToCall item, and a user_message (Array of Strings)
  #       MethodToCall class items have a method_name (String) and a params (Array of parameters needed
  #         the method call).  This is all more useful in terminal, but in this application, I am storing the
  #         next link url in method_name.
  #
  
  # Menus are loaded into the menu.erb and rendered into html by menu_controller.rb in my controllers folder

  ##########################################################

  # returns a Home Menu object
  #
  # returns a Menu
  def home_menu
    m = Menu.new("Where would you like to go?")
    m.add_menu_item(user_message: ["Work with assignments"], method_name: "assignment")
    m.add_menu_item(user_message: ["Work with links"], method_name: "link")
    m.add_menu_item(user_message: ["Work with collaborators."], method_name: "collaborator")
    m.add_menu_item(user_message: ["Work with users."], method_name: "user")
    m
  end

  # returns a CRUD menu
  #
  # returns a Menu
  def crud_menu(class_name)
    class_string = class_name.to_s.underscore.downcase
    m = Menu.new("What would you like to do with #{class_string.humanize.downcase.pluralize}?")
    m.add_menu_item(user_message: ["Create a new #{class_string.humanize.downcase}."], method_name: "#{class_string}/create")
    m.add_menu_item(user_message: ["Show all #{class_string.humanize.downcase.pluralize}."], method_name: "#{class_string}/show")
    m.add_menu_item(user_message: ["Update a #{class_string.humanize.downcase}."], method_name: "#{class_string}/update")
    m.add_menu_item(user_message: ["Delete a #{class_string.humanize.downcase}."], method_name: "#{class_string}/delete")
    m
  end


  # returns a Menu of all the class's objects
  #
  # returns a Menu
  def object_menu(class_name, action)
    class_string = class_name.to_s.underscore.downcase
    create_menu = Menu.new(menu_title_hash_by_action(class_string.humanize.downcase)[action])
    all = class_name.all
    all.each_with_index do |object, x|
      create_menu.add_menu_item({user_message: get_object_display_message(object), method_name: "#{class_string}/#{action}/#{object.id}"})
    end
    create_menu
  end
  
  # returns object's display_fields values
  #
  # returns an Array of values
  def get_object_display_message(object)
    values = []
    object.display_fields.each do |field|
      values << object.send(field)
    end
    values
  end
  
  # LookUp Hash for the menu item to the class name
  #
  # Hash
  def menu_to_class_name
    {"user" => User, "collaborator" => Collaborator, "assignment" => Assignment, "link" => Link}
  end
  
  # LookUp Hash to get the menu title, based on the class and action
  #
  # returns a String
  def menu_title_hash_by_action(class_string)
    {"show" => "Here are all the #{class_string.pluralize}.", "update" => "Which #{class_string} do you want to update?", "delete" => "Which #{class_string} do you want to delete?", "create" => "Enter the variables to create a new #{class_string}."}
  end

end
