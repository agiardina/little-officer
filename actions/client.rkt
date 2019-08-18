#lang racket

(require "../config.rkt"
         "../eventbus.rkt"
         "../store.rkt"
         )
(require (prefix-in model: "../model/clients.rkt"))

(define (save-client client)
    (model:save-client client))

(define (new-deal)
    (->store 'deal-id #f)
    (dispatch "OPENDEAL"))

(define (save-deal deal)
    (->store 'deal-id #f)
    (dispatch "OPENDEAL"))    

(define (back) (dispatch "BACK"))

(provide (all-defined-out))