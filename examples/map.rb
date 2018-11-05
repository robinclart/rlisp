$:.unshift File.expand_path("../../lib", __FILE__)
require "rlisp"

source = <<-SOURCE
; explicit lambda
(def rb (map (-> (n) (add n 1)) (list 1 2 3 4 5)))

; implicit lambda
(def ra (map (n) (add n 1) (list 1 2 3 4 5)))

; named explicit lambda
(def addone (-> (n)
  (add n 1)))
(def rc (map addone (list 1 2 3 4 5)))

; named implicit lambda
(def addone (n)
  (add n 1))
(def rd (map addone (list 1 2 3 4 5)))

(list ra rb rc rd)
SOURCE

p Rlisp.eval(source)
