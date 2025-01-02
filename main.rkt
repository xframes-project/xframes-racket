#lang racket
(require ffi/unsafe
         ffi/unsafe/define
         ffi/unsafe/atomic
         ffi/unsafe/os-async-channel
         ffi/unsafe/nsstring
         ffi/unsafe/alloc
         ffi/unsafe/custodian
         ffi/unsafe/schedule
         ffi/unsafe/os-thread
         racket/match
         racket/runtime-path
         json)


(define xframes
  (match (system-type)
    ['unix (ffi-lib "./libxframesshared.so")]
    ['windows (ffi-lib "./xframesshared.dll")]))

(define _OnInitCb (_fun #:async-apply (lambda (f) (f)) -> _void))
(define _OnTextChangedCb (_fun #:async-apply (lambda (f) (f)) _int _string -> _void))
(define _OnComboChangedCb (_fun #:async-apply (lambda (f) (f)) _int _int -> _void))
(define _OnNumericValueChangedCb (_fun #:async-apply (lambda (f) (f)) _int _float -> _void))
(define _OnBooleanValueChangedCb (_fun #:async-apply (lambda (f) (f)) _int _bool -> _void))
(define _OnMultipleNumericValuesChangedCb (_fun #:async-apply (lambda (f) (f)) _int _pointer _int -> _void))
(define _OnClickCb (_fun #:async-apply (lambda (f) (f)) _int _bool -> _void))

(define init
  (get-ffi-obj "init" xframes (
    _fun 
        _string 
        _string 
        _string
        _OnInitCb
        _OnTextChangedCb
        _OnComboChangedCb
        _OnNumericValueChangedCb
        _OnBooleanValueChangedCb
        _OnMultipleNumericValuesChangedCb
        _OnClickCb
         -> _void)))

(define setElement
  (get-ffi-obj "setElement" xframes (_fun _string -> _void)))

(define setChildren
  (get-ffi-obj "setChildren" xframes (_fun _int _string -> _void)))

(define font-defs (file->string "./font-defs.json"))
(define theme (file->string "./theme.json"))

(define (onInit) (displayln "received!\n"))

(define onTextValueChanged
  (lambda (id value)
    (displayln "Initialization is running...")))

(define onComboValueChanged
  (lambda (id selected-index)
    (displayln "Initialization is running...")))

(define onNumericValueChanged
  (lambda (id value)
    (displayln "Initialization is running...")))

(define onBooleanValueChanged
  (lambda (id value)
    (displayln "Initialization is running...")))

(define onMultipleNumericValuesChanged
  (lambda (id values-pointer num-values)
    (displayln "Initialization is running...")))

(define onClick
  (lambda (id)
    (displayln "Initialization is running...")))

(init 
    "./assets"
    font-defs
    theme
    onInit
    onTextValueChanged 
    onComboValueChanged 
    onNumericValueChanged 
    onBooleanValueChanged 
    onMultipleNumericValuesChanged 
    onClick
)

(define (infinite-loop)
  (define current (current-thread))
  (printf "Current thread: ~a\n" current)
  (let loop ()
    (sleep 0.1)
    (loop)))

(infinite-loop)
