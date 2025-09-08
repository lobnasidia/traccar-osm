from flask import Flask, request, jsonify
from geopy.geocoders import Nominatim

app = Flask(__name__)
geolocator = Nominatim(user_agent="reverse_service")

# Liste des pays autorisés avec différentes variations
ALLOWED_COUNTRIES = [
    "tunisia", "tunisie", "republic of tunisia", "république de tunisie",
    "libya", "libye", "state of libya", "état de libye",
    "algeria", "algérie", "people's democratic republic of algeria", "république algérienne démocratique et populaire"
]

@app.route("/reverse")
def reverse():
    lat = request.args.get("lat")
    lon = request.args.get("lon")
    
    if not lat or not lon:
        return jsonify({"error": "Please provide lat and lon"}), 400
    
    try:
        location = geolocator.reverse((lat, lon), exactly_one=True, language="fr")
        
        if location is None or not location.raw.get("address"):
            return jsonify({"error": "Location not found"}), 404
        
        country = location.raw["address"].get("country", "").lower()
        print("DEBUG country:", country)  # Debug pour vérifier le nom renvoyé
        
        if country not in ALLOWED_COUNTRIES:
            return jsonify({"error": "Location outside allowed countries"}), 403
        
        return jsonify({"address": location.address})
    
    except Exception as e:
        return jsonify({"error": f"Geocoding error: {str(e)}"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
