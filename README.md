# XNusa: Explore Your Nusantara 🇮🇩

![XNusa Banner](path/to/your/banner-image.png)
**XNusa** adalah platform ekosistem digital kebudayaan dan pariwisata yang menggabungkan kecerdasan buatan (*Artificial Intelligence*) dan komputasi spasial (*Spatial Computing*) untuk menghadirkan pengalaman eksplorasi budaya Indonesia yang imersif, interaktif, dan inklusif.

Proyek ini dikembangkan oleh tim **Troopers** dari Telkom University bekerja sama dengan BRIN (Badan Riset dan Inovasi Nasional).

---

## 📖 Table of Contents
- [Background](#-background)
- [Key Features](#-key-features)
- [System Architecture](#-system-architecture)
- [Tech Stack](#-tech-stack)
- [Installation](#-installation)
- [The Team](#-the-team)

---

## 💡 Background

Pelestarian budaya di era digital menghadapi tantangan disrupsi teknologi dan kurangnya media edukasi yang interaktif. **XNusa** hadir sebagai solusi yang mengintegrasikan:
1.  **Citizen Science:** Partisipasi masyarakat dalam pengayaan data budaya.
2.  **Immersive Technology:** Penggunaan AR untuk visualisasi objek budaya.
3.  **Artificial Intelligence:** Chatbot berbasis RAG (*Retrieval-Augmented Generation*) untuk edukasi budaya yang akurat.

Tujuan utama XNusa adalah mendorong pelestarian budaya, memeratakan informasi destinasi wisata (khususnya wilayah 3T), dan meningkatkan literasi digital berbasis budaya.

---

## 🚀 Key Features

### 1. Nusa AI (Cultural Chatbot) 🤖
Fitur chatbot cerdas yang berfungsi sebagai pemandu budaya virtual.
* **Teknologi:** Menggunakan LLM (GPT-4o) dengan metode **RAG (Retrieval-Augmented Generation)**.
* **Fungsi:** Memberikan jawaban kontekstual tentang budaya dan pariwisata berdasarkan *knowledge base* yang telah dikurasi dan data dari kontribusi pengguna.

### 2. Explore Nusa (AR Experience) 🌍
Eksplorasi spasial interaktif menggunakan teknologi *Augmented Reality*.
* **Map Explore:** Peta interaktif Indonesia (Sumatera, Jawa, Bali, Papua, dll) untuk memilih wilayah eksplorasi.
* **AR Mode:** Menampilkan objek 3D (artefak, landmark, kuliner) secara nyata melalui kamera *smartphone* (didukung oleh **MyWebAR**).

### 3. XNusa Thread (Citizen Science) 💬
Wadah kolaborasi bagi pengguna untuk berkontribusi melestarikan budaya.
* **Fitur:** Pengguna dapat memposting cerita rakyat, foto budaya, atau informasi lokal.
* **Moderasi:** Dilengkapi sistem moderasi AI (OpenAI Moderation API) untuk menyaring konten sebelum dijadikan *knowledge chip* bagi Nusa AI.

---

## 🏗 System Architecture

Sistem XNusa dirancang dengan arsitektur modular yang memisahkan *frontend*, *backend*, dan layanan AI untuk skalabilitas.

| Komponen | Deskripsi |
| :--- | :--- |
| **Frontend** | Aplikasi Mobile berbasis **Flutter**. |
| **Backend** | REST API menggunakan **Spring Boot**. |
| **Database** | **PostgreSQL** (Supabase) & **PGVector** untuk *vector storage*. |
| **AI Engine** | **Spring AI** yang mengorkestrasi LLM dan RAG Pipeline. |
| **AR Engine** | Integrasi **MyWebAR** (WebAR based). |

---

## 🛠 Tech Stack

Berikut adalah teknologi yang digunakan dalam pengembangan XNusa:

| Layer | Technology |
| :--- | :--- |
| **Mobile Framework** | Flutter (Dart) |
| **Backend Framework** | Spring Boot (Java) |
| **BaaS / Auth** | Supabase (Auth, Storage, DB) |
| **AI / LLM** | OpenAI GPT-4o, Spring AI |
| **Vector DB** | PGVector |
| **Augmented Reality** | MyWebAR |
| **Design Tools** | Figma |

---

## 📱 Installation & Requirements

### Minimum Requirements
* **OS:** Android 10+
* **RAM:** 4 GB
* **Processor:** Mid-range (e.g., Snapdragon 720G / Helio G90T)
* **AR Support:** Perangkat harus mendukung browser dengan kemampuan WebXR/MyWebAR.

### Setup (For Developers)
1.  Clone repository ini:
    ```bash
    git clone [https://github.com/username/xnusa-app.git](https://github.com/username/xnusa-app.git)
    ```
2.  Masuk ke direktori project:
    ```bash
    cd xnusa-app
    ```
3.  Install dependencies:
    ```bash
    flutter pub get
    ```
4.  Konfigurasi Environment Variables (buat file `.env`):
    ```env
    SUPABASE_URL=your_supabase_url
    SUPABASE_ANON_KEY=your_supabase_key
    OPENAI_API_KEY=your_openai_key
    ```
5.  Run aplikasi:
    ```bash
    flutter run
    ```

---

## 👥 The Team (Troopers)

Project ini dikembangkan untuk memenuhi tugas *Computing Project* di Telkom University.

* **Project Manager:** Nadiella Fitantriani Putri
* **Front End Developer:** Muhamad Iqbal Rizaldy Ernata
* **Front End Developer:** Andito Rizkyka Rianto
* **Back End Developer:** Rheno Febrian Cholistyo
* **Software Tester:** Nabil Falah Rabbani
* **Software Analyst:** Ariq Atmaja Deza

---

## 📄 License

Project ini dilisensikan di bawah [MIT License](LICENSE).
<br>
*Developed with ❤️ by Troopers Team.*
