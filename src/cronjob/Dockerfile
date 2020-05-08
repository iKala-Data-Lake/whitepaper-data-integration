FROM python:3-slim

RUN pip install --no-cache \
  PyMySQL pymongo \
  google-cloud-storage \
  click

ADD ./dump.py /app/dump.py

WORKDIR /app

ENTRYPOINT [ "python3", "-B", "dump.py" ]