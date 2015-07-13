CONNECTION=SQLite3::Database.new("assignments.db")
CONNECTION.results_as_hash = true
CONNECTION.execute("PRAGMA foreign_keys = ON;")

# #Assignment
#  - id
#  - name
#  - description
#  - where_stored
#
# ###Methods
#  - collaborators
#  - links
#  - collaborator?
#  - link?
#
# #Link
#  - id
#  - name
#  - assignment_id
#  - description
#  - where_stored
#
# #Collaborator
#  - id
#  - assignment_id
#  - user_id
#
#
# #User
#  - id
#  - name
 
CONNECTION.execute("CREATE TABLE IF NOT EXISTS assignments (id INTEGER PRIMARY KEY, name TEXT NOT NULL, description TEXT NOT NULL, where_stored TEXT NOT NULL);")

CONNECTION.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT NOT NULL);")

CONNECTION.execute("CREATE TABLE IF NOT EXISTS collaborators (id INTEGER PRIMARY KEY, assignment_id INTEGER NOT NULL, user_id INTEGER NOT NULL, FOREIGN KEY(assignment_id) REFERENCES assignments(id), FOREIGN KEY(user_id) REFERENCES users(id));")

CONNECTION.execute("CREATE TABLE IF NOT EXISTS links (id INTEGER PRIMARY KEY, name TEXT NOT NULL, description TEXT NOT NULL, assignment_id INTEGER NOT NULL, where_stored TEXT NOT NULL, FOREIGN KEY (assignment_id) REFERENCES assignments(id));")
