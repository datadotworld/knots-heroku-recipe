FROM python:3.6

WORKDIR /app

COPY knot knot
COPY Makefile .

RUN apt-get -y update && \
    apt-get -y install postgresql-client

RUN make initial-setup

CMD ["make", "sync"]
