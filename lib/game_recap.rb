class GameRecap
  attr_reader :author, :datetime, :year, :event, :location, :game_number, \
    :teams, :url

  # Ideally, the strings in @teams would be replaced by the League objects
  # they refer to, but correlating a string containing a league's nickname
  # to an object containing it's full name is a non-trivial task beyond the
  # scope of this assignment.

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
