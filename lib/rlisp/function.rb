module Rlisp
  class Function
    NATIVE = {
      display: Proc.new { |ctx, args|
        ctx.buffer << args.map { |i| ctx.eval(i) }.join
        nil
      },
      format: Proc.new { |ctx, args|
        specification = args.shift

        specification % args.map { |i| ctx.eval(i) }
      },
      def: Proc.new { |ctx, args|
        ctx.env[args.first] = ctx.eval(args.last)
        args.first
      },
      list: Proc.new { |ctx, args|
        args.map { |i| ctx.eval(i) }
      },
      quote: Proc.new { |ctx, args|
        args
      },
      lambda: Proc.new { |ctx, args|
        formals = args.first
        body    = args.last

        Function.new(formals, body)
      },
      add: Proc.new { |ctx, args|
        n = ctx.eval(args.shift)
        args.reduce(n) { |m, i| m + ctx.eval(i) }
      },
      sub: Proc.new { |ctx, args|
        n = ctx.eval(args.shift)
        args.reduce(n) { |m, i| m - ctx.eval(i) }
      },
      map: Proc.new { |ctx, args|
        if args.size == 3
          formals = args[0]
          body    = args[1]
          list    = ctx.eval(args[2])

          fn = Function.new(formals, body)
        else
          fn   = ctx.eval(args.first)
          list = ctx.eval(args.last)
        end

        list.map { |item| fn.call(ctx, [item]) }
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
