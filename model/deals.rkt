#lang racket/gui

(require db
        "clients.rkt"
        "../utils.rkt"
        "../dbmanager.rkt")
    
(define (get-client-deals client-id) 
    (query->rows (query *conn* "select * from deals where client_id = ? order by start_date" client-id)))

(define (get-deal id)
  (query->hash (query *conn* "select * from deals where id = ?" id)))

(provide (all-defined-out))