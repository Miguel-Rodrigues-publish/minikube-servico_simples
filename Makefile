
################################################################################
# Variaveis globais da Makefile
################################################################################

################################################################################
# Valores Globais (Empresa)
################################################################################
# minimo valor se score do pylint (static code analyser)
lint_minimo      := $(shell cat etc/configuracao_empresa/minimo_lint_python.txt)
# versao de python
versao_python    := $(shell cat etc/configuracao_empresa/versao_python.txt)
# versao do container
versao_container := $(shell cat etc/configuracao_empresa/versao_base_container.txt)
# nome do container
nome_container   := $(shell cat etc/configuracao_empresa/nome_container.txt)


################################################################################
# Valores Globais (Projecto)
################################################################################
# nome do container
nome_servico = "servico1"
# versao para marcar o container
#versao = "0.6"
versao := $(shell cat etc/versao_servico.txt)

#
# teste se python com a versao mínima está presente
#
ifeq (, $(shell which python ))
  $(error "PYTHON=$(PYTHON) not found in $(PATH)")
endif

PYTHON_VERSION=$(shell python -c 'import sys; print("%d.%d"% sys.version_info[0:2])' )
PYTHON_VERSION_OK=$(shell python -c 'import sys;\
  print(int(float("%d.%d"% sys.version_info[0:2]) == $(versao_python)))' )

ifeq ($(PYTHON_VERSION_OK),0)
  $(error "É necessária versão python $(PYTHON_VERSION) == $(versao_python)")
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

################################################################################
# Testes
################################################################################
#
# Testes unitários
#
.PHONY : teste_python
teste_python: lint
	. venv/bin/activate ; \
	cd bin; \
	python -m unittest discover || exit 1 ; \
	cd ..

#
# Análise estática de código
#
.PHONY : lint
lint: install
	. venv/bin/activate ; \
	pylint  --fail-under=$(lint_minimo) bin/servico1/ser1.py

#
# Testes globais ( End to End Testing)
#
.PHONY : teste_servico
teste_servico: teste_python
	. venv/bin/activate ; \
	PORTO=9000 NOME=nome_para_testar_servico1 ./bin/servico1/teste.sh

################################################################################
# Docker
#		Estes passos só estrão disponíveis se o minikube estiver instalado
################################################################################

#
# minikube activo
#
.PHONY : minikube
minikube:
	minikube start --driver="virtualbox" ;\ #--host-dns-resolver=true --dns-proxy=false;\
	eval $$(minikube docker-env)

.PHONY : imagem
imagem: minikube
	cd ./bin/servico1;\
	docker build \
	  --build-arg VERSAO_PYTHON=$(versao_python) \
	  --build-arg VERSAO_BASE_CONTAINER=$(versao_container) \
	  --build-arg NOME_BASE_CONTAINER=$(nome_container) \
		--tag $(nome_servico):$(versao) \
		.
