#API for My Assignments

The purpose of this API is to provide a data service and basic CRUD functionality to my Assignments models.  The API returns JSON.  Sinatra is currently used to handle requests/responses from the client.  My model is built using Ruby and a gem called SQLite3, which allows Ruby to interact with SQLite, a relational database management system.

I have four models and four tables.


#Assignment

| id | name | description | where_stored |
|----|------|-------------|---------------|
| INTEGER PRIMARY KEY | TEXT NOT NULL | TEXT NOT NULL | TEXT NOT NULL |
| 1 | "API Assignments Project" | "Create a data service and basic CRUD functionality for assignments" | "here, at Github" |

#Link
 - id
 - name
 - assignment_id
 - description
 - where_stored

| id | name | `assignment_id` | description | `where_stored` |
|----|------|-------------|---------------|
| INTEGER PRIMARY KEY | TEXT NOT NULL | INTEGER FOREIGN KEY NOT NULL | TEXT NOT NULL | TEXT NOT NULL |
| 1 | "What is CRUD?" | 1 | "Blog entry describing the first assignment" | "http://myblog.com" |

#Collaborator
 - id
 - assignment_id
 - user_id

| id | `assignment_id` | user_id |
|----|------|-------------|
| INTEGER PRIMARY KEY | INTEGER FOREIGN KEY NOT NULL | INTEGER FOREIGN KEY NOT NULL |
| 1 | 1 | 2|


#User
 - id
 - name
 
 | id | name |
 |----|------|
 | INTEGER PRIMARY KEY | TEXT NOT NULL |
 | 1 | "Wendy"

The relationship of these tables can be summed up as follows:

 - Assignments can have many Links.
 - Links only has one Assignment.
 - (Users can have many Assignments; Assignments can have many Users.  The link between these two is the Collaborator.)

Assignment and User have some instance methods to check if they have collaborators.

```ruby
  # get the Array of Collaborator objects for this Assignment
  #
  # returns an Array
  def collaborators
    Collaborator.where_match("assignment_id", id, "==")
  end
  
  # returns a Boolean indicating if there are any collaborators
  #
  # returns Boolean
  def collaborators?
    collabors.length > 0
  end
```

Because Sinatra is returning JSON, we also need to 