require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
require_all 'app'

# require 'bundler/setup'
# require 'io/console'
# Bundler.require

# ActiveRecord::Base.establish_connection(
#   adapter: 'sqlite3',
#   database: "db/development.sqlite"
# )

# require_all 'app'
