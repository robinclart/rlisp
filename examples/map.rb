$:.unshift File.expand_path("../../lib", __FILE__)
require "rlisp"

source = <<-SOURCE
; explicit lambda
(def ra (map (-> (n) (add n 1)) (list 1 2 3 4 5)))

; implicit lambda
(def rb (map (n) (add n 1) (list 1 2 3 4 5)))

; named explicit lambda
; in this case there's no qualified function name
; and the addone lambda is bound to an atom
(def addone (-> (n)
  (add n 1)))
(def rc (map addone (list 1 2 3 4 5)))

; named implicit lambda
; the qualified function name is addone/1
; note that this does not overwrite the lambda bound to the addone atom
(def addone (n)
  (add n 1))
(def rd (map addone (list 1 2 3 4 5)))

(def re (addone 1))

(list ra rb rc rd re)
SOURCE

p Rlisp.eval(source)
