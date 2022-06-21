version = "0.1.0"                  	# versão/tag do servico
nome_servico = "servico1"						# nome do servico

.PHONY : venv
venv:
	test -d venv || virtualenv -p python3 venv  ;\
	. venv/bin/activate ; \

.PHONY : install
install: venv
	pip install -r bin/servico1/requirements.txt

.PHONY : teste_python
teste_python: venv install
	. venv/bin/activate ; \
	cd bin; \
	python -m unittest discover || exit 1 ; \
	cd ..

.PHONY : teste_python
teste_servico1: teste_python
	./bin/servico1/teste.sh
