require 'rubygems'
require 'bundler/setup'

require 'date'                   # ruby's built-in date function
require 'chronic'                # gem that parses date/time
require 'sqlite3'                # gem that handles database
require 'pry'                    # gem that handles debugging
require 'sinatra'                # gem that handles html views & controller
require 'sinatra/reloader'       # reloads sinatra without reloading
require 'sinatra/json'           # converts to JSON
require 'active_support'         # all kinds of goodies! including blank?, underscore, humanize, pluralize
require 'httparty'               # allows you to bind your ip address and allow others on the same network to access your server using a request
require 'bcrypt'                 # encrypts your software

require 'active_support/core_ext/string/filters.rb'
require 'active_support/core_ext/object/blank.rb'
require 'active_support/inflector.rb'


# set your ip address here
# set :bind, '192.168.1.69'
set :sessions, true # sets sessions in Sinatra to true, they are false by default

configure :development do
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'assignments.db')
end

# Database set up modules and helper classes required by models

require_relative 'foreign_key.rb'
require_relative 'database_connector.rb'
require_relative 'database_setup.rb'

# models

require_relative 'models/user.rb'
require_relative 'models/assignment.rb'
require_relative 'models/link.rb'
require_relative 'models/collaborator.rb'
# require_relative 'models/exercise_event.rb'

# controllers

require_relative 'controllers/menu.rb'
require_relative 'controllers/menu_item.rb'
require_relative 'controllers/method_to_call.rb'

require_relative 'controllers/defined_menus.rb'
require_relative 'controllers/menu_controller.rb'
require_relative 'controllers/create_controller.rb'
require_relative 'controllers/local_variable_methods.rb'
require_relative 'controllers/login_helper.rb'
require_relative 'controllers/api_controller.rb'
require_relative 'controllers/login_controller.rb'
require_relative 'controllers/main_controller.rb'


# views are in views folder

helpers DefinedMenus, MenuController, CreateController, ERBVariableMethods, LoginHelper

