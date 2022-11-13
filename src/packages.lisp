(defpackage #:waterdoor/hacks
  (:use #:cl))

(defpackage #:waterdoor/core
  (:use #:cl)
  (:export #:make-game #:game-state #:game-iteration #:game-water
           #:game-water-door #:game-choosed-door #:game-hint-door
           #:water #:iteration #:water-door #:choosed-door #:hint-door #:state
           #:win? #:lose?
           #:choose-door #:accept-hint #:reject-hint #:continue-game))

(defpackage #:waterdoor/utils
  (:use #:cl #:sketch)
  (:export #:fit #:data-path
           #:get-animation-progress
           #:set-animation-start
           #:filter-alpha))

(defpackage #:waterdoor/gui
  (:use #:cl #:sketch
        #:waterdoor/core
        #:waterdoor/utils)
  (:export #:gui))

(defpackage #:waterdoor
  (:use #:cl #:waterdoor/gui)
  (:export #:gui))
