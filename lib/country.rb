class Country
  include Comparable::InstanceMethods

  attr_reader :code, :leagues, :name

  def initialize(code, name)
    @code = code
    @leagues = []
    @name = name
  end

  def add_league(league)
    @leagues << league unless @leagues.include?(league)
  end
end
