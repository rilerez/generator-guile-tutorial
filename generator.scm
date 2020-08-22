(define-module (generator)
  #:export (generator yield))

(define (make-generator-call-with-yield generator-defn-fn)
  (define yield-tag (make-prompt-tag 'yield))
  (define (yield . args)
    (apply abort-to-prompt yield-tag args))
  (define next (generator-defn-fn yield))
  (define (call-with-yield-prompt f)
    (call-with-prompt yield-tag
      f
      (lambda (continue . return-vals)
        (set! next continue)
        (apply values return-vals))))
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
  (make-generator-call-with-yield
   (lambda (yield%)
     (syntax-parameterize ((yield (identifier-syntax yield%)))
       (lambda args body ...)))))
