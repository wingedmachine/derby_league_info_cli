class Country
  include Comparable::InstanceMethods

  attr_reader :code, :leagues, :name

  def initialize(country_hash)
    @code = country_hash[:code]
    @name = country_hash[:name]
    @leagues = []
  end

  def add_league(league)
    @leagues << league unless @leagues.include?(league)
  end
end
