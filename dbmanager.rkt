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
  (let ([year (~a (sql-date-year date))]
        [month (~a (sql-date-month date) #:min-width 2 #:pad-string "0" #:align 'right)]
        [day (~a (sql-date-day date) #:min-width 2 #:pad-string "0" #:align 'right)])
    (~a year month day #:separator "-")))

(provide (all-defined-out))