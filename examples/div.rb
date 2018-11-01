$:.unshift File.expand_path("../../lib", __FILE__)
require "rlisp"

source = <<-SOURCE
(def tag (-> (name content) (format "<%s>%s</%s>" name content name)))

(def div (-> (content) (tag "div" content)))

(div "hello")
SOURCE
# (map (-> (n) (+ n 1)) (1 2 3))

result, _ = Rlisp.eval(source)

p result
