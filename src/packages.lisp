(defpackage #:waterdoor/hacks
  (:use #:cl))

(defpackage #:waterdoor/core
  (:use #:cl)
  (:export #:make-game
           #:win?
           #:choose-door
           #:accept-hint
           #:reject-hint))

(defpackage #:waterdoor/utils
  (:use #:cl #:sketch)
  (:export #:fit #:data-path))

(defpackage #:waterdoor/gui
  (:use #:cl #:sketch
        #:waterdoor/core
        #:waterdoor/utils)
  (:export #:gui))

(defpackage #:waterdoor
  (:use #:cl #:waterdoor/gui))
