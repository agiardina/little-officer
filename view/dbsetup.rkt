#lang racket/gui

(require "globalmenu.rkt"
          "../actions/dbsetup.rkt")

(define window (new frame% [label "Database Configuration"]))

(define menu (new global-menu% 
                        (parent window)))

(define panel (new group-box-panel%
                            (parent window)
                            (min-width 300)
                            (label "Database Configuration")))

(define db-name (new text-field%
                        (label "DB Name")
                        (parent panel)
                        (style (list 'single 'vertical-label))
                        (init-value "etiqa")))

(define host (new text-field%
                        (label "Host")
                        (parent panel)
                        (style (list 'single 'vertical-label))
                        (init-value "localhost")))

(define port (new text-field%
                        (label "Port")
                        (parent panel)
                        (style (list 'single 'vertical-label))
                        (init-value "3306")))

(define username (new text-field%
                        (label "Username")
                        (parent panel)
                        (style (list 'single 'vertical-label))
                        (init-value "root")))

(define password (new text-field%
                        (label "Password")
                        (parent panel)
                        (style (list 'single 'vertical-label 'password))
                        (init-value "")))

(define save (new button%
                    (parent panel)
                    (label "Save")
                    (callback (lambda (button event)
                                (save-db-connection 
                                  #:database (send db-name get-value)
                                  #:user (send username get-value)
                                  #:password (send password get-value)
                                  #:server (send host get-value)
                                  #:port (string->number (send port get-value))))
                                  )))

(provide (rename-out [window dbsetup-window]))