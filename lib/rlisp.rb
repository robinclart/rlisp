require "strscan"

module Rlisp
  Error = Class.new(StandardError)

  require "rlisp/lexer"
  require "rlisp/parser"
  require "rlisp/interpreter"
  require "rlisp/function"
  require "rlisp/context"
  require "rlisp/version"

  def self.eval(source)
    tokens          = Rlisp::Lexer.new(source).lex
    trees           = Rlisp::Parser.new(tokens).parse
    interpretations = Rlisp::Interpreter.new(trees).interpret

    ctx = Rlisp::Context.new

    results = interpretations.map do |interpretation|
      ctx.eval(interpretation)
    end

    [results.last, ctx.buffer]
  end
end
