module Rlisp
  class Parser
    def initialize(tokens)
      @tokens = tokens
    end

    UnexpectedToken = Class.new(Error)

    def parse
      trees = []

      until @tokens.empty?
        t = consume

        if type?(t, :start_list)
          trees << parse_list
        elsif simple_value?(t)
          trees << t.clone
          next
        else
          raise UnexpectedToken, "Unexpected token: #{t.inspect}"
        end
      end

      trees
    end

    private

    def parse_list
      children = []

      loop do
        t = consume

        if type?(t, :end_list)
          break
        elsif type?(t, :start_list)
          children << parse_list
          next
        elsif simple_value?(t)
          children << t.clone
          next
        else
          raise UnexpectedToken, "Unexpected token: #{t.inspect}"
        end
      end

      [:list, children]
    end

    def consume
      @tokens.shift
    end

    def simple_value?(t)
      type?(t, :boolean)   ||
        type?(t, :atom)    ||
        type?(t, :string)  ||
        type?(t, :integer) ||
        type?(t, :float)   ||
        type?(t, :lambda)
    end

    def type?(x, type)
      return false unless x
      x.first == type
    end
  end
end
