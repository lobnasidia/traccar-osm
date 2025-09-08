FROM traccar/traccar:latest

# Exposer le port web
EXPOSE 8082

# Le conteneur démarre automatiquement Traccar (déjà configuré dans l'image officielle)
