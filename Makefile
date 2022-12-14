LISP ?= sbcl

build:
	$(LISP) --eval "(ql:quickload :deploy)" \
		--eval "(ql:quickload :sketch)" \
		--eval "(push :deploy *features*)" \
		--eval "(deploy:define-resource-directory data \"resources/\")" \
		--eval "(deploy:define-library cl-opengl-bindings::opengl :dont-deploy t)" \
		--load waterdoor.asd \
		--eval "(ql:quickload :waterdoor)" \
		--eval "(asdf:make :waterdoor)" \
		--eval "(quit)"
