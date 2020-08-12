(define (make-generator-call-with-yield g)
  (define yield-tag (make-prompt-tag 'yield))
  (define (yield . args)
    (apply abort-to-prompt yield-tag args))
  (define next (g yield))
  (define (call-with-yield-prompt f)
    (call-with-prompt yield-tag
      f
      (lambda (continue . return-vals)
        (set! next continue)
        (apply values return-val))))

  (lambda args
    (call-with-yield-prompt
     (lambda () (apply next args)))))

(define-syntax-parameter yield
  (lambda (stx)
    (syntax-violation
     'yield
     "Yield is undefined outside of a generator expression"
     stx)))

(define-syntax-rule (generator args body ...)
  (call-with-yield
   (lambda (yield%)
     (syntax-parameterize ((yield (identifier-syntax yield%)))
       (lambda* args body ...)))))




(define count
  (generator ()
    (let loop ((i start))
      (yield i)
      (loop (1+ i)))))
(count)                                 ;=>0
(count)                                 ;=>1
(count)                                 ;=>2
(count)                                 ;=>3
