#lang racket

(define config-path (build-path (find-system-path 'home-dir) ".etiqa"))

(provide (all-defined-out))