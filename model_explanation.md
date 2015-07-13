#Assignment
 - id
 - name
 - description
 - where_stored

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