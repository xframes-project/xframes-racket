#lang racket
(require ffi/unsafe)

;; Load the shared C library
(define lib (ffi-lib "./xframesshared.dll")) ;; Adjust path as necessary

(display "Hello, World!")
