FROM python:3-slim

RUN pip install --no-cache \
  flask gunicorn \
  mysql-connector-python pymongo

ADD ./ /app/

WORKDIR /app

ENTRYPOINT [ "gunicorn", "-b", "0.0.0.0:8080", "--access-logfile", "logs/access.log", "server:app" ]