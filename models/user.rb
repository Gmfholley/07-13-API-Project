class User
  include DatabaseConnector
  
  attr_reader :id, :name, :errors
  
  def initialize(args={})
    @id = args[:id] || args["id"]
    @name = args[:name] || args["name"]
    @errors = []
    post_initialize
  end
  
  
  # get the Array of Assignment objects for this Assignment
  #
  # returns an Array
  def assignments
    query_string = 
    "SELECT assignments.id AS id, assignments.name AS name, assignments.description AS description,    
            assignments.where_stored AS where_stored
    FROM collaborators
    JOIN assignments ON assignments.id == collaborators.assignment_id
    WHERE collaborators.user_id = #{id};"
    
    rec = run_sql(query_string)
    Assignment.as_objects(rec)
  end
  
  # returns a Boolean indicating if there are any collaborators
  #
  # returns Boolean
  def assignments?
    assignments.length > 0
  end
  
  def self.ok_to_delete?(id)
    Collaborator.where_match("user_id", id, "==").length == 0
  end
  
  
end