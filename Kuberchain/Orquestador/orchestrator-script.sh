#!/bin/bash

# Número de instancias de Ganache
NUM_INSTANCES=${NUM_INSTANCES:-1}

# URLs de las instancias de Ganache
GANACHE_URLS=(
  "https://ganache-service-1-3ngluzgh5q-ew.a.run.app"
  "https://ganache-service-2-3ngluzgh5q-ew.a.run.app"
  "https://ganache-service-3-3ngluzgh5q-ew.a.run.app"
)

# Esperar a que todas las instancias de Ganache estén disponibles
for i in $(seq 1 $NUM_INSTANCES); do
  until curl -s ${GANACHE_URLS[$i-1]} > /dev/null; do
    echo "Esperando a Ganache-$i..."
    sleep 2
  done
  echo "Ganache-$i está disponible en ${GANACHE_URLS[$i-1]}"
done

# Lógica adicional para gestionar los otros contenedores (si aplica)
# Aquí puedes añadir más lógica según tus necesidades, como monitoreo, configuración, etc.

