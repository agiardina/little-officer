#lang racket/gui

(require "view.rkt"
         "deals.rkt"
         "client-panel.rkt"
         "globalmenu.rkt"
         "../actions/client.rkt"
         "../eventbus.rkt"
         "../actions/client.rkt"
          (prefix-in model: "../model/clients.rkt"))

(define (make-client-window)
    (define window (new frame% 
                    [label "Client"]
                    [min-width 500]
                    [x 100]
                    [y 100]
                    ))

    (define toolbar (make-toolbar window))

    (make-toolbar-button "Back" toolbar "left" back)
    (add-spacer toolbar)
    (make-toolbar-button "New Deal" toolbar "mancheck" new-deal)
    (make-toolbar-button "New Doc." toolbar "edit" #f)

    (define (change-panel tab-panel _)
        (let ([i (send tab-panel get-selection)])
            (send tab-panel change-children (lambda (_) (list (list-ref panels i))))))
        
    (define tab-panel (new tab-panel%
        [parent window]
        [callback change-panel]
        [choices (list "Details"
                        "Deals")]))

    (define panels (list (make-client-panel tab-panel)
                        (make-deals-panel tab-panel)))

    (define (show) (send window show #t))
    (define (hide) (send window show #f))

    (listen (lambda (evname)
                (case evname
                [("NEWCLIENT") (hide)])))

    window
)

(provide make-client-window)