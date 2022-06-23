# Servico simples para demonstração  de Kubernetes

Um serviço muito simples que espera uma ligação numa porta de TCP e responde a um pedido GET com uma mensagem.

# Requisitos
Deve ser possível usar qual sistema operativo moderno no entanto todo o
desenvolvimento e  teste foi feito num ambiente Linux (testado em Ubuntu 20.04
LTS)
  * Python3 ( testado com python 3.8)
  * pylint para análise estática do código
  * curl
  * which
  * [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  * [make](http:www.google.pt) (para simplificar o uso)
  * [kubectl](https://kubernetes.io/docs/tasks/tools/)

# Instalação Serviço
```bash
  git clone https://github.com/Miguel-Rodrigues-publish/minikube-servico_simples.git
  cd minikube-servico_simples/
```


# Teste local

```bash
  make
```


# Imagem

## Criação Imagem
```bash
  make imagem
```

## Teste Imagem
```bash
  make teste_imagem
```
