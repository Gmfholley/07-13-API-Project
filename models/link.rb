class Link
  include DatabaseConnector
  
  attr_accessor :description, :where_stored, :name
  attr_reader :assignment_name, :assignment_id
  
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
  
end

# - id
# - assignment_id
# - description
# - where_stored
