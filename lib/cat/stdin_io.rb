# frozen_string_literal: true

class Cat
  class StdinIO
    def self.open(_path, &block)
      block.call $stdin
    end
  end
end
