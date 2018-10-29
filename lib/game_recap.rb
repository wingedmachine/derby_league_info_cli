class GameRecap
  attr_reader :author, :datetime, :year, :event, :location, :game_number, \
    :teams, :url

  def initialize(recap)
    @author = recap[:author]
    @datetime = recap[:datetime]
    @year = recap[:year]
    @event = recap[:event]
    @location = recap[:location]
    @game_number = recap[:game_number]
    @teams = recap[:teams]
    @url = recap[:url]
  end
end
