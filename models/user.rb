class User
  include DatabaseConnector
  
  attr_reader :id, :name, :errors
  
  def initialize(args={})
    @id = args[:id] || args["id"]
    @name = args[:name] || args["name"]
    @errors = []
    post_initialize
  end
  
  
  # get the Array of Collaborator objects for this Assignment
  #
  # returns an Array
  def assignments
    collaborators = Collaborator.where_match("user_id", id, "==")
    assignments = []
    collaborators.each do |collaborator|
      assignments << Assignment.create_from_database(collaborator.assignment.id)
    end
    assignments
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