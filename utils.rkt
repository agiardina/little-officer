#lang racket

(require db)

(define (get dict key [not-found #f])
    (if (dict-has-key? dict key)
        (dict-ref dict key)
        not-found))

(define (hash->values hash keys)
    (map (lambda (k) (get hash k #f)) keys))        

(define (number?->string n) 
    (if (number? n) 
        (number->string n)
        ""))

(define (sqlvalue->string val)
    (cond 
        [(or (false? val) (null? val) (sql-null? val)) ""]
        [(number? val) (number->string val)]
        [else val]))        

(define (call fn . args)
  (apply fn args))

(provide (all-defined-out))