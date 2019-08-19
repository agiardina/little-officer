#lang racket

(require "eventbus.rkt"
         "utils.rkt"
        (prefix-in deals:"model/deals.rkt")
        (prefix-in clients:"model/clients.rkt"))

(define data (make-hash))

(define events 
    (hash
        'db-ready #f
        'deal-statuses #f
        'client-id "CLIENTCHANGED"
        'client "CLIENTLOADED"
        'deals "DEALSLOADED"
        'deal-id "DEALCHANGED"
        'deal "DEALLOADED"
        ))

(define on-update-cascade 
    (hash 
        'db-ready (list (list 'deal-statuses deals:get-deal-statuses))
        'client-id (list (list 'client clients:get-client-by-id)
                         (list 'deal-id #f)
                         (list 'deals deals:get-client-deals))
        'deals (list (list 'deal-id #f))
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
                                    [(and (procedure? uv) (eq? 0 (procedure-arity uv))) (uv)]
                                    [(and (procedure? uv) (eq? 1 (procedure-arity uv))) (call uv val)]
                                    [else uv]))))
                        (hash-ref on-update-cascade key)))
                (when event (dispatch event))
                )]
        [else (raise (format "Invalid key ~a" key))]))

(listen (lambda (evname)
    (case evname    

        [("NEWDEAL" "DEALDELETED") (->store 'deals (deals:get-client-deals (<-store 'client-id)))]

        )))

(provide <-store ->store)