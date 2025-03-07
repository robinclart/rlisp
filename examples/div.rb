$:.unshift File.expand_path("../../lib", __FILE__)
require "rlisp"

source = <<-SOURCE
(def tag (name content)
  (format "<%s>%s</%s>" (list name content name)))

(def div (content)
  (tag "div" content))

(def div (content more-content)
  (tag "div" (format "%s%s" (list content more-content))))

(div "hello")
SOURCE

p Rlisp.eval(source)
