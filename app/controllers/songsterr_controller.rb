require 'helpers/songsterr_scraper'

class SongsterrController < ApplicationController

  before do
    @scraper = SongsterrScraper.new
    content_type :json
  end

  get '/search' do
    @scraper.search_songs(params['song']) if params['song']
  end

  get '/song/:id' do |id|
    begin
      @scraper.load_song(id)
      @scraper.to_json
    rescue
      "song not found"
    end
  end
end
