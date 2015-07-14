#API for My Assignments

The purpose of this API is to provide a data service and basic CRUD functionality to my Assignments models.  The API returns JSON.  Sinatra is currently used to handle requests/responses from the client.  My model is built using Ruby and a gem called SQLite3, which allows Ruby to interact with SQLite, a relational database management system.

I have four models and four tables.


#Assignment

| id | name | description | where_stored |
| -- | ---- | ----------- | ------------- |
| INTEGER PRIMARY KEY | TEXT NOT NULL | TEXT NOT NULL | TEXT NOT NULL |
| 1 | API Assignments Project | Create a data service and basic CRUD functionality for assignments | here, at Github |



###Methods
 - collaborators
 - links
 - collaborator?
 - link?

#Link
 - id
 - assignment_id
 - description
 - where_stored

#Collaborator
 - id
 - assignment_id
 - user_id


#User
 - id
 - name


Assignment can have many Media

Media only has one Assignment

(Users can have many Assignments;
Assignments can have many Users)


Described using Collaborators bridge table