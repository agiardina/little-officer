#lang racket

(require "../eventbus.rkt" 
        "../config.rkt"
        "../store.rkt"
        (prefix-in model: "../model/clients.rkt"))

(define (select-client id)
    (->store 'client-id id)
    (dispatch "OPENCLIENT"))

(define (show-add-client-window)
    (->store 'client-id #f)
    (dispatch "OPENCLIENT")) 

(provide (all-defined-out))