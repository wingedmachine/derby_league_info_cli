module Listable
  module ClassMethods
  end

  module InstanceMethods
    attr_reader :core

    def initialize(var)
      @core = var
    end

    def ==(other)
      self.class == other.class && self.core == other.core
    end
  end
end
