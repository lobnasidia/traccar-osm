FROM python:3.12-slim

WORKDIR /app

# Installer les dépendances réseau pour tester et corriger les problèmes DNS
RUN apt-get update && apt-get install -y \
    iputils-ping \
    dnsutils \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
