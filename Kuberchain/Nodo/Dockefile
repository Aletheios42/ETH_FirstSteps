# Dockerfile para Ganache
FROM node:14

RUN npm install -g ganache-cli

EXPOSE 8545

CMD ["ganache-cli", "--host", "0.0.0.0", "--port", "8545", "--networkId", "5777"]

