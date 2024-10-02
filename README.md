# OllamaChatForge

## ENG

Welcome to the OllamaChatForge project! This repository contains the code for both the back-end and the front-end of the application. Below are instructions on how to set up and run the application on your local machine.

### Prerequisites

Before getting started, make sure you have the following tools installed on your system:

- [Ollama](https://ollama.com) (for using language models)
- [Python](https://www.python.org/downloads/) (for running the back-end)
- [Flutter](https://flutter.dev/docs/get-started/install) (for running the front-end)

### Ollama Installation and Setup

Ensure that Ollama is installed and running properly before starting the back-end of the application. This is necessary for the correct functioning of the language models within the application.

### Back-End Setup

To run the back-end, you need to start the FastAPI server. Follow these steps:

1. Navigate to the directory containing the back-end code.
2. Install the required Python packages by running:

   ```bash
   pip install -r requirements.txt

3. Start the server with the following command:
   
   ```bash
   python -m uvicorn ollama_api:app --host 0.0.0.0 --port 8000 --reload
This command will start the FastAPI server at `http://0.0.0.0:8000`.

#### Important Note:

To use the back-end APIs correctly, you need to modify the `api_util.dart` file in the front-end code:

- Open `api_util.dart`
- Go to line 5 and replace 'YourIP' with the IP address of your local machine.

### Front-End Setup

To run the front-end of the application, you can use an emulator or build an APK to install directly on an Android device.

#### Running on an Emulator

1. Open a terminal and navigate to the front-end code directory.
2. Ensure you have an Android emulator running or a physical device connected.
3. Start the Flutter application by running:
   
   ```bash
   flutter run

#### Building the APK

1. If you want to build an APK to install directly on an Android device, use the following command: 
   ```bash
   flutter build apk --release

This command will generate a release version of the APK in the `build/app/outputs/flutter-apk/directory`, which you can then install on your Android device.


## ITA

Benvenuto nel progetto OllamaChatForge! Questa repository contiene il codice sia per il back-end che per il front-end dell'applicazione. Di seguito troverai le istruzioni su come configurare ed eseguire l'applicazione sulla tua macchina locale.

### Prerequisiti

Prima di iniziare, assicurati di aver installato i seguenti strumenti sul tuo sistema:

- [Ollama](https://ollama.com) (per l'utilizzo dei modelli linguistici)
- [Python](https://www.python.org/downloads/) (per eseguire il back-end)
- [Flutter](https://flutter.dev/docs/get-started/install) (per eseguire il front-end)

### Installazione e Configurazione di Ollama

Assicurati di aver installato Ollama e che sia in esecuzione correttamente prima di avviare il back-end dell'applicazione. Questo è necessario per il corretto funzionamento dei modelli linguistici all'interno dell'applicazione.

### Configurazione del Back-End

Per eseguire il back-end, dovrai avviare il server FastAPI. Segui questi passaggi:

1. Vai nella directory contenente il codice del back-end.
2. Installa i pacchetti Python richiesti eseguendo:

   ```bash
   pip install -r requirements.txt

3. Avvia il server con il seguente comando:
   
   ```bash
   python -m uvicorn ollama_api:app --host 0.0.0.0 --port 8000 --reload
Questo comando avvierà il server FastAPI su `http://0.0.0.0:8000`.

#### Nota Importante:

Per utilizzare correttamente le API del back-end, è necessario modificare il file `api_util.dart` nel codice del front-end:

- Apri `api_util.dart`
- Vai alla riga 5 e sostituisci 'YourIP' con l'indirizzo IP della tua macchina locale.

### Configurazione del Front-End

Per eseguire il front-end dell'applicazione, puoi utilizzare un emulatore oppure costruire un APK da installare direttamente su un dispositivo Android.

#### Esecuzione su Emulatore

1. Apri il terminale e naviga nella directory del codice del front-end.
2. Assicurati di avere un emulatore Android in esecuzione o un dispositivo fisico collegato.
3. Avvia l'applicazione Flutter eseguendo:
   
   ```bash
   flutter run

#### Creazione dell'APK

1. Se desideri creare un APK da installare direttamente su un dispositivo Android, utilizza il seguente comando: 
   ```bash
   flutter build apk --release

Questo comando genererà una versione di rilascio dell'APK nella directory `build/app/outputs/flutter-apk/directory`, che potrai poi installare sul tuo dispositivo Android.
