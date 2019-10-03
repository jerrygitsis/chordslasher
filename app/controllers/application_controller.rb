require 'sinatra/json'

class ApplicationController < Sinatra::Base

  get '/songs/:id' do
    #single song
  end

  get '/songs/' do
    #index
  end
end
