#!/usr/bin/env python
# -*- coding: utf8 -*-

#
# imprime o **hostname**  e a data hora em UTC
#
import datetime
import os
import sys
import socket
import argparse
import syslog
from flask import Flask, jsonify, request

def mensagem(texto):
    print(texto)

def le_argumentos():
    #
    # --porto é um argumento mandatório se não existir a variável de environment PORTO
    #
    parser = argparse.ArgumentParser(description='O Meu Serviço 1 ')
    parser.add_argument('-p', '--porto',
                        action="store",
                        dest='porto',
                        type=int,
                        default=0,
                        help="porto tcp onde o servico fica à escuta. Tambem pode ser usada a variável de environment PORTO",
                        required=False)
    parser.add_argument('-n', '--nome',
                        action="store",
                        dest='nome',
                        type=str,
                        default="",
                        help="nome do serviço",
                        required=False)

    argumento = parser.parse_args()
    if argumento.porto == 0:
        if "PORTO" in os.environ.keys():
            argumento.porto = int(os.environ["PORTO"])
            if argumento.porto == 0:
                print("variavel de environment PORTO tem que ser inteiro (%s)" % (type(argumento.porto)))
                sys.exit(1)
        else:
            print("variavel de environment PORTO tem que existir ou ter a opção -p")
            sys.exit(1)
    if argumento.nome == "":
        if "NOME" in os.environ.keys():
            argumento.nome = os.environ["NOME"]
        else:
            print("variavel de environment NOME tem que existir ou ter a opção -n")
            sys.exit(1)

    return (argumento.nome, argumento.porto)

def  cria_aplicacao(nome_aplicacao):
    aplicacao = Flask(nome_aplicacao)
    @aplicacao.route('/', methods=['GET'])
    def home():
        """ Corpo do serviço simples """

        if request.method == 'GET':
            dados = {
                'servico':  nome_aplicacao,
                'hostname': socket.gethostname(),
                'UTC':      datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S.%f"),
            }
            texto = jsonify(dados)
        else:
            texto = "Serviço so usa método GET"
        syslog.syslog(syslog.LOG_INFO, "%s" % texto)
        return texto

    return aplicacao



if __name__ == '__main__':
    (nome, porto) = le_argumentos()
    app = cria_aplicacao(nome)
    try:
        mensagem("server up")
        app.run(debug=False, host='0.0.0.0', port=porto)
        mensagem("stopping server ")
    except:
        mensagem("Erro: Nao consegui lançar o serviço")
        sys.exit(1)
