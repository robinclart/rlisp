$:.unshift File.expand_path("../../lib", __FILE__)
require "rlisp"

source = <<-SOURCE
(def addone (-> (n) (add n 1)))
(map addone (list 1 2 3 4 5))
SOURCE

result, _ = Rlisp.eval(source)

p result
