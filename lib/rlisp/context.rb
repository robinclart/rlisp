module Rlisp
  class Context
    def initialize(env = {}, outer = nil, buffer = "")
      @buffer = buffer
      @env    = env
      @outer  = outer
    end

    attr_reader :buffer, :env

    def get(key)
      @env[key] || Function::NATIVE[key] || (@outer && @outer.get(key))
    end

    def eval(interpretation)
      args = interpretation.clone

      if args.is_a?(Symbol)
        return get(args) || args.to_s
      end

      unless args.is_a?(Array)
        return args
      end

      key  = args.shift
      fn   = get(key)

      fn.call(self, args)
    end
  end
end
