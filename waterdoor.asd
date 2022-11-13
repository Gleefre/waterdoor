(asdf:defsystem "waterdoor"
  :description "A little game about choices."
  :version "0.0.0"
  :author "Gleefre <varedif.a.s@gmail.com>"
  :licence "Apache 2.0"
  :depends-on ("sketch" "sdl2-mixer")
  :pathname "src"
  :components ((:file "packages")
               (:file "hacks")
               (:file "core")
               (:file "utils")
               (:file "gui"))

  :defsystem-depends-on (:deploy)
  :build-operation "deploy-op"
  :build-pathname "waterdoor"
  :entry-point "waterdoor:gui")
