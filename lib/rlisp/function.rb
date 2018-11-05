module Rlisp
  class Function
    NATIVE = {
      display: Proc.new { |ctx, args|
        ctx.buffer << args.map { |arg| ctx.eval(arg) }.join
        nil
      },
      format: Proc.new { |ctx, args|
        specification = args.shift

        specification % args.map { |arg| ctx.eval(arg) }
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
        n = ctx.eval(args.shift)
        args.reduce(n) { |memo, arg| memo + ctx.eval(arg) }
      },
      sub: Proc.new { |ctx, args|
        n = ctx.eval(args.shift)
        args.reduce(n) { |memo, arg| m - ctx.eval(arg) }
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
    }

    def initialize(formals, body)
      @formals = formals
      @body    = body
    end

    attr_reader :formals, :body

    def call(outer_ctx, args)
      ctx = Context.new({}, outer_ctx, outer_ctx.buffer)

      formals.each_with_index do |arg, index|
        ctx.env[arg] = outer_ctx.eval(args[index])
      end

      ctx.eval(body)
    end
  end
end
