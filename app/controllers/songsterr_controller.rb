require 'helpers/songsterr_scraper'

class SongsterrController < ApplicationController

  @scraper = SongsterrScraper.new

  get '/search' do |name|
    @scraper.search_artists(params['artist']) if params['artist']
    @scraper.search_songs(params['song'])     if params['song']
  end

  get '/song/:id' do |id|
    begin
      @scraper.load_song(id)
    rescue
      "song not found"
    end
  end
end
