#lang racket


(define events #())

(define (listen c)
  (set! events (vector-append events (vector c))))

(define (dispatch evname)
  (log-info (format "Dispatching ~s\n" evname))
  (vector-map (lambda (ch) (ch evname)) events))

(provide listen dispatch)