class User
  include DatabaseConnector
  
  attr_reader :id, :name, :errors
  
  def initialize(args={})
    @id = args[:id] || args["id"]
    @name = args[:name] || args["name"]
    @errors = []
    post_initialize
  end
  
  
  
end