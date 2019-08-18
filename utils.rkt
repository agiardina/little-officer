#lang racket

(define (get dict key [not-found #f])
    (if (dict-has-key? dict key)
        (dict-ref dict key)
        not-found))


(define (hash->values hash keys)
    (map (lambda (k) (get hash k #f)) keys))        

(define (call fn . args)
  (apply fn args))

(provide (all-defined-out))