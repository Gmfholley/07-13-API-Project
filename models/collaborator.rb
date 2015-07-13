class Collaborator
  
  include DatabaseConnector
  
  attr_reader :id, :user_id, :assignment_id, :assignment_name, :user_name, :errors
  
  def initialize(args={})
    @id = args[:id] || args["id"]
    @assignment_id = ForeignKey.new(id: args["assignment_id"], class_name: Assignment)
    @user_id = ForeignKey.new(id: args["user_id"], class_name: User)
    @assignment_name = args["assignment_name"] || set_assignment_name
    @user_name = args["user_name"] || set_user_name
    @errors = []
    post_initialize
  end
  
  def set_assignment_name
    return assignment.name
  end
  
  def set_user_name
    return user.name
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
  
  # returns an ExerciseObject that matches this date, person, and type
  #
  # returns an ExerciseObject
  def this_user_and_assignment
    rec = CONNECTION.execute("SELECT * FROM #{table} WHERE user_id = #{user.id} AND assignment_id = #{assignment.id};").first
    if rec.blank?
      Collaborator.new
    else
      Collaborator.new(rec)
    end
  end
  
  # returns Boolean to indicate if this date-person-exercise type is a duplicate of a different id in the datbase
  #
  # returns Boolean
  def duplicate_user_assignment?
    self.id != this_user_and_assignment.id && this_user_and_assignment.id != ""
  end
  
  
  # returns a Boolean indicating if data is valid to save into database
  #
  # returns a Boolean
  def valid?
    validate_field_types
    # only do a database query if you have good enough data to check the database
    if @errors.length == 0
      if duplicate_user_assignment?
        @errors << 
          {message: 
          "The database already has this user and assignment combination. It is record 
          #{this_user_and_assignment.id}. Change this assignment or user or the assignment or user of that record.", 
          variabe: "assignment_id, user_id"}
      end
    end   
    @errors.length == 0
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
    JOIN users ON users.id == collaborators.user_id
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
    JOIN users ON users.id == collaborators.user_id
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
