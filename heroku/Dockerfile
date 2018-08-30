FROM python:3.6

WORKDIR /app

COPY knot knot
COPY Makefile .

RUN make initial-setup

CMD ["make", "sync"]
