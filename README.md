# Servico simples para demonstração  de Kubernetes

Um serviço muito simples que espera uma ligação numa porta de TCP e responde a um pedido GET com uma mensagem.
# Requisitos

* ambiente Linux (testado em Ubuntu 20.04 LTS)
* make  (para simplificar o uso)
* Python3 ( testado com python 3.8)
* pylint para análise estática do código
* which
* git
* kubectl
* curl

# Instalação
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
