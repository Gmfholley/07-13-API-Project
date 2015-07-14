#API for My Assignments

The purpose of this API is to provide a data service and basic CRUD functionality to my Assignments models.  The API returns JSON.  Sinatra is currently used to handle requests/responses from the client.  My model is built using Ruby and a gem called SQLite3, which allows Ruby to interact with SQLite, a relational database management system.

I have four models and four tables.


#Assignment

| id | name | description | where_stored |
|----|------|-------------|---------------|
| INTEGER PRIMARY KEY | TEXT NOT NULL | TEXT NOT NULL | TEXT NOT NULL |
| 1 | "API Assignments Project" | "Create a data service and basic CRUD functionality for assignments" | "here, at Github" |

#Link

| id | name | assignment_id | description | `where_stored` |
|----|------|-------------|---------------|----------------|
| INTEGER PRIMARY KEY | TEXT NOT NULL | INTEGER FOREIGN KEY NOT NULL | TEXT NOT NULL | TEXT NOT NULL |
| 1 | "What is CRUD?" | 1 | "Blog entry describing the first assignment" | "http://myblog.com" |

#Collaborator

| id | `assignment_id` | user_id |
|----|------|-------------|
| INTEGER PRIMARY KEY | INTEGER FOREIGN KEY NOT NULL | INTEGER FOREIGN KEY NOT NULL |
| 1 | 1 | 2|


#User 

| id | name |
|----|------|
| INTEGER PRIMARY KEY | TEXT NOT NULL |
| 1 | "Wendy"|

The relationship of these tables can be summed up as follows:

 - Assignments can have many Links.
 - A Link only has one Assignment.
 - Users can have many Assignments; Assignments can have many Users.  The relationship between these two is the Collaborator model.

Assignment and User have some instance methods to check if they have collaborators.  Because the Collaborator object is not itself a useful object, the method runs a SQL Join statement to return User or Assignment objects instead.  Below is an example of this method in Assignment to return an Array of User objects.

```ruby
 # get the Array of User objects for this assignments collaborators
 #
 # returns an Array
 def collaborators
   query_string = 
   "SELECT users.id AS id, users.name AS name
   FROM collaborators
   JOIN users ON users.id == collaborators.user_id
   WHERE collaborators.assignment_id = #{id};"
   rec = run_sql(query_string)
   User.as_objects(rec)
 end
  
  # returns a Boolean indicating if there are any collaborators
  #
  # returns Boolean
  def collaborators?
    collabors.length > 0
  end
```

Each of the models have instance and class database methods provided by the DatabaseConnector Module.

The API returns JSON, and Sinatra can only convert hashes into JSON.  So a method to convert objects into hashes is included in the DatabaseConnector module.

The class method was easy, because SQLite actually returns a Hash from the database.  The `all_hash` method (equivalent to the `all` method but returning an Array of Hashes instead of Objects, is below.

```ruby
    # returns all records in database
    #
    # returns Array of Objects of the resulting records
    def all_hash
      CONNECTION.execute("SELECT * FROM #{table_name};")
    end
```

The instance method is called `self_hash` and cycles through each of the display fields in the object, adding its name and value.  `display_fields` is a method in the DatabaseConnector Module returning an Array of Strings of the variables to display to the user.  The default is to display all instance variables except for id and errors.  But it can be overwritten in any particular model to suit the needs of that model.

```ruby
  # returns a hash of the self with all instance variables
  #
  # returns a Hash
  def self_hash
    hash = {}
    hash["id"] = self.send("id")
    display_fields.each do |var|
      hash[var] = self.send(var)
    end
    hash
  end
```

The basic CRUD controller is found in the `main_controller.rb` file.  A menu structure with helper classes (Menu, MenuItem, and MethodToCall) are all in the same folder.  These menu structures allow you to use the same two erb files (create and menu) for all CRUD functions of any model that has the DatabaseConnector Module included. 

In order to add a new model to the controller, you need to add it as a MenuItem to the `home_menu` method in `defined_menus.rb` (found in the controllers folder).  Add a new MenuItem for each model you want to work with.  In this case, there are four models, so there are four menu items.  The `method_name` should match the url you want to use to refer to this Class.  It can be anything.  Pick something you think works.

```ruby
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
```

Then you need to tell the controller how to convert that preferred url name to the class name.  Add it as a key/value pair in the `menu_to_class_name` Hash.  This Hash is found in the same defined_menus.rb` file.

```ruby
  # LookUp Hash for the menu item to the class name
  #
  # Hash
  def menu_to_class_name
    {"user" => User, "collaborator" => Collaborator, "assignment" => Assignment, "link" => Link}
  end
```

Having done that, you're done!  You can run Sinatra and get a web UX for basic CRUD operations on your model.

##API

The CRUD operations with web UX above are all handled with requests that return complete html pages. The API, instead, uses AJAX and returns JSON.  This API duplicates the CRUD functionality above.

API request controllers are found in the `api_controller.rb` file.  

Here is an example of an API controller request to return all the link objects and just one link by its id.  The objects are prepared in Hash form and the return is 'json ????'.  The json prefix to the return line is a Sinatra command that converts the Hashes into JSON.

```ruby
  get "/api/links" do
    @links = Link.all_hash
    json @links
  end

  get "/api/links/:id" do
    @link = Link.create_from_database(params["id"]).self_hash
    json @link
  end
```

You can also create, update, and delete objects using the API controller.

To create or update, you need to send the parameters and their values in the url after a ?.  For example, the request for a new user with a route handler of "/api/user/submit" might be: "/api/user/submit?id=&name=wendy".  If you send it exactly that way, the variables are stored in params by Sinatra, and the code below will execute.  The return method returns the newly created object in JSON.  You can check if it saved correctly by checking the errors variable, which will be an empty Array if there were no errors.

```ruby
  get "/api/:class_name/submit" do
    class_variable(params["class_name"])
    @m = @class_name.new(params["create_form"])
    @m.save_record
    hash = @m.self_hash
    hash["errors"] = @m.errors  
    json hash
  end
```

To delete an object, use the route handler below.  It returns back an Array of all the rest of the class's objects if successful or an empty Array if it was not able to delete (usually due to foreign key restraints).

```ruby
  get "/api/:class_name/delete/:x" do
    class_variable(params["class_name"])
    if @class_name.delete_record(params["x"].to_i)
      @all = @class_name.all_hash
      json @all
    else
      json []
    end
  end
```