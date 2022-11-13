(in-package #:waterdoor/gui)

(defparameter *water* "drop.png")
(defparameter *no-water* "no-drop.png")
(defparameter *door* "door-120.png")
(defparameter *choosed-door* "door-choosed-120.png")
(defparameter *sound* nil)
(defparameter *sound-path* "soundtrack.wav")

(defun animation-time (animation)
  (case animation
    (:showing 1)
    (:choosing 1/2)
    ((:continueing :continueing-2 :to-game :fade-game :to-menu :fade-menu) 1/3)))

(defparameter *blocking-animations*
  '(:to-game :fade-game :to-menu :fade-menu :continueing))

(defparameter *colors*
  '((:background . "1b323e")
    (:options-font . "00a6ba")
    (:options-Q-font . "53e9bf")
    (:options-muted-font . "353d5f")
    (:intro-font . "c4d552")
    (:start-font . "18ad31")
    (:black-screen . "1b323e")))

(defun color (key)
  (hex-to-color (cdr (assoc key *colors*))))

(defparameter *intro-text*
  "You have 7 plants.
Unfortunately, you don't have enough water
to water them today.

DOORman suggests you to play a game...")

(defparameter *choose-text*
"DOORman: Open one of these doors.
It you find the water, I will give it to you.
Otherwise, I will take some water from you!")

(defparameter *hint-text*
"DOORMAN: Hey, are you sure? I'll give you a hint:
there is no water behind the ~[first~;second~;third~] door.")

(defun draw-background ()
  (background (color :background)))

(defun draw-o-panel (app)
  (with-font (make-font :size 25 :color (color :options-font))
    (text "Press   to exit." 10 30)
    (text "Press M to (un)mute:" 300 30))
  (with-font (make-font :size 25 :color (color :options-Q-font))
    (text "      Q" 10 30))
  (with-font (make-font :size 20)
    (with-font (make-font :color (color (if (gui-mute? app)
                                            :options-font
                                            :options-muted-font)))
      (text "MUTED" 650 15))
    (with-font (make-font :color (color (if (gui-mute? app)
                                            :options-muted-font
                                            :options-font)))
      (text "PLAYING" 650 50))))

(defun shaking-text (text x y)
  (let ((*random-state* (make-random-state)))
    (loop repeat (* (length text) 10) do (random 10))
    (loop for char across text
          for pre-text = "" then (format nil "~a~a" pre-text (if (char= char #\newline) char " "))
          do (text (format nil "~a~a" pre-text char)
                   x (+ (random 8) y)))))

(defun draw-menu (sketch)
  (with-font (make-font :color (color :intro-font) :size 25 :align :center)
    (text *intro-text* 400 150))
  (with-font (make-font :color (color :start-font) :size 50 :align :center)
    (text "[Press SPACE to start]" 400 400))
  (case (gui-animation? sketch)
    (:fade-menu
     (with-pen (make-pen :fill (filter-alpha (color :black-screen)
                                             (- 1 (gui-animation-progress sketch))))
       (rect 0 0 800 800)))
    (:to-game
     (with-pen (make-pen :fill (filter-alpha (color :black-screen)
                                             (gui-animation-progress sketch)))
       (rect 0 0 800 800)))))

(defun draw-game (app)
  (with-slots (game animation? animation-progress) app
    (with-slots (state water iteration hint-door choosed-door water-door) game
      (with-font (make-font :color (color :start-font) :size 40)
        (text "Water:" 50 20)
        (loop for i from 1 to 7
              for x from 200 by 45
              do (with-pen (make-pen)
                   (image (load-resource (data-path (if (<= i water) *water* *no-water*)))
                          x 30 40 40)))
        (text (format nil "Cycle: ~a" iteration) 550 20))
      (if (win? game) (setf state :win))
      (if (lose? game) (setf state :lose))
      (case state
        (:win
         (with-font (make-font :color (color :intro-font) :size 40 :align :center)
           (text "Congratulations!" 400 120))
         (with-font (make-font :color (color :intro-font) :size 25 :align :center)
           (text "Take a break now, water your plants :)" 400 175)))
        (:lose
         (with-font (make-font :color (color :intro-font) :size 40 :align :center)
           (text "Oh no, you have lost! :(" 400 120))
         (with-font (make-font :color (color :start-font) :size 25 :align :center)
           (text "Press [R] to restart" 400 175)))
        (:choose
         (with-font (make-font :color (color :start-font) :size 25 :align :center)
           (text *choose-text* 400 120))
         (with-font (make-font :color (color :intro-font) :size 25 :align :center)
           (text "Press [1], [2] or [3] to choose one of these doors" 400 675)))
        (:hint
         (with-font (make-font :color (color :start-font) :size 25 :align :center)
           (text (format nil *hint-text* hint-door) 400 150))
         (with-font (make-font :color (color :intro-font) :size 25 :align :center)
           (text "Press [C] to change your choice
Press [K] to keep your choice" 400 635)))
        (:show
         (with-font (make-font :color (color :start-font) :size 25 :align :center)
           (if (= water-door choosed-door)
               (text "You can take this water." 400 150)
               (text "YES, give me your water!" 400 150)))
         (with-font (make-font :color (color :intro-font) :size 25 :align :center)
           (text "Press [SPACE] to continue" 400 675))))

      (loop for d below 3
            for x from 100 by 200
            with y = 300
            do (with-pen (make-pen)
                 (image (load-resource (data-path (if (and choosed-door (= d choosed-door))
                                                      *choosed-door* *door*)))
                        x y 200 200)
                 (if (and hint-door (= d hint-door))
                     (with-current-matrix
                       (when (eql animation? :choosing)
                         (scale animation-progress animation-progress (+ 100 x) (+ 100 y)))
                       (image (load-resource (data-path *no-water*))
                              (+ 75 x) (+ 100 y) 50 50)))
                 (if (and choosed-door (= d choosed-door) (eql state :show))
                     (with-current-matrix
                       (when (eql animation? :showing)
                         (scale animation-progress animation-progress (+ 100 x) (+ 100 y)))
                       (image (load-resource (data-path (if (= d water-door) *water* *no-water*)))
                              (+ 75 x) (+ 100 y) 50 50)))))))

  (case (gui-animation? app)
    (:continueing
     (with-pen (make-pen :fill (filter-alpha (color :black-screen)
                                             (min 1 (gui-animation-progress app))))
       (rect 0 250 800 350)))
    (:continueing-2
     (with-pen (make-pen :fill (filter-alpha (color :black-screen)
                                             (max 0 (- 1 (gui-animation-progress app)))))
       (rect 0 250 800 350)))
    (:fade-game
     (with-pen (make-pen :fill (filter-alpha (color :black-screen)
                                             (- 1 (gui-animation-progress app))))
       (rect 0 0 800 800)))
    (:to-menu
     (with-pen (make-pen :fill (filter-alpha (color :black-screen)
                                             (gui-animation-progress app)))
       (rect 0 0 800 800)))))

(defun blocking-animation? (animation?)
  (member animation? *blocking-animations*))

(defun process-animation (app)
  (with-slots (animation? animation-start animation-progress window game) app
    (when animation?
      (setf animation-progress (get-animation-progress (gui-animation-start app)
                                                       (animation-time animation?)))
      (when (>= animation-progress 1)
        (let ((old-animation animation?))
          (setf animation? nil)
          (case old-animation
            (:to-game
             (set-animation-start animation-start)
             (setf window :game animation? :fade-game animation-progress 0))
            (:to-menu
             (set-animation-start animation-start)
             (setf window :menu animation? :fade-menu animation-progress 0))
            (:continueing
             (continue-game game)
             (set-animation-start animation-start)
             (setf animation? :continueing-2 animation-progress 0))))))))

(defsketch gui ((game nil)
                (window :menu)
                (mute? nil)
                (animation? nil)
                (animation-progress 0)
                (animation-start nil)
                (width 800)
                (height 900))
  (process-animation sketch::*sketch*)
  (draw-background)
  (fit 800 900 width height)
  (draw-o-panel sketch::*sketch*)
  (translate 0 100)
  (case window
    (:menu (draw-menu sketch::*sketch*))
    (:game (draw-game sketch::*sketch*))))

(defmethod setup ((app gui) &key &allow-other-keys)
  (sdl2-mixer:init :wave)
  (sdl2-mixer:open-audio 44100 :s16sys 2 2048)
  (sdl2-mixer:allocate-channels 1)
  (setf *sound* (sdl2-mixer:load-wav (data-path *sound-path*)))
  (sdl2-mixer:play-channel 0 *sound* -1))

(defmethod kit.sdl2:close-window :before ((app gui))
  (sdl2-mixer:halt-channel -1)
  (sdl2-mixer:close-audio)
  (sdl2-mixer:free-chunk *sound*)
  (sdl2-mixer:quit))

(defmethod kit.sdl2:keyboard-event ((app gui) (st (eql :keydown)) ts (rep? (eql nil)) keysym)
  (with-slots (game window mute? animation? animation-start animation-progress) app
    (case (sdl2:scancode keysym)
      (:scancode-q (kit.sdl2:close-window app))
      (:scancode-m (setf mute? (not mute?))
       (if mute?
           (sdl2-mixer:halt-channel 0)
           (sdl2-mixer:play-channel 0 *sound* -1)))
      (t (unless (blocking-animation? animation?)
           (case window
             (:menu (case (sdl2:scancode keysym)
                      (:scancode-space
                       (setf game (make-game) animation? :to-game)
                       (set-animation-start animation-start))))
             (:game (case (sdl2:scancode keysym)
                      ((:scancode-backspace :scancode-escape :scancode-r)
                       (set-animation-start animation-start)
                       (setf animation? :to-menu
                             animation-progress 0))
                      (t (with-slots (state choosed-door) game
                           (case state
                             (:choose
                              (case (sdl2:scancode keysym)
                                (:scancode-1 (choose-door game 0)
                                 (set-animation-start animation-start)
                                 (setf animation? :choosing
                                       animation-progress 0))
                                (:scancode-2 (choose-door game 1)
                                 (set-animation-start animation-start)
                                 (setf animation? :choosing
                                       animation-progress 0))
                                (:scancode-3 (choose-door game 2)
                                 (set-animation-start animation-start)
                                 (setf animation? :choosing
                                       animation-progress 0))))
                             (:hint
                              (case (sdl2:scancode keysym)
                                (:scancode-c (accept-hint game)
                                 (set-animation-start animation-start)
                                 (setf animation? :showing
                                       animation-progress 0))
                                (:scancode-k (reject-hint game)
                                 (set-animation-start animation-start)
                                 (setf animation? :showing
                                       animation-progress 0))))
                             (:show
                              (case (sdl2:scancode keysym)
                                (:scancode-space
                                 (set-animation-start animation-start)
                                 (setf animation? :continueing
                                       animation-progress 0)))))))))))))))

(defun gui ()
  #+deploy
  (sdl2:make-this-thread-main
   (lambda ()
     (let ((sketch::*build* t))
       (make-instance 'gui :resizable t))))
  #-deploy
  (make-instance 'gui :resizable t))
