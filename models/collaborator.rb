class Collaborator
  
  include DatabaseConnector
  
  attr_reader :id, :user_id, :assignment_id, :assignment_name, :user_name, :errors
  
  def initialize(args={})
    @id = args[:id] || args["id"]
    @assignment_id = ForeignKey.new(id: args["assignment_id"], class_name: Assignment)
    @user_id = ForeignKey.new(id: args["user_id"], class_name: User)
    
    
    @assignment_name = args["assignment_name"]
    @user_name = args["user_name"]
    @errors = []
    post_initialize
  end
  
  # returns the Assignment Foreign Key object
  #
  # returns ForeignKey
  def assignment
    assignment_id.get_object
  end
  
  # sets the duration id
  #
  # new_id - Integer
  #
  # returns the Foreign Key
  def assignment_id=(new_id)
    if allow_editing?
      @assignment_id = ForeignKey.new(id: new_id, class_name: Assignment)
      @assignment_name = assignment.name
    end
  end
  
  # returns the Assignment Foreign Key object
  #
  # returns ForeignKey
  def user
    user_id.get_object
  end
  
  # sets the duration id
  #
  # new_id - Integer
  #
  # returns the Foreign Key
  def user_id=(new_id)
    if allow_editing?
      @user_id = ForeignKey.new(id: new_id, class_name: User)
      @user_name = user.name
    end
  end
  
  # Array of the field names for this object from the database
  # NOTE:
  # An over write of the database_connector method, which assumes all parameters are field names
  # This object stores extra variables so as to make fewer trips to the database
  #     but these extra variables are not stored in the database.
  #
  # returns Array of strings
  def database_field_names
    ["user_id", "assignment_id"]
  end
  
  # Array of methods/parameters that should be displayed
  #
  # returns an Array of strings
  def display_fields
    ["user_name", "assignment_name"]
  end
  
  # over-writes the all database_connector method for efficiency because this object has four foreign keys
  # returns all ExerciseEvents
  #
  # returns Array of Objects
  def self.all
    query_string = 
    "SELECT collaborators.id, collaborators.user_id, users.name AS user_name, collaborators.assignment_id, assignments.name AS assignment_name
    FROM collaborators
    JOIN assignments ON assignments.id == collaborators.assignment_id
    JOIN users ON users.id == collaborators.users_id
    ORDER BY users.name ASC;"
    
    results = run_sql(query_string)
    self.as_objects(results)
  end
  
  # over-writes the all database_connector method for efficiency because this object has four foreign keys
  # returns this ExerciseEvent
  #
  # id - Integer of the id
  #
  # returns ExerciseEvent
  def self.create_from_database(id)
    query_string = 
    "SELECT collaborators.id, collaborators.user_id, users.name AS user_name, collaborators.assignment_id, assignments.name AS assignment_name
    FROM collaborators
    JOIN assignments ON assignments.id == collaborators.assignment_id
    JOIN users ON users.id == collaborators.users_id
    WHERE collaborators.id = #{id};"
    
    rec = run_sql(query_string).first
    if rec.nil?
      self.new
    else
      self.new(rec)
    end
  end
  
  
  
end

# - id
# - assignment_id
# - user_id
