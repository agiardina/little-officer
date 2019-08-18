#lang racket

(require "../store.rkt" "../eventbus.rkt")

(define (select-deal id) 
    (->store 'deal-id id)
    (dispatch "OPENDEAL"))

(provide (all-defined-out))