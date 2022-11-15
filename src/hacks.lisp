;; sketch loads default fonts on startup, but we don't want to ship them

(defparameter *font-name* "RobotoMono-Bold.ttf")

(let ((font))
  (defun sketch::make-default-font ()
    (setf font (or font
                   (sketch:make-font :face (sketch:load-resource (waterdoor/utils:data-path *font-name*))
                                     :color sketch:+black+
                                     :size 18))))
  (defun sketch::make-error-font ()
    (setf font (or font
                   (sketch:make-font :face (sketch:load-resource (waterdoor/utils:data-path *font-name*))
                                     :color sketch:+black+
                                     :size 18)))))

;; sketch define `ESC` as "close window" button. We want to override this behaviour
(defmethod kit.sdl2:keyboard-event :before ((instance sketch:sketch) state timestamp repeatp keysym)
  (declare (ignorable timestamp repeatp)))
