require 'phashion'
require './screenshot'
require './screens/race_screen'
require './screens/race_result_screen'
require './screens/match_result_screen'
require './screens/loading_screen'

class Analyser
  def self.analyse!(filename)
    new(filename).analyse!
  end

  attr_reader :image

  def initialize(filename)
    @image = Screenshot.new(filename)
  end

  def analyse!
    current_screen = screens.find do |screen|
      screen.matches_image?(image)
    end

    sort_image(image, current_screen)

    if current_screen
      puts "Filename #{image} is of type #{current_screen}"
      event = current_screen.extract_event(image)

      puts "Event #{event.inspect} extracted"

      if event
        event.merge!(timestamp: image.timestamp)
      end

      return event
    end
  end

  def sort_image(image, current_screen)
    directory = "./classified/" + (current_screen || "Unsorted").to_s
    Dir.mkdir(directory) unless Dir.exists?(directory)
    image.working.write("#{directory}/#{File.basename(image.filename)}")
  end

  # Detect if main menu
  # Detect if loading screen
  # Detect if start race screen
  #   (attempt to gather race name)
  # Detect if mid race screen
  #   (attempt to gather positions/items/coins for each player)
  # Detect if race results screen
  #   (attempt to gather positions/points for each player)
  # Detect if results screen
  #   (attempt to gather positions/points for each player)
  def screens
    [
      LoadingScreen,
      RaceScreen,
      RaceResultScreen,
      MatchResultScreen
    ]
  end
end