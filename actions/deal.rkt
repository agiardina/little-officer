#lang racket

(require "../eventbus.rkt" 
        "../store.rkt")

(define (back) (dispatch "BACK"))

(provide (all-defined-out))