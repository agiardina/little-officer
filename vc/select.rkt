#lang racket/gui

(define select%
  (class choice%
    (super-new)

    (define/public (set-value value)
        (with-handlers ([exn:fail 
                        (lambda (e) (send this set-selection 0))])
            (if (eq? value "")
                (send this set-selection 0)
                (send this set-string-selection value))))

    (define/public (get-value)
        (send this get-string-selection))
        
))

(provide (all-defined-out))