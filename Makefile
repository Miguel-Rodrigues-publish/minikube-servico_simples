#
# Makefile simples só para automatizar as tarefas de desenvolvimento (não entra
# em conta com as dependências )
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
# nome do containe inicial r
nome_container_base   := $(shell cat etc/configuracao_empresa/nome_container.txt)
# versao do container inicial
versao_container_base := $(shell cat etc/configuracao_empresa/versao_base_container.txt)


################################################################################
# Valores Globais (Projecto)
################################################################################
# nome do container
nome_container_servico = servico1
# versao para marcar o container
#versao = "0.6"
versao_servico := $(shell cat etc/versao_servico.txt)
# porto que o container usa
porto_teste_container := 3000
# porto para ligação no "portatil". Não pode estar a ser usado
porto_teste_local := 8888
# nome do servico
nome_servico = nome_para_testar_servico1

################################################################################
#  Inicio Makefile
################################################################################

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
# Análise estática de código
#
.PHONY : lint
lint: install \
	    etc/configuracao_empresa/minimo_lint_python.txt  \
	    etc/configuracao_empresa/versao_python.txt \
			etc/configuracao_empresa/nome_container.txt \
			etc/configuracao_empresa/versao_base_container.txt \
			etc/versao_servico.txt \
			bin/servico1/ser1.py
	. venv/bin/activate ; \
	pylint  --fail-under=$(lint_minimo) bin/servico1/ser1.py

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
# Testes globais ( End to End Testing)
#
.PHONY : teste_servico
teste_servico: teste_python
	. venv/bin/activate ; \
	PORTO=$(porto_teste_local) NOME=$(nome_servico) ./bin/servico1/teste.sh

################################################################################
# Docker e minikube
#		Estes passos só estrão disponíveis se o minikube estiver instalado
################################################################################

.PHONY : minikube
minikube:
	minikube status ||  minikube start --driver="virtualbox" ;\
	eval $$(minikube docker-env)

.PHONY : minikube_imagem
minikube_imagem: minikube lint
	cd ./bin/servico1;\
	docker image inspect $(nome_container_servico):$(versao_servico) \
	     --format="ignora resultado" || \
			 docker build \
			  --build-arg VERSAO_PYTHON=$(versao_python) \
			  --build-arg VERSAO_BASE_CONTAINER=$(versao_container_base) \
			  --build-arg NOME_BASE_CONTAINER=$(nome_container_base) \
				--tag $(nome_container_servico):$(versao_servico) \
				--tag $(nome_container_servico):latest \
				.

minikube_teste_imagem: minikube_imagem
	eval $$(minikube docker-env) ;\
	docker run \
		--env PORTO=$(porto_teste_container) \
		--env NOME=$(nome_servico) \
		--detach \
		-p $(porto_teste_local):$(porto_teste_container) \
		$(nome_container_servico):$(versao_servico) ;\
	CONTAINER=$$(docker ps -q --filter=ancestor=$(nome_container_servico):$(versao_servico)) ;\
	sleep 5 ;\
	minikube ssh curl localhost:$(porto_teste_local) ;\
	docker stop $$CONTAINER
