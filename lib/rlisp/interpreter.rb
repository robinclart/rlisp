module Rlisp
  class Interpreter
    def initialize(trees)
      @trees = trees
    end

    UnknownNode = Class.new(Error)

    def interpret
      @trees.map do |tree|
        interpret_node(tree)
      end
    end

    private

    def interpret_node(node)
      case node.first
      when :list
        node.last.map { |n| interpret_node(n) }
      when :atom
        node.last.to_sym
      when :integer
        Integer(node.last)
      when :boolean
        node.last == "true"
      when :float
        Float(node.last)
      when :string
        node.last
      when :lambda
        :lambda
      else
        raise UnknownNode, "Unknown node: #{node.inspect}"
      end
    end
  end
end
