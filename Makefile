
#
# Variaveis globais da Makefile
#
lint_minimo = 10						# minimo valor se score do pylint (static code analyser)
versao_minima_python = 3.8    # versao minima de python para projecto

#
# teste se python com a versao mínima está presente
#
ifeq (, $(shell which python ))
  $(error "PYTHON=$(PYTHON) not found in $(PATH)")
endif

PYTHON_VERSION=$(shell python -c 'import sys; print("%d.%d"% sys.version_info[0:2])' )
PYTHON_VERSION_OK=$(shell python -c 'import sys;\
  print(int(float("%d.%d"% sys.version_info[0:2]) >= $(versao_minima_python)))' )

ifeq ($(PYTHON_VERSION_OK),0)
  $(error "É necessária versão python $(PYTHON_VERSION) >= $(versao_minima_python)")
endif

#
# objectivo se nao existirem opcções para comando make
#
.PHONY : all
all: teste_servico

.PHONY : venv
venv:
	test -d venv || virtualenv -p python3 venv

.PHONY : install
install: venv
	. venv/bin/activate ; \
	pip install -r bin/servico1/requirements.txt

.PHONY : lint
lint: install
	. venv/bin/activate ; \
	pylint  --fail-under=$(lint_minimo) bin/servico1/ser1.py

.PHONY : teste_python
teste_python: lint
	. venv/bin/activate ; \
	cd bin; \
	python -m unittest discover || exit 1 ; \
	cd ..

.PHONY : teste_servico
teste_servico: teste_python
	. venv/bin/activate ; \
	PORTO=9000 NOME=nome_para_testar_servico1 ./bin/servico1/teste.sh
