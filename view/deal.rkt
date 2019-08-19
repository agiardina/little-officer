#lang racket/gui

(require "view.rkt"
         "../store.rkt"
         "../actions/deal.rkt"
         "../eventbus.rkt")

(define (make-deal-window)
    (define window (new frame% 
                    [label "Deal"]
                    [min-width 500]
                    [x 100]
                    [y 100]
                    ))

    (define toolbar (make-toolbar window))

    (make-toolbar-button "Back" toolbar "left" back)
    (add-spacer toolbar)

    (define tabs (make-tab-panel window 
                                (list "Deal Info" "Payments" "Documents")
                                (lambda (t e) (tab-swap t panels))))

    (define form (make-form "Deal" tabs))
    (define payments (make-form "Payments" tabs))
    (define documents (make-form "Documents" tabs))
    (define panels (list form payments documents))

    (define (make-status label parent)
        (make-select label parent (<-store 'deal-statuses)))

    (define fields 
        (make-fields "Deal"
           form
           (list "id" "description" "deal_status" "value" "start_date" "end_date")
           (list "ID" "Description" "Status" "Value" "Start" "End")
           (list input input make-status input make-date make-date)))

    (define bottom-toolbar (make-toolbar form))
    (add-full-spacer bottom-toolbar)
    (make-button "Remove" bottom-toolbar delete-deal)
    (make-button "Save" bottom-toolbar (lambda () (save-deal (fields->values fields))))

    (define update-ui (bind-fields fields 'deal))

    (listen (lambda (evname)
        (case evname    
            [("DEALCHANGED") (update-ui)])))

    (update-ui)

    window)

(provide (all-defined-out))