#lang racket

(require racket/serialize
         "../dbmanager.rkt"
         "../config.rkt")

(define db-config-path (build-path config-path "db.conf"))

(define (restore-db-connection) 
    (cond
        [(file-exists? db-config-path) 
            (db-connect (read (open-input-file db-config-path)))]
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