#lang racket/gui

(require "view.rkt"
         "deals.rkt"
         "globalmenu.rkt"
         "../store.rkt"
         "../eventbus.rkt"
         "../actions/client.rkt"
         (prefix-in model: "../model/clients.rkt"))

(define (make-client-panel parent)
  
    (define client-panel (new vertical-panel%
                                [parent parent]
                                [stretchable-height #f]
                                [alignment (list 'right 'top)]))        

    (define id-field (input "ID:" client-panel)) 
    (define code-field (input "Code* (3 - 10 chars):" client-panel))
    (define name-field (input "Name:" client-panel ))
    (define notes-field (input "Notes:" client-panel 'multiple)) 

    (define fields (hash "id" id-field
                        "name" name-field 
                        "code" code-field
                        ;  "notes" notes-field
                        ))                                               

    (define h-box (new horizontal-panel%
                        [alignment (list 'right 'top)]
                        [parent client-panel]))

    (define save-btn (new button% 
                        [label "Save"]
                        [callback (lambda (b e) (save-client (fields->values fields)))]
                        [parent h-box]))   

    (define (load-data)
        (let ([client (<-store 'client)])
        (if client 
            (update-fields fields client)
            (clear-fields fields))
        (send client-panel refresh)))


    (listen (lambda (evname)
            (case evname
              [("CLIENTCHANGED") (load-data)]
              [("CLIENTUPDATED") (load-data)])))

    (load-data)

  client-panel)


(provide make-client-panel)