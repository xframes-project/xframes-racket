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
         rebellion/type/enum
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

; (define font-defs (file->string "./font-defs.json"))
(define theme (file->string "./theme.json"))

; export const theme2Colors = {
;   darkestGrey: "#141f2c",
;   darkerGrey: "#2a2e39",
;   darkGrey: "#363b4a",
;   lightGrey: "#5a5a5a",
;   lighterGrey: "#7A818C",
;   evenLighterGrey: "#8491a3",
;   black: "#0A0B0D",
;   green: "#75f986",
;   red: "#ff0062",
;   white: "#fff",
; };

(define theme-colors 
    (hasheq 
        'darkestGrey "#141f2c" 
        'darkerGrey "#2a2e39" 
        'darkGrey "#363b4a" 
        'lightGrey "#5a5a5a" 
        'lighterGrey: "#7A818C" 
        'evenLighterGrey "#8491a3" 
        'black "#0A0B0D"  
        'green: "#75f986" 
        'red "#ff0062"
        'white "#fff" 
    )
)


(define ImGuiCol
  '((Text . 0)
    (TextDisabled . 1)
    (WindowBg . 2)
    (ChildBg . 3)
    (PopupBg . 4)
    (Border . 5)
    (BorderShadow . 6)
    (FrameBg . 7)
    (FrameBgHovered . 8)
    (FrameBgActive . 9)
    (TitleBg . 10)
    (TitleBgActive . 11)
    (TitleBgCollapsed . 12)
    (MenuBarBg . 13)
    (ScrollbarBg . 14)
    (ScrollbarGrab . 15)
    (ScrollbarGrabHovered . 16)
    (ScrollbarGrabActive . 17)
    (CheckMark . 18)
    (SliderGrab . 19)
    (SliderGrabActive . 20)
    (Button . 21)
    (ButtonHovered . 22)
    (ButtonActive . 23)
    (Header . 24)
    (HeaderHovered . 25)
    (HeaderActive . 26)
    (Separator . 27)
    (SeparatorHovered . 28)
    (SeparatorActive . 29)
    (ResizeGrip . 30)
    (ResizeGripHovered . 31)
    (ResizeGripActive . 32)
    (Tab . 33)
    (TabHovered . 34)
    (TabActive . 35)
    (TabUnfocused . 36)
    (TabUnfocusedActive . 37)
    (PlotLines . 38)
    (PlotLinesHovered . 39)
    (PlotHistogram . 40)
    (PlotHistogramHovered . 41)
    (TableHeaderBg . 42)
    (TableBorderStrong . 43)
    (TableBorderLight . 44)
    (TableRowBg . 45)
    (TableRowBgAlt . 46)
    (TextSelectedBg . 47)
    (DragDropTarget . 48)
    (NavHighlight . 49)
    (NavWindowingHighlight . 50)
    (NavWindowingDimBg . 51)
    (ModalWindowDimBg . 52)
    (COUNT . 53)))


(define (enum-value key)
  (cdr (assoc key ImGuiCol)))

(define theme-hash
  (hasheq 'colors
    (hasheq
      (string->symbol (number->string (enum-value 'Text))) (list (hash-ref theme-colors 'white) 1)
    )
  )
)

(define font-defs-hash (hasheq 'defs (hasheq 'name "roboto-regular" 'size "16")))
(define font-defs
    (jsexpr->string	font-defs-hash)
)

(define theme-json
    (jsexpr->string	theme-hash)
)

(displayln theme-json)

(define (onInit)
    (thunk
        (displayln "init")
    )
)

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
;   (printf "Current thread: ~a\n" current)
  (displayln "Press CTRL+C to terminate")
  (let loop ()
    (sleep 0.1)
    (loop)))

(infinite-loop)
