(use-modules ((generator)
              #:prefix gen.))
(define count
  (gen.generator ()
    (let loop ((i 0))
      (gen.yield i)
      (loop (1+ i)))))

(count)         ;=>0
(count)         ;=>1
(count)         ;=>2
(count)         ;=>3
