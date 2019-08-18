(module menu-bar racket/gui

(define global-menu%
    (class object%
        (init-field
            parent
            (presenter #f))

    (define menu-bar 
        (new menu-bar% 
            (parent parent)))

    (new menu%
      (label "&File")
      (parent menu-bar))

    (new menu%
      (label "&Edit")
      (parent menu-bar))

    (new menu%
      (label "&Help")
      (parent menu-bar))
        
    (super-new)))
    
  (provide global-menu%))