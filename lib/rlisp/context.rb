module Rlisp
  class Context
    def initialize(env: {}, outer: Native.new, buffer: "")
      @buffer = buffer
      @env    = env
      @outer  = outer
    end

    attr_reader :buffer, :env

    def get(key, arity: nil)
      if arity
        function_name = Function.qualified_name(key, arity)
        @env.fetch(function_name) { @outer.get(key, arity: arity) || get(key) }
      else
        @env.fetch(key) { @outer.get(key) }
      end
    end

    def get_function(key, arity)
    end

    def eval(interpretation)
      args = interpretation.clone

      if args.is_a?(Symbol)
        return get(args) || args.to_s
      end

      unless args.is_a?(Array)
        return args
      end

      if args.empty?
        return []
      end

      key = args.shift
      fn  = get(key, arity: args.size)

      unless fn
        raise Error, "#{key}/#{args.size} could not be found"
      end

      fn.call(self, *args)
    end
  end
end
