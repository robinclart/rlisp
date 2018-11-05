module Rlisp
  class Lexer
    def initialize(source)
      @scanner = StringScanner.new(source << "\n")
      @tokens = []
    end

    SyntaxError = Class.new(Error)

    def lex
      until eos?
        skip(/[[:space:]]+/)
        skip(/\n/)

        break if eos?

        next if lexeme :comment, %r/#/, discard_match_and_keep_until_eol: true
        next if lexeme :start_list, %r/\(/
        next if lexeme :end_list, %r/\)/
        next if lexeme :lambda, %r/->/
        next if lexeme :boolean, %r/(true|false)/
        next if lexeme :atom, %r/[a-zA-Z_\-\/\+]+/
        next if lexeme :float, %r/[0-9_]+\.[0-9_]+/
        next if lexeme :integer, %r/[0-9_]+/

        if scan(/"/)
          s = scan_until(/"/)
          push([:string, s.delete(?")])
          next
        end

        if scan(/'/)
          s = scan_until(/'/)
          push([:string, s.delete(?')])
          next
        end

        raise SyntaxError, "Could not lex: #{scan(/./)}"
      end

      @tokens
    end

    private

    def push(l)
      @tokens << l
    end

    def lexeme(type, rx, discard_match_and_keep_until_eol: false)
      if m = scan(rx)
        if !discard_match_and_keep_until_eol
          push([type, m])
        end

        if discard_match_and_keep_until_eol
          push([type, scan_until_eol])
        end

        true
      else
        false
      end
    end

    def eos?
      @scanner.eos?
    end

    def skip(rx)
      @scanner.skip(rx)
    end

    def scan(rx)
      @scanner.scan(rx)
    end

    def scan_until(rx)
      @scanner.scan_until(rx)
    end

    def scan_until_eol
      scan_until(/\n/).strip
    end
  end
end
