# Dockerfile para el Orquestador
FROM google/cloud-sdk:slim

RUN apt-get update && apt-get install -y kubectl

COPY ./orchestrator-script.sh /orchestrator-script.sh

RUN chmod +x /orchestrator-script.sh

CMD ["/orchestrator-script.sh"]

