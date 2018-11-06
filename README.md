# Rlisp

Rlisp is a basic Lisp interpreter written in Ruby.

## Example

Given the source below.

```lisp
(def tag (name content)
  (format "<%s>%s</%s>" (list name content name)))

(def div (content)
  (tag "div" content))

(div "hello")
```

You should be able to run the following:

```ruby
result = Rlisp.eval(source)

result # => "<div>hello</div>"
```
