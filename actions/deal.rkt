#lang racket

(require "../eventbus.rkt" 
        "../store.rkt"
        (prefix-in model: "../model/deals.rkt"))

(define (back) (dispatch "BACK"))

(define (save-deal deal)
    (model:insert-deal 
        (hash-remove (hash-set deal "client_id" (<-store 'client-id)) "id"))
    (back))

(define (delete-deal)
    (model:delete-deal (<-store 'deal-id))
    (back))

(provide (all-defined-out))