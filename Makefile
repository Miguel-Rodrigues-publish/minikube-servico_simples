ifeq (, $(shell which python ))
  $(error "PYTHON=$(PYTHON) not found in $(PATH)")
endif

PYTHON_VERSION_MIN=3.8
PYTHON_VERSION=$(shell python -c 'import sys; print("%d.%d"% sys.version_info[0:2])' )
PYTHON_VERSION_OK=$(shell python -c 'import sys;\
  print(int(float("%d.%d"% sys.version_info[0:2]) >= $(PYTHON_VERSION_MIN)))' )

ifeq ($(PYTHON_VERSION_OK),0)
  $(error "Need python $(PYTHON_VERSION) >= $(PYTHON_VERSION_MIN)")
endif



lint_minimo = 10						# minimo valor se score do pylint


.PHONY : venv
venv:
	test -d venv || virtualenv -p python3 venv  ;\
	. venv/bin/activate ; \

.PHONY : install
install: venv
	pip install -r bin/servico1/requirements.txt

.PHONY : lint
lint: install
	pylint  --fail-under=$(lint_minimo) bin/servico1/ser1.py

.PHONY : teste_python
teste_python: lint
	. venv/bin/activate ; \
	cd bin; \
	python -m unittest discover || exit 1 ; \
	cd ..

.PHONY : teste_servico
teste_servico: teste_python
	PORTO=9000 NOME=nome_para_testar_servico1 ./bin/servico1/teste.sh
