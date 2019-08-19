#lang racket/gui

(require db 
        "../utils.rkt"
         "../vc/date.rkt"
         "../vc/select.rkt"
        "../store.rkt")

(define (update-fields fields values)
  (for ([(key value) values])
    (when (hash-has-key? fields key)
      (let ([field (hash-ref fields key)]
            [str-value (sqlvalue->string value)])
        (send field set-value str-value)))))

(define (clear-fields fields)
  (for ([(_ field) fields])
    (send field set-value "")))

(define (fields->values fields)
  (let* ([value (lambda (f) (send (hash-ref fields f) get-value))]
         [keys (hash-keys fields)]
         [vals (map value keys)])
    (for/hash ([k keys] [v vals])
      (if (and v (not (eq? v "")))
        (values k v)
        (values k sql-null)))))

(define (input label parent [style 'single])
  (let* ([container (new horizontal-panel%
                         [alignment (list 'right 'top)]
                         [parent parent])]
         [label (new message% [label label] 
                     [parent container]
                     [vert-margin 5]
                     [font (make-object font%	11 'default)])]
         [field (new text-field%
                     [label #f]
                     [parent container]
                     [stretchable-width #f]
                     [min-width 310]
                     [style (list style)])])
    field))

(define (make-select label parent options)
  (let* ([container (new horizontal-panel%
                         [alignment (list 'right 'top)]
                         [parent parent])]
         [label (new message% [label label] 
                     [parent container]
                     [vert-margin 5]
                     [font (make-object font%	11 'default)])]

         [field (new select%
                     [label #f]
                     [choices options]
                     [parent container]
                     [stretchable-width #f]
                     [min-width 310]
                     )])
    field))    

(define (make-date label parent)
    (new date-field% [label label] [parent parent]))

(define (make-list parent columns select-fn)
  (new list-box% [label #f]
       [parent parent]
       [choices '()]
       [style '(single column-headers)]
       [callback (lambda (l e)
            (let ([selected (send l get-string-selection)])
                (when selected (select-fn selected))))]
       [columns columns]
       [min-height 100]
       [stretchable-width #t]
       [stretchable-height #t]))

(define (make-toolbar parent)
    (new horizontal-panel% [parent parent] 
        [border 5]
        [stretchable-height #f]
        [alignment (list 'left 'center)]))

(define (make-button label parent fn) 
    (new button% 
        [label label]
        [callback (lambda (l e) (fn))]
        [parent parent]))

(define (make-toolbar-button label parent icon fn) 
    (define container (new vertical-panel% 
                        [parent parent] 
                        [stretchable-width #f]))

    (define button (new button% 
                [label (make-object bitmap%	(format "img/~a.png" icon))]
                [min-width 52]
                [min-height 28]
                [callback (lambda (l e) (fn))]
                [parent container]))

    (define message (new message% [label label] 
                     [parent container]
                     [vert-margin 0]
                     [font (make-object font% 10 'default)]))

    button)    

(define (add-spacer parent [min-width 40])
    (new panel% [parent parent]
                [stretchable-width #f]
                [min-width min-width]))

(define (add-full-spacer parent)
    (new panel% [parent parent]))                

(define (make-form label parent) 
    (new vertical-panel%	 
                         ;[label label]	 
                         [parent parent]
                         [alignment '(right top)]
                         [stretchable-height #f]
                         [stretchable-width #f]))

(define (make-fields
         label
         parent
         columns
         labels
         fns)

  (define parents (map (lambda (_) parent) labels))
  (define fields (map call fns labels parents))
  (make-hash (map cons columns fields)))

(define (bind-fields fields key)
    (lambda args 
        (let ([record (<-store key)])
            (if record
                (update-fields fields record)
                (clear-fields fields))
            record)))

(define (make-tab-panel parent choices callback)
    (new tab-panel%
        [parent parent]
        [callback callback]
        [choices choices]))

(define (tab-swap tab-panel panels)
    (let ([i (send tab-panel get-selection)])
            (send tab-panel change-children (lambda (_) (list (list-ref panels i))))))

(provide (all-defined-out))