#!/usr/bin/env bash


python ./bin/servico1/ser1.py &
if [ $? -eq 0  ]
then
  echo "servidor iniciado"
else
  echo "Servidor   .... ERRO"
  exit 1
fi

PID=`ps aux | grep ser1 | sed 's/ \{1,\}/ /g'  | cut -f 2 -d " " | head -1 `
echo "servico teste com PID $PID"
sleep 5
curl localhost:$PORTO/
if [ $? -eq 0  ]
then
  echo "Servidor   .... ok"
else
  echo "Servidor   .... ERRO"
  exit 1
fi

kill -9 $PID
echo "parei PID $PID"
