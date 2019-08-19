#lang racket/gui

(require racket/date
         "view.rkt"
         "deal.rkt"
         (prefix-in model: "../model/deals.rkt")
         "../utils.rkt"
         "../store.rkt"
         "../actions/deals.rkt"
         "../eventbus.rkt"
         "../dbmanager.rkt")


(define (make-deals-panel parent)
    
    (define deals-panel (new vertical-panel%
        [parent parent]
        [style (list 'deleted)]))

    (define deals-list-box
      (make-list deals-panel 
                (list "ID" "Description" "Value" "Start" "Status")
                select-deal))                   

    (define (populate-deals)
        (let ([deals (<-store 'deals)])
            (if deals
                (let* ( [id (map number->string (rows->col deals "id"))]
                        [description (rows->col deals "description")]
                        [value (map number?->string (rows->col deals "value"))]
                        [start_date (map sqldate->string (rows->col deals "start_date"))]
                        [status (rows->col deals "deal_status")])
                    (send deals-list-box set id description value start_date status))
                (send deals-list-box set null null null null null)
                )))            
      
    (listen (lambda (evname)
            (case evname
                [("CLIENTCHANGED" "DEALSLOADED") (populate-deals)])))

    (populate-deals)
            
    deals-panel)

(provide make-deals-panel)

