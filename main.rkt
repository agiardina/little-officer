#lang racket/gui 

(require data/gvector)
(require "config.rkt"
         "eventbus.rkt"
         "actions/dbsetup.rkt"
         "view/dbsetup.rkt"
         "view/clients.rkt"
         "view/client.rkt"
         "view/deal.rkt"
         )

; Create the config directory if directory does not exist
(when (not (directory-exists? config-path)) (make-directory config-path))

(define windows (make-hash))
(define history (make-gvector))
(define windows-makers 
    (hash 
        'clients make-clients-window
        'client make-client-window
        'deal make-deal-window))

(define (back)
    (when (> (gvector-count history) 0)
        (hide (gvector-remove-last! history))
        (show (current-window))))

(define (show window) (send window show #t))
(define (hide window) (send window show #f))
(define (current-window)
    (if (> (gvector-count history) 0)
        (gvector-ref history (- (gvector-count history) 1))
        #f))        

(define (make-window name)
    (let ([window-maker (hash-ref windows-makers name)])
        (hash-set! windows name (window-maker))))

(define (open-window name)
    (when (not (hash-has-key? windows name))
        (make-window name))

    (let ([window (hash-ref windows name)])
        (let ([old-window (current-window)])
            (gvector-add! history window)    
            (show window)
            (when old-window 
                (let ([x (send old-window get-x)]
                      [y (send old-window get-y)])
                    (send window move x y)
                    (hide old-window))))))

(listen (lambda (evname)
            (case evname
                [("BACK") (back)]
                [("OPENCLIENT") (open-window 'client)]
                [("OPENDEAL") (open-window 'deal)]
                )))

(if (not (restore-db-connection))
    (send dbsetup-window show #t)
    (open-window 'clients)
    ; (send (make-clients-window) show #t)
    
    )
