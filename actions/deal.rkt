#lang racket

(require "../eventbus.rkt" 
        "../store.rkt"
        (prefix-in model: "../model/deals.rkt"))

(define (back) (dispatch "BACK"))

(define (save-deal deal)
    (model:save-deal (hash-set deal "client_id" (<-store 'client-id)))
    (back))

(define (delete-deal)
    (model:delete-deal (<-store 'deal-id))
    (back))

(provide (all-defined-out))