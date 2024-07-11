#!/bin/bash

# Número de instancias de Ganache
NUM_INSTANCES=${NUM_INSTANCES:-1}

# Esperar a que todas las instancias de Ganache estén disponibles
for i in $(seq 1 $NUM_INSTANCES); do
  until curl -s http://ganache-service-$i-url:8545 > /dev/null; do
    echo "Esperando a Ganache-$i..."
    sleep 2
  done
  echo "Ganache-$i está disponible"
done

# Lógica adicional para gestionar los otros contenedores (si aplica)

