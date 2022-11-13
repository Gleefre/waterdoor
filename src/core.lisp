(in-package #:waterdoor/core)

(defparameter *water-to-win* 7)
(defparameter *start-water* 3)

;; state is one of :choose and :hint
(defstruct game
  (water *start-water*)
  (iteration 1)
  (water-door (random 3))
  (choosed-door nil)
  (hint-door nil)
  (state :choose))

(defun win? (game)
  (>= (game-water game) *water-to-win*))

(defun choose-door (game door)
  (with-slots (choosed-door water-door hint-door state) game
    (setf choosed-door door
          hint-door
          (let ((no-doors (loop for d below 3
                                if (and (/= d door) (/= d water-door))
                                collect d)))
            (nth (random (length no-doors)) no-doors))
          state :hint)))

(defun guess-door (game door)
  (with-slots (water iteration choosed-door water-door hint-door state) game
    (incf (game-water game) (if (= (game-water-door game) door) 1 -1))
    (incf iteration)
    (setf water-door (random 3)
          choosed-door nil
          hint-door nil
          state :choose)))

(defun accept-hint (game)
  (guess-door game (loop for d below 3
                         if (not (member d (list (game-choosed-door game)
                                                 (game-hint-door game))))
                         do (return d))))

(defun reject-hint (game)
  (guess-door game (game-choosed-door game)))
