class Country
  include Comparable::InstanceMethods

  attr_reader :code, :name

  def initialize(code, name)
    @code = code
    @name = name
  end
end
