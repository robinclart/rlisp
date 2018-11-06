module Rlisp
  class Function
    def initialize(formals, body)
      @formals = formals
      @body    = body
    end

    attr_reader :formals, :body

    def self.qualified_name(key, arity)
      "#{key}/#{arity}".to_sym
    end

    def arity
      @formals.size
    end

    def call(outer_ctx, *args)
      ctx = Context.new(env: {}, outer: outer_ctx, buffer: outer_ctx.buffer)

      formals.each_with_index do |arg, index|
        ctx.env[arg] = outer_ctx.eval(args[index])
      end

      ctx.eval(body)
    end
  end
end
