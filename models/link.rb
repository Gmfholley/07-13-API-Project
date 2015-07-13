class Link
  include DatabaseConnector
  
  attr_accessor :description, :where_stored, :name
  attr_reader :assignment_name, :assignment_id, :errors, :id
  
  def initialize(args={})
    @id = args[:id] || args["id"]
    @assignment_id = ForeignKey.new(id: args["assignment_id"], class_name: Assignment)
    @description = args[:description] || args["description"]
    @where_stored = args[:where_stored] || args["where_stored"]
    @name = args[:name] || args["name"]
    
    @assignment_name = args["assignment_name"]
    @errors = []
    post_initialize
  end
  
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
  
  # Array of the field names for this object from the database
  # NOTE:
  # An over write of the database_connector method, which assumes all parameters are field names
  # This object stores extra variables so as to make fewer trips to the database
  #     but these extra variables are not stored in the database.
  #
  # returns Array of strings
  def database_field_names
    ["name", "assignment_id", "description", "where_stored"]
  end
  
  # Array of methods/parameters that should be displayed
  #
  # returns an Array of strings
  def display_fields
    ["name", "assignment_name", "description", "where_stored"]
  end
  
  # over-writes the all database_connector method for efficiency because this object has four foreign keys
  # returns all ExerciseEvents
  #
  # returns Array of Objects
  def self.all
    query_string = 
    "SELECT links.id, links.name, links.description,    
            links.assignment_id, links.where_stored, assignments.name AS assignment_name
    FROM links
    JOIN assignments ON assignments.id == links.assignment_id
    ORDER BY links.id ASC;"
    
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
    "SELECT links.id, links.name, links.description,    
            links.assignment_id, links.where_stored, assignments.name AS assignment_name
    FROM links
    JOIN assignments ON assignments.id == links.assignment_id
    WHERE links.id = #{id};"
    
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
# - description
# - where_stored
