from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Union
import json
import requests
import ollama

app = FastAPI(debug=True)

class Itemexample(BaseModel):
    name: str
    prompt: str
    instruction: str
    is_offer: Union[bool, None] = None

class Item(BaseModel):
    model: str
    prompt: str

class CreateModelRequest(BaseModel):
    name_model: str
    from_model: str
    parameter: str
    system: str
    description: str

class DeleteModelRequest(BaseModel):
    name_model: str

urls = {
    "generate": "http://localhost:11434/api/generate",
    "create": "http://localhost:11434/api/create",
    "delete": "http://localhost:11434/api/delete"
}

headers = {
    "Content-Type": "application/json"
}

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.post("/chat")
def chat_bot(item: Item):
    print(f"Request received for item: {item}")
    url = urls["generate"]
    payload = {
        "model": item.model,
        "prompt": item.prompt,
        "stream": False
    }
    try:
        response = requests.post(url, headers=headers, data=json.dumps(payload))
        response.raise_for_status()
        data = response.json()
        response_text = data.get("response", "")
        return {response_text}
    except requests.exceptions.RequestException as e:
        print(f"Request failed: {e}")
        raise HTTPException(status_code=500, detail=str(e))
# 
@app.post("/create")
def create_model(create_model_request: CreateModelRequest):
    try:
        modelfile_content = f'''
            FROM {create_model_request.from_model}
            PARAMETER {create_model_request.parameter}
            SYSTEM {create_model_request.system}
        '''.strip()

        ollama.create(model=f'{create_model_request.name_model}', modelfile=modelfile_content)

        return {"message": f"Model '{create_model_request.name_model}' created successfully. Description: {create_model_request.description}"}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@app.post("/delete")
def delete_model(delete_model_request: DeleteModelRequest):
    try:
        ollama.delete(model=delete_model_request.name_model)
        return {"Message": f"Model '{delete_model_request.name_model}' deleted"}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
