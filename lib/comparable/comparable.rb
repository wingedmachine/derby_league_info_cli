module Comparable
  module InstanceMethods
    def ==(other)
      self.class == other.class && self.state == other.state
    end

    def state
      self.instance_variables.map { |variable| self.instance_variable_get variable }
    end
  end
end
