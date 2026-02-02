# 📊 James Bond Data Portal

James Bond adalah aplikasi **Data Portal** berbasis **REST API (Laravel)** dan **Frontend Flutter**.  
Aplikasi ini digunakan untuk menampilkan **data statistik, berita, publikasi, dan infografis** secara terpusat.

Project ini dibuat sebagai **project pembelajaran sekaligus portofolio**, dengan fokus utama pada:
- komunikasi **Flutter ↔ Laravel (REST API)**
- pemahaman **HTTP, JSON, async programming**
- struktur project yang rapi, modular, dan scalable

---

## 🏗️ Arsitektur Project
james-bond/
├── backend/ # Laravel 12 - REST API
└── frontend/ # Flutter - Mobile / Desktop App


### 🔹 Backend (Laravel)
- Laravel 12
- RESTful API
- JSON response standar (`status`, `message`, `data`)
- Authentication menggunakan Bearer Token (Sanctum)
- Endpoint utama:
  - `/api/news`
  - `/api/category`
  - `/api/publication`
  - `/api/statistics`
  - `/api/search-history`

### 🔹 Frontend (Flutter)
- Flutter (desktop & mobile ready)
- HTTP client menggunakan **Dio**
- Environment variable menggunakan **flutter_dotenv**
- Struktur folder terpisah (`api`, `screens`, `models`, `helpers`)
- Fokus awal pada koneksi & komunikasi API

---

## 🔁 Alur Kerja Aplikasi

User Interaction (Button / UI)
↓
Flutter (Dio HTTP Request)
↓
Laravel API
↓
Database Query
↓
JSON Response
↓
Flutter (Parsing Data & Update UI)


---

## ⚙️ Setup & Instalasi

```bash
1️⃣ Backend (Laravel)
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan serve --host=0.0.0.0 --port=8000

Pastikan backend bisa diakses melalui IP lokal:
http://<IP_KOMPUTER>:8000/api/news

2️⃣ Frontend (Flutter)

cd frontend
flutter pub get

Buat file .env di folder frontend/:
API_BASE_URL=http://<IP_KOMPUTER>:8000/api

flutter run

🧪 Status Implementasi
✅ Backend

 API News

 API Category

 API Publication (upload & download PDF)

 API Statistic Data

 API Search History

 Standar response API

🚧 Frontend

 Koneksi Flutter ↔ Laravel

 GET request pertama (News)

 Parsing data ke ListView

 Model data (News, Publication, dll)

 UI final

 Authentication flow

 🧠 Catatan Pembelajaran

Project ini dikembangkan dengan pendekatan belajar dari dasar, mencakup:

debugging error network (IP, port, binding)

perbedaan localhost vs IP LAN

pemahaman response.data pada Dio

penggunaan async / await dan setState

pemisahan logic API dan UI

👨‍💻 Author

Isaac
Mahasiswa S1 Teknik Informatika

Fokus pembelajaran:

Backend Development (Laravel)

Mobile App Development (Flutter)

Cybersecurity & Red Team (jangka panjang)

📌 License

Project ini dibuat untuk pembelajaran dan portofolio pribadi.
Bebas digunakan sebagai referensi belajar.
