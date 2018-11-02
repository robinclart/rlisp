$:.unshift File.expand_path("../../lib", __FILE__)
require "rlisp"

source = <<-SOURCE
(map (n) (add n 1) (list 1 2 3 4 5))
SOURCE

result, _ = Rlisp.eval(source)

p result
