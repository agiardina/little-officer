#lang racket

(require racket/serialize
         "../eventbus.rkt"
         "../dbmanager.rkt"
         "../config.rkt")

(define db-config-path (build-path config-path "db.conf"))

(define (restore-db-connection) 
    (cond
        [(file-exists? db-config-path) 
            (begin 
                (db-connect (read (open-input-file db-config-path)))
                (dispatch "DBREADY"))]
        [else #f]))

(define (save-db-connection
            #:database database
            #:server [server "localhost"]
            #:port [port 3306]
            #:user [user "root"]
            #:password [password ""])

    (let ([conf (list database server port user password)])
            (if (db-connect conf)
                (write conf (open-output-file db-config-path #:exists 'truncate))
                (display "connection failed"))))

(provide restore-db-connection 
         save-db-connection)