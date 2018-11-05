module Rlisp
  class Function
    NATIVE = {
      capture: Proc.new { |ctx, args|
        capture_ctx = Context.new(env: {}, outer: ctx, buffer: "")

        capture_ctx.eval(args[0])

        capture_ctx.buffer
      },
      display: Proc.new { |ctx, args|
        ctx.buffer << ctx.eval(args[0]).to_s
        nil
      },
      format: Proc.new { |ctx, args|
        spec = args[0]
        list = ctx.eval(args[1])

        spec % list
      },
      def: Proc.new { |ctx, args|
        if args.size == 3
          key     = args[0]
          formals = args[1]
          body    = args[2]

          fn = Function.new(formals, body)

          ctx.env[key] = fn
        else
          key = args[0]
          fn  = ctx.eval(args[1])

          ctx.env[key] = fn
        end

        args.first
      },
      list: Proc.new { |ctx, args|
        args.map { |arg| ctx.eval(arg) }
      },
      quote: Proc.new { |ctx, args|
        args
      },
      lambda: Proc.new { |ctx, args|
        formals = args[0]
        body    = args[1]

        Function.new(formals, body)
      },
      add: Proc.new { |ctx, args|
        j = ctx.eval(args[0])
        k = ctx.eval(args[1])

        j + k
      },
      sub: Proc.new { |ctx, args|
        j = ctx.eval(args[0])
        k = ctx.eval(args[1])

        j - k
      },
      map: Proc.new { |ctx, args|
        if args.size == 3
          formals = args[0]
          body    = args[1]
          list    = ctx.eval(args[2])

          fn = Function.new(formals, body)
        else
          fn   = ctx.eval(args[0])
          list = ctx.eval(args[1])
        end

        list.map { |arg| fn.call(ctx, [arg]) }
      },
      "string-to-integer": Proc.new { |ctx, args|
        Integer(ctx.eval(args[0]))
      },
    }

    def initialize(formals, body)
      @formals = formals
      @body    = body
    end

    attr_reader :formals, :body

    def call(outer_ctx, args)
      ctx = Context.new(env: {}, outer: outer_ctx, buffer: outer_ctx.buffer)

      formals.each_with_index do |arg, index|
        ctx.env[arg] = outer_ctx.eval(args[index])
      end

      ctx.eval(body)
    end
  end
end
