LISP ?= sbcl

build:
	$(LISP) --eval "(ql:quickload :deploy)" \
		--eval "(push :deploy *features*)" \
		--eval "(deploy:define-resource-directory data \"resources/\")" \
		--eval "#+darwin (deploy:define-library cl-opengl-bindings::opengl :dont-deploy t)" \
		--load waterdoor.asd \
		--eval "(ql:quickload :waterdoor)" \
		--eval "(asdf:make :waterdoor)" \
		--eval "(quit)"
