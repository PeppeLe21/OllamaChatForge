# OllamaChatForge 🤖

## 📖 Overview

**OllamaChatForge** is a cross-platform mobile application that allows users to **query, create, and share advanced language models (LLMs)** leveraging [Ollama](https://ollama.com) and its customization options.

The project was born from the exponential growth of LLMs in natural language processing and the need to make these technologies accessible even to users without advanced technical knowledge. The goal is to make the personalization and sharing of language models as simple and intuitive as possible.

### ✨ Key Features

- 💬 **Chat with LLMs** — Interact with any model available in Ollama directly from the mobile app
- 🛠️ **Create custom models** — Define system instructions, parameters, and a description to forge your own LLM
- 🗑️ **Delete models** — Manage locally running models from a clean UI
- 👤 **User Profiles** — Authentication via Firebase (email/password and Google Sign-In)
- ☁️ **Cloud sync** — Model metadata stored and shared via Cloud Firestore

---

## 🏗️ Architecture

The application follows a **client-server architecture** composed of two independent modules:

```
OllamaChatForge/
├── OllamaChatForge-frontend/   # Flutter mobile app (Dart)
└── OllamaChatForge-backend/    # FastAPI server (Python)
```

### Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Frontend** | Dart + Flutter | Cross-platform mobile UI |
| **Backend** | Python + FastAPI | REST API layer |
| **LLM Engine** | Ollama | Local model inference & management |
| **Database** | Cloud Firestore | User data & model metadata |
| **Auth** | Firebase Auth + Google Sign-In | User authentication |
| **Storage** | Firebase Storage | User assets (e.g. profile pictures) |

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following tools installed:

- [Ollama](https://ollama.com) — LLM runtime (must be running locally)
- [Python 3.10+](https://www.python.org/downloads/) — for the backend server
- [Flutter SDK](https://flutter.dev/docs/get-started/install) — for the mobile frontend

---

### 1. Ollama Setup

Install and start Ollama on your machine. Pull at least one model to use with the app:

```bash
ollama pull llama3
```

Ollama will be listening at `http://localhost:11434` by default. The backend expects this address.

---

### 2. Backend Setup

Navigate to the backend directory and install the required Python packages:

```bash
cd OllamaChatForge-backend
pip install -r requirements.txt
```

Start the FastAPI server:

```bash
python -m uvicorn ollama_api:app --host 0.0.0.0 --port 8000 --reload
```

The server will be available at `http://0.0.0.0:8000`.

> **Note:** The server exposes the API on all network interfaces so that the mobile app can reach it from a physical device or emulator on the same network.

---

### 3. Frontend Setup

Navigate to the frontend directory:

```bash
cd OllamaChatForge-frontend
```

#### ⚙️ Configure the backend IP

Open `lib/src/utils/api_util.dart` and replace `'YourIP'` on line 5 with the **local IP address** of the machine running the backend (e.g. `192.168.1.x`).

#### ▶️ Run on emulator or device

Make sure you have an Android emulator running or a physical device connected, then:

```bash
flutter run
```

#### 📦 Build a release APK

```bash
flutter build apk --release
```

The APK will be generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 📂 Project Structure

```
OllamaChatForge-frontend/lib/
├── main.dart
├── Start.dart
├── firebase_options.dart
└── src/
    ├── common_widgets/       # Reusable UI components
    ├── constants/            # App-wide constants and theme
    ├── features/
    │   ├── authentication/   # Login, registration, Google Sign-In
    │   └── core/
    │       ├── controllers/  # GetX state management
    │       ├── models/       # Data models
    │       └── screens/
    │           ├── dashboard/ # Chat & model selection
    │           ├── drawer/    # Side navigation
    │           └── profile/   # User profile management
    ├── manager/              # Service managers
    ├── repository/           # Data layer (Firestore, Firebase)
    ├── services/             # API calls and external services
    └── utils/                # Utilities (API config, helpers)
```
