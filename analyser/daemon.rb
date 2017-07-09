require "net/http"
require "uri"
require 'active_support/all'
require './analyser'

glob = "dump/out*.jpg"

league_id = 'LcqfxfuOjc2CypJr908iOhI2'
kartistics_url = 'http://192.168.0.7:3000/api/kartalytics/ingest'

uri = URI.parse(kartistics_url)

Logger = ActiveSupport::Logger.new('analyser.log')

loop do
  events = []

  begin
    Dir.glob(glob).sort_by {|file|
      File.ctime(file)
    }.each do |filename|
      start = Time.now
      event = Analyser.analyse!(filename)

      puts "#{File.basename(filename)} => #{event.inspect} - Time taken: #{Time.now - start}"
      File.unlink(filename)

      if event
        events.push event
      end
    end
  rescue Magick::ImageMagickError => e
    puts "RMagick error #{e}"
  end

  if events.any?
    payload = {
      league_id: league_id,
      events: events
    }

    request = Net::HTTP::Post.new(uri.path)
    request.content_type = "application/json"
    request.body = payload.to_json

    puts request.body

    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end

    puts "Sending #{events.length} event(s). Response #{response.body}"
  end
  sleep(0.2)
end

