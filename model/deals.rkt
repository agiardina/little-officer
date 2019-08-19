#lang racket/gui

(require db
        "clients.rkt"
        "../eventbus.rkt"
        "../utils.rkt"
        "../dbmanager.rkt")
    
(define (get-client-deals client-id) 
    (query->rows (query *conn* "select * from deals where client_id = ? order by start_date" client-id)))

(define (get-deal id)
  (query->hash (query *conn* "select * from deals where id = ?" id)))

(define (delete-deal id)
    (query *conn* "delete from deals where id = ?" id)
    (dispatch "DEALDELETED"))

(define (get-deal-statuses id)
  (query->col (query *conn* "select * from deal_status order by position") "deal_status")) 


(define (insert-deal fields)
    (insert "deals" fields)
    (dispatch "NEWDEAL"))

(provide (all-defined-out))