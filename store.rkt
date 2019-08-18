#lang racket

(require "eventbus.rkt"
         "utils.rkt"
        (prefix-in deals:"model/deals.rkt")
        (prefix-in clients:"model/clients.rkt"))

(define data (make-hash))

(define events 
    (hash
        'client-id "CLIENTCHANGED"
        'client "CLIENTLOADED"
        'deals "DEALSLOADED"
        'deal-id "DEALCHANGED"
        'deal "DEALLOADED"
        ))

(define on-update-cascade 
    (hash 
        'client-id (list (list 'client clients:get-client-by-id)
                         (list 'deal-id #f)
                         (list 'deals deals:get-client-deals))
        'deal-id (list (list 'deal deals:get-deal))
    ))

(define (<-store key)
    (cond 
        [(hash-has-key? events key) (hash-ref data key)]
        [else (raise (format "Invalid key ~a" key))]))

(define (->store key val)
    (cond 
        [(hash-has-key? events key)
            (let ([event (hash-ref events key)]) 
                (hash-set! data key val)
                (when (hash-has-key? on-update-cascade key)
                    (map (lambda (u)
                        (let ([uk (car u)]
                              [uv (cadr u)])
                            (->store uk 
                                (cond
                                    [(not val) #f]
                                    [(procedure? uv) (call uv val)]
                                    [else uv]))))
                        (hash-ref on-update-cascade key)))
                (dispatch event))]
        [else (raise (format "Invalid key ~a" key))]))

(provide <-store ->store)