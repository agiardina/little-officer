#lang racket

(require db racket/format)

(define  *conn* #f)

(define (db-connect conf)
    (let* (
        [database (list-ref conf 0)]
        [server (list-ref conf 1)]
        [port (list-ref conf 2)]
        [user (list-ref conf 3)]
        [password (list-ref conf 4)]
        [connection (with-handlers ([exn:fail? (lambda (e) #f)])
                        (mysql-connect 
                            #:database database
                            #:server server
                            #:port  port
                            #:user user
                            #:password password))])
    (cond 
        [(connection? connection) (begin (set! *conn* connection))]
        [else #f])))

(define (query->hash query-res)
    (let* ([cols (map (lambda (h) (dict-ref h 'name)) (rows-result-headers query-res))]
           [values (vector->list (list-ref (rows-result-rows query-res) 0))]
           [assoc (map cons cols values)])
    (make-hash assoc)))

(define (query->rows query-res)
    (let* ([cols (map (lambda (h) (dict-ref h 'name)) (rows-result-headers query-res))])
      (map (lambda (v)
           (make-hash (map cons cols (vector->list v))))
           (rows-result-rows query-res))))

(define (rows->col rows col)
  (map (lambda (row) (hash-ref row col)) rows))

(define (query->col query-res col)
  (rows->col (query->rows query-res) col))

(define (sqldate->string date)
    (cond 
        [(sql-date? date)
            (let ([year (~a (sql-date-year date))]
                  [month (~a (sql-date-month date) #:min-width 2 #:pad-string "0" #:align 'right)]
                  [day (~a (sql-date-day date) #:min-width 2 #:pad-string "0" #:align 'right)])
            
                (~a year month day #:separator "-"))]
        [else ""]))

(define (insert table record) 
    (let* ([f-list (hash->list record)]
          [keys (map car f-list)]
          [values (map cdr f-list)]
          [cols (string-join keys ",")]
          [placeholders (string-join (make-list (length values) "?") ",")]
          [str-insert (string-append "INSERT INTO " table "(" cols ") VALUES (" placeholders ")" )])

        (apply query (flatten (list *conn* str-insert values)))))

(define (update table record id-field) 
    (let* (
          [id-value (hash-ref record id-field)]
          [f-list (hash->list (hash-remove record id-field))]
          [keys (map car f-list)]
          [values (map cdr f-list)]
          [cols (map (lambda (c) (string-append c "= ?")) keys)]
          [str-cols (string-join cols ",")]
          [str-update (string-append "UPDATE " table " SET " str-cols " WHERE " id-field " = ?" )])

          (apply query (flatten (list *conn* str-update values id-value)))))

(define (save table record id-field)
    (displayln record)
    
    (let ([id (hash-ref record id-field)] )
        (cond 
            [(or (false? id) (null? id) (sql-null? id) (and (string? id) (eq? "" id))) 
                (insert table (hash-remove record id-field))]
            [else 
                (update table record id-field)])))

(provide (all-defined-out))