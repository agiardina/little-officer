#lang racket

(define main-window%
  (class frames% ; The base class is canvas%
    ; Define overriding method to handle mouse events
    (define/override (on-event event)
      (print "Canvas mouse"))
    ; Define overriding method to handle keyboard events
    (define/override (on-char event)
      (print "Canvas keyboard"))
    ; Call the superclass init, passing on all init args
    (super-new)))
 
; Make a canvas that handles events in the frame
(new my-canvas% [parent frame])