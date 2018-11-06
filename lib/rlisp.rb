require "strscan"

module Rlisp
  Error = Class.new(StandardError)

  require "rlisp/lexer"
  require "rlisp/parser"
  require "rlisp/interpreter"
  require "rlisp/function"
  require "rlisp/context"
  require "rlisp/native"
  require "rlisp/version"

  def self.eval(source, buffer = $stdout)
    tokens          = Rlisp::Lexer.new(source).lex
    trees           = Rlisp::Parser.new(tokens).parse
    interpretations = Rlisp::Interpreter.new(trees).interpret

    ctx = Rlisp::Context.new(env: {}, buffer: buffer)

    results = interpretations.map do |interpretation|
      ctx.eval(interpretation)
    end

    results.last
  end
end
