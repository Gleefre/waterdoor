(in-package #:waterdoor/gui)

(defparameter *colors*
  '((:background . "444444")
    (:options-font . "ffffff")
    (:options-Q-font . "ff0000")
    (:options-muted-font . "aaaaaa")))

(defun color (key)
  (hex-to-color (cdr (assoc key *colors*))))

(defun draw-background ()
  (background (color :background)))

(defun draw-o-panel (app)
  (with-pen (make-pen :stroke +black+)
    (rect 0 0 800 100))
  (with-font (make-font :size 25 :color (color :options-font))
    (text "Press   to exit." 0 30)
    (text "Press M to (un)mute:" 300 30))
  (with-font (make-font :size 25 :color (color :options-Q-font))
    (text "      Q" 0 30))
  (with-font (make-font :size 20)
    (with-font (make-font :color (color (if (gui-mute? app)
                                            :options-font
                                            :options-muted-font)))
      (text "MUTED" 650 15))
    (with-font (make-font :color (color (if (gui-mute? app)
                                            :options-muted-font
                                            :options-font)))
      (text "PLAYING" 650 50))))

(defun draw-menu (sketch))

(defun draw-game (sketch))

(defsketch gui ((game (make-game))
                (window :menu)
                (mute? nil)
                (animation? nil)
                (width 800)
                (height 800))
  (draw-background)
  (fit 800 900 width height)
  (draw-o-panel sketch::*sketch*)
  (translate 0 100)
  (case window
    (:menu (draw-menu sketch::*sketch*))
    (:game (draw-game sketch::*sketch*))))

(defun gui ()
  (sdl2:make-this-thread-main
   (lambda ()
     (let (#+deploy (sketch::*build* t))
       (make-instance 'gui :resizable t)))))
