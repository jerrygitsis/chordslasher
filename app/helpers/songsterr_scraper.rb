require 'nokogiri'
require 'httparty'

class SongsterrScraper

  attr_accessor :page

  def initialize(song_id = nil)
    load_song(song_id) if song_id
  end

  def artist
    @heading_text.split("-").first.strip
  end

  def title
    @heading_text.split("-")[1].strip
  end

  def chords
    body.css(".chord").collect{ |chord| chord.text }
  end

  def to_json
    JSON.generate({
      artist: artist,
      title: title,
      chords: chords
    })
  end

  def load_song(song_id)
    doc = HTTParty.get("http://www.songsterr.com/a/wsa/chords-s#{song_id}")
    @page = Nokogiri::HTML(doc)
    raise "Song not found." if page.css(".DMMessagePage").size > 0
    @heading_text = parse_heading_text
  end

  def search_artists(artist_name)
    search = HTTParty.get("http://www.songsterr.com/a/ra/songs/byartists.xml?artists=#{artist_name}")
    xml = Nokogiri::XML(search.body)
    # todo

  end

  def search_songs(song_name)
    search = HTTParty.get("http://www.songsterr.com/a/ra/songs.xml?pattern=#{song_name}")
    xml = Nokogiri::XML(search.body)
    songs = xml.children.children.map do |node|
      if node.elem? and node.css("chordsPresent").text == 'true'
        {
          id: node.attribute('id').value.to_i,
          title: node.css('title').text,
          artist: {
            id: node.css("artist").attribute('id').value.to_i,
            name: node.css("artist").css("name").text
          }
        }
      end
    end

    JSON.generate(songs.compact)
  end

  private

  def parse_heading_text
    words = page.css(".inlineHeading").text.split
    raise "WARNING! Last word of heading was not 'Chords'" if words.pop != "Chords" 
    words.join(" ")
  end

  def body
    page.css(".chords-content")
  end
end
