$:.unshift File.expand_path("../../lib", __FILE__)
require "rlisp"

source = <<-SOURCE
(def x (capture (display (add 1 1))))
(sub (string-to-integer x) 3)
SOURCE

p Rlisp.eval(source)
