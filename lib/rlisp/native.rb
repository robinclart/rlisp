module Rlisp
  class Native
    class << self
      def native(name)
        @native = name.to_sym
      end

      def natives
        @natives ||= {}
      end

      def method_added(name)
        @natives ||= {}
        @natives[@native] = name.to_sym
        @native = nil

        super
      end
    end

    def get(name, arity: "*")
      return nil unless arity

      method_name = self.class.natives[Function.qualified_name(name, arity)] ||
                    self.class.natives[Function.qualified_name(name, "*")]

      method(method_name) if method_name
    end

    native "capture/1"
    def capture(context, value)
      capture_context = Context.new(env: {}, outer: context, buffer: "")
      capture_context.eval(value)

      capture_context.buffer
    end

    native "display/1"
    def display(context, value)
      context.buffer << context.eval(value).to_s

      nil
    end

    native "format/2"
    def format(context, spec, args)
      spec % context.eval(args)
    end

    native "def/3"
    def define_function(context, key, formals, body)
      fn = Function.new(formals, body)
      context.env["#{key}/#{fn.arity}".to_sym] = fn

      key
    end

    native "def/2"
    def define_variable(context, key, value)
      context.env[key] = context.eval(value)

      key
    end

    native "list/*"
    def list(context, *args)
      args.map { |arg| context.eval(arg) }
    end

    native "quote/*"
    def quote(context, *args)
      args
    end

    native "lambda/2"
    def build_lambda(context, formals, body)
      Function.new(formals, body)
    end

    native "add/2"
    def add(context, j, k)
      context.eval(j) + context.eval(k)
    end

    native "sub/2"
    def sub(context, j, k)
      context.eval(j) - context.eval(k)
    end

    native "map/3"
    def map_with_implicit_lambda(context, formals, body, args)
      fn   = Function.new(formals, body)
      list = context.eval(args)

      list.map { |arg| fn.call(context, arg) }
    end

    native "map/2"
    def map_with_explicit_lambda(context, key_or_body, args)
      fn   = context.eval(key_or_body)
      list = context.eval(args)

      list.map { |arg| fn.call(context, arg) }
    end

    native "string-to-integer/1"
    def string_to_integer(context, n)
      Integer(context.eval(n))
    end
  end
end
