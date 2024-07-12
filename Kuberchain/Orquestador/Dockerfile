# Dockerfile para el Orquestador
FROM google/cloud-sdk:slim

RUN apt-get update && apt-get install -y kubectl curl

COPY ./orchestrator-script.sh /orchestrator-script.sh

RUN chmod +x /orchestrator-script.sh

# Exponer el puerto 8080
EXPOSE 8080

# Iniciar el script de orquestación
CMD ["/orchestrator-script.sh"]

