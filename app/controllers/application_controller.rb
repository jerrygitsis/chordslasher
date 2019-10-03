require 'sinatra/json'

class ApplicationController < Sinatra::Base

  get '/songs/:id' do
    #single song from db
  end

  get '/songs/' do
    #list all songs from
  end
end
