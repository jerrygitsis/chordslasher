require 'sinatra/base'
require 'active_record'

puts "Starting chordslasher..."
#figure out load path sheet
$LOAD_PATH.unshift('./app')


puts "connecting to db"
ActiveRecord::Base.establish_connection({
  adapter: 'mysql2',
  encoding: 'unicode',
  database: 'mysql://db:33060/chordslasher_db',
  pool: 2,
  username: 'starbuck',
  password: 'moby_dick'
})


["application_controller", "songsterr_controller"].each do |file|
  require "controllers/#{file}"
end

map('/')          { run ApplicationController }
map('/songsterr') { run SongsterrController }