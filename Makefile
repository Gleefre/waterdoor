LISP ?= sbcl

build:
	make clean
	$(LISP) --eval "(ql:quickload :deploy)" \
		--eval "(push :deploy *features*)" \
		--eval '(deploy:define-resource-directory data "resources/")'
		--load rhombihexadeltille.asd \
		--eval "(ql:quickload :rhombihexadeltille)" \
		--eval "(asdf:make :rhombihexadeltille)" \
		--eval "(quit)"
	mkdir waterdoor
	mv bin/ waterdoor/
	cp run.sh waterdoor/
	cp NOTICE waterdoor/
	cp LICENSE waterdoor/
	zip waterdoor waterdoor

clean:
	rm -rf bin/
	rm -rf waterdoor/
	rm -rf waterdoor.zip
