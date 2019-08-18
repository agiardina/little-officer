#lang racket/gui

(require "globalmenu.rkt"
         "view.rkt"
         "../vc/date.rkt"
         "../eventbus.rkt"
          "../actions/clients.rkt"
          (prefix-in model: "../model/clients.rkt"))

(define (make-clients-window)
    (define window (new frame% 
                    [min-width 500]
                    [min-height 300]
                    [x 100]
                    [y 100]                
                    [label "Clients"]
                    [style '(toolbar-button fullscreen-button)]
                    ))

    (define menu (new global-menu% 
            (parent window)))

    (define toolbar (make-toolbar window))

    (define add-btn (make-toolbar-button 
                    "Add Client" toolbar "add" 
                    show-add-client-window))

    (define v-box (new vertical-panel%
            [parent window]))

    (define clients-panel 
        (new group-box-panel%
            [parent v-box]
            [min-width 400]
            [min-height 200]
            [label "Clients"]))

    (define clients-list-box
        (new list-box% [label #f]
            [parent clients-panel]
            [choices '()]
            [style '(single column-headers)]
            [columns (list "ID." "Code" "Name")]
            [callback (lambda (l e)
                        (select-client (send l get-string-selection))
                        ;    (when (eq? 'list-box-dclick (send e get-event-type))
                        ;      (show-edit-client-window))
                            
                            )] 
            [stretchable-width #t]
            [stretchable-height #t]))

    (define h-box (new horizontal-panel%
            [alignment (list 'right 'top)]
            [parent v-box]))
                        
    (define (populate-clients-list)
        (let* ([clients (model:get-clients)]
            [ids (map (lambda (c) (number->string (vector-ref c 0))) clients)]
            [codes (map (lambda (c) (vector-ref c 1)) clients)]
            [names (map (lambda (c) (vector-ref c 2)) clients)])
            (send clients-list-box set ids codes names)))

    (listen (lambda (evname)
            (case evname
                [("NEWCLIENT" "CLIENTUPDATED") (populate-clients-list)])))

    (populate-clients-list)            
                
    window)

(provide make-clients-window)