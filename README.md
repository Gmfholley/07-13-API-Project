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
 | 1 | "Wendy"

The relationship of these tables can be summed up as follows:

 - Assignments can have many Links.
 - Links only has one Assignment.
 - (Users can have many Assignments; Assignments can have many Users.  The link between these two is the Collaborator.)

Assignment and User have some instance methods to check if they have collaborators.  Because the Collaborator object is not itself a useful object, the method runs a SQL Join statement to return User or Assignment objects instead.

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

The class method calling for all objects is handled here:

```ruby
    # returns all records in database
    #
    # returns Array of Objects of the resulting records
    def all_hash
      CONNECTION.execute("SELECT * FROM #{table_name};")
    end
```

The instance method turning this object into a hash is here and just cycles through each of the display fields in the object.  (The display fields are another method in the DatabaseConnector module that return all of the instance variables except id and errors.  It can be overwritten in any particular model to suit privacy concerns.)

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

Basic CRUD functionality is available in the main_controller.rb file in the controller folder of Sinatra.  A menu structure with helper classes (Menu, MenuItem, and MethodToCall) are all in the same folder.  These menu structures allow you to use the same two erb files (create and menu) to extend CRUD functionality to any model that has the DatabaseConnector module included. 

In order to use a new model, you do need to add it to the home menu in the `defined_menus.rb` file in the controller folder.  Here you add a new MenuItem for each model you want to work with.  For this case, there are four models, so there are four menu items.  The `method_name` should match the url you want to use to refer to this Class.

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

You also need to convert your preferred url name to the class name in the same file in the `menu_to_class_name` method, which is just a Hash converting the urls to Classes.

```ruby
  # LookUp Hash for the menu item to the class name
  #
  # Hash
  def menu_to_class_name
    {"user" => User, "collaborator" => Collaborator, "assignment" => Assignment, "link" => Link}
  end
```

Having done that, you're done!  You can run Sinatra and get a web UX for basic CRUD operations.

##API

The CRUD operations with web UX above are all handled with requests that return complete html pages.  The API does not load the page but instead uses AJAX to connect to the server.

API request controllers are found in the `api_controller.rb` file.  This API duplicates the CRUD functionality above, but instead of returning 


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