# Rlisp

Given the source below.

```lisp
(def tag (-> (name content) (format "<%s>%s</%s>" name content name)))

(def div (-> (content) (tag "div" content)))

(div "hello")
```

You should be able to run the following:

```ruby
result, output = Rlisp.eval(source)

result # => <div>hello</div>
```

There's currently a very low number of native methods.
