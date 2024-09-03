from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import requests

app = FastAPI(debug=True)

class ModelCreation(BaseModel):
    from_model: str
    parameter: str
    system: str

create_model_url = "http://localhost:11434/api/create"

headers = {
    "Content-Type": "application/json"
}

# Configurazione del middleware CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Puoi specificare gli URL permessi, per esempio ["http://localhost:3000"]
    allow_credentials=True,
    allow_methods=["*"],  # Permette tutti i metodi (GET, POST, PUT, DELETE, ecc.)
    allow_headers=["*"],  # Permette tutte le intestazioni
)

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.post("/create")
def create_model(model_creation: ModelCreation):
    try:
        # Creare il contenuto del modello come stringa
        model_config_content = f"""
        FROM {model_creation.from_model}
        PARAMETER {model_creation.parameter}
        SYSTEM "{model_creation.system}"
        """

        # Creare il payload da inviare nella richiesta POST
        payload = {"model_config": model_config_content.strip()}

        # Log del payload per il debug
        print("Payload inviato:", payload)

        # Inviare la configurazione a ollama per creare il nuovo modello
        response = requests.post(create_model_url, headers=headers, json=payload)

        # Log della risposta per il debug
        print("Risposta ricevuta:", response.text)

        # Verifica se la richiesta ha avuto successo
        response.raise_for_status()

        # Se la richiesta ha avuto successo, restituire la risposta
        data = response.json()
        return {"response": data}
    except requests.exceptions.RequestException as e:
        print(f"Request failed: {e}")
        raise HTTPException(status_code=500, detail=f"Request failed: {str(e)}")
    except Exception as e:
        print(f"An error occurred: {e}")
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")
