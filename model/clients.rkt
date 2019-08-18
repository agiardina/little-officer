#lang racket/gui

(require db
        "../utils.rkt"
        "../dbmanager.rkt"
        "../eventbus.rkt")

(define client-id #f)

(define (select-client id)
    (when (not (eq? client-id id)) 
        (begin
            (set! client-id id)
            (dispatch "CLIENTCHANGED"))))
    
(define (get-clients) 
    (query-rows	*conn*	 	 	 	 
        "select id,code,name from clients order by name"))

(define (add-client client)
    (let* ([values (hash->values client '("code" "name"))]
           [sql "insert into clients (code, name) VALUES(?, ?)"]
           [params (append (list *conn* sql) values)])
    (begin
      (apply query params)            
      (dispatch "NEWCLIENT"))))

(define (update-client client)
    (let* ([values (hash->values client '("code" "name" "id"))]
            [sql "update clients set code = ?, name = ? where id = ?"]
            [params (append (list *conn* sql) values)])
        (begin
            (apply query params)            
            (select-client (hash-ref client "id"))
            (dispatch "CLIENTUPDATED"))))
      

(define (save-client client)
    (let ([id (get client "id")])
        (cond 
            [(and id (non-empty-string? id)) (update-client client)]
            [else (add-client client)])))

(define (get-client-by-id id) 
    (query->hash (query *conn* "select * from clients where id = ?" id)))

(define (get-selected-client)
    (if client-id 
        (get-client-by-id client-id)
        #f))

(provide get-clients 
         add-client
         update-client
         save-client
         get-client-by-id
         select-client
         get-selected-client
         client-id)