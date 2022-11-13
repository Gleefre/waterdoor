(in-package #:waterdoor/utils)

;; data-path to get resource's path
(defparameter *data-location* "resources/")

(let ((data-folder nil))
  (defun data-path (relative-path)
    (setf data-folder
          (or data-folder
              #-deploy (asdf:system-relative-pathname "waterdoor" *data-location*)
              #+deploy (let ((deploy:*data-location* *data-location*))
                         (deploy:data-directory))))
    (format nil "~a" (merge-pathnames relative-path data-folder))))

;; Fit -- function to fit desired width/height to rectangle on screen
(defun fit (width height from-width from-height &optional (to-x 0) (to-y 0) (from-x 0) (from-y 0) max-scale)
  (translate from-x from-y)
  (let* ((scale (min (/ from-width width)
                     (/ from-height height)
                     (if max-scale max-scale 10000)))
         (x-shift (/ (- from-width (* width scale)) 2))
         (y-shift (/ (- from-height (* height scale)) 2)))
    (translate x-shift y-shift)
    (scale scale))
  (translate (- to-x) (- to-y)))

;; utils for animate

(defun get-animation-progress (animation-start animation-time)
  (/ (- (get-internal-real-time) animation-start) internal-time-units-per-second
     animation-time))

(defmacro set-animation-start (animation-start)
  `(setf ,animation-start (get-internal-real-time)))

;; colors

(defun filter-alpha (color alpha)
  (rgb (color-red color) (color-green color) (color-blue color)
       alpha))
