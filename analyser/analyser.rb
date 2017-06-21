require './screenshot'
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

    if current_screen
      puts "Filename #{image} is of type #{current_screen}"
      event = current_screen.extract_event(image)

      puts "Event #{event.inspect} extracted"

      return event
    end
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
      LoadingScreen
    ]
  end
end