class Assignment
  
  include DatabaseConnector
  
  attr_accessor :name, :description, :where_stored
  attr_reader :errors, :id
  
  def initialize(args={})
    @id = args[:id] || args["id"]
    @name = args[:name] || args["name"]
    @description = args[:description] || args["description"]
    @where_stored = args[:where_stored] || args["where_stored"]
    @errors = []
  end
  
  def display_fields
    ["name", "description", "where_stored"]
  end
  
  
  def self.ok_to_delete?(id)
    Collaborator.where_match("assignment_id", id, "==").length == 0 && Link.where_match("assignment_id", id, "==").length == 0
  end
  
  
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
    if rec.blank?
      []
    else
      User.as_objects(rec)
    end
  end
  
  # get the Array of Collaborator objects for this Assignment
  #
  # returns an Array
  def links
    Link.where_match("assignment_id", id, "==")
  end
  
  # returns a Boolean indicating if there are any collaborators
  #
  # returns Boolean
  def collaborators?
    collabors.length > 0
  end
  
  # returns a Boolean indicating if there are any links
  #
  # returns Boolean
  def links?
    links.length > 0
  end
  
  
end