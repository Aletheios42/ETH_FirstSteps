#!/bin/bash

# Solicitar al usuario el Project ID de GCP
read -p "Introduce tu Project ID de GCP: " PROJECT_ID

# Construir y subir la imagen de Ganache
echo "Construyendo y subiendo la imagen de Ganache..."
docker build -t gcr.io/$PROJECT_ID/ganache ./Node
docker push gcr.io/$PROJECT_ID/ganache

# Construir y subir la imagen del Orquestador
echo "Construyendo y subiendo la imagen del Orquestador..."
docker build -t gcr.io/$PROJECT_ID/orchestrator ./Orquestador
docker push gcr.io/$PROJECT_ID/orchestrator

# Solicitar al usuario el número de instancias de Ganache a desplegar
read -p "Introduce el número de instancias de Ganache que deseas desplegar: " NUM_INSTANCES

# Verificar que se ingresó un número válido
if ! [[ "$NUM_INSTANCES" =~ ^[0-9]+$ ]]
then
    echo "Error: El número de instancias debe ser un número entero."
    exit 1
fi

# Habilitar API de Cloud Run si no está habilitada
gcloud services enable run.googleapis.com

# Desplegar el número especificado de instancias de Ganache en Cloud Run
for i in $(seq 1 $NUM_INSTANCES); do
  echo "Desplegando ganache-service-$i en Cloud Run..."
  gcloud run deploy ganache-service-$i --image gcr.io/$PROJECT_ID/ganache --platform managed --allow-unauthenticated --port 8545
done

# Desplegar el servicio Orquestador con la variable de entorno NUM_INSTANCES
echo "Desplegando el servicio Orquestador en Cloud Run..."
gcloud run deploy orchestrator-service --image gcr.io/$PROJECT_ID/orchestrator --platform managed --allow-unauthenticated --set-env-vars NUM_INSTANCES=$NUM_INSTANCES

echo "Despliegue completo."

