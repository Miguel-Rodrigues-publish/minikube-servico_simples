#FROM debian:latest
#RUN apt-get update
#RUN apt-get install -y  python3.9
#RUN apt-get install -y python3-pip

#
# Debug network debian
#RUN apt-get install  -y inetutils-ping
#RUN apt-get install  -y iproute2
#RUN apt-get install  -y bind9-dnsutils
#RUN apt-get install  -y procps
#RUN apt-get install  -y curl


# alpine image com minikube em virtualbox falta DNS
FROM alpine:3.15.4
RUN apk add python3
RUN apk add py3-pip
RUN apk add bash

COPY . /app
WORKDIR /app
RUN  pip3 install -r requirements.txt

CMD ["python3", "/app/ser1.py" ]
