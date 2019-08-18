#lang racket/gui

(require 
    racket/date
    db)

(define date-field%
  (class object%
    (init label parent)

    (define container (new horizontal-panel%
                           [alignment (list 'right 'center)]
                           [parent parent]))

    (define label-message (new message% [label label] 
                               [parent container]
                               [vert-margin 5]
                               [font (make-object font% 11 'default)]))

    (define day (new choice%	 
                     [label #f]	 
                     [choices (cons "" (map number->string (range 1 32)))]	 
                     [parent container]))

    (define month (new choice%	 
                       [label #f]	 
                       [choices (list "" "January" "February" "March" "April"
                                      "May" "June" "July" "August"
                                      "September" "October" "November" "December")]	 
                       [parent container]))
                      
    (define year (new choice%	 
                      [label #f]	 
                      [choices (cons "" (map number->string (range 2001 2100)))]	 
                      [parent container]))

    (super-new)               
 
    (define/public (get-value)
      #f)
 
    (define/public (set-value value)
        (cond 
            [(sql-date? value)
                (begin
                    (send day set-selection (sql-date-day value))
                    (send month set-selection (sql-date-month value))
                    (send year set-selection (- (sql-date-year value) 2000)))]
            [(date? value)
                (begin 
                    (send day set-selection (date-day value))
                    (send month set-selection (date-month value))
                    (send year set-selection (- (date-year value) 2000)))]
                    
            [(or (not value) (eq? value ""))
                (begin
                    (send day set-selection 0)
                    (send month set-selection 0)
                    (send year set-selection 0))]
            
            )
    )
  
    (set-value (current-date))))
    
(provide (all-defined-out))