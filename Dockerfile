FROM debian:9

WORKDIR /app

RUN apt-get -y update && \
    apt-get -y install curl \
                       git \
                       postgresql-client \
                       unzip

RUN curl https://cli-assets.heroku.com/install.sh | sh

COPY heroku .

CMD ["bash", "deploy.sh"]
