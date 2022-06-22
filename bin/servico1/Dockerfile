# imagem alpine
ARG  VERSAO_BASE_CONTAINER
ARG  NOME_BASE_CONTAINER
FROM ${NOME_BASE_CONTAINER}:${VERSAO_BASE_CONTAINER}

ARG VERSAO_PYTHON      # que versão de python usar
RUN apk add python3=~$VERSAO_PYTHON
RUN apk add py3-pip
RUN apk add bash

COPY . /app
WORKDIR /app
RUN  pip3 install -r requirements.txt

CMD ["python3", "/app/ser1.py" ]
