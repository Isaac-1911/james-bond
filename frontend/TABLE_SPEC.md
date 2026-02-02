1️⃣ KONTEXT PROJECT (RINGKAS)

Project: James Bond Data Portal

Frontend: Flutter

Backend: Laravel (REST API)

Status: - Publication page: ~90% selesai & stabil
        - Selanjutnya fokus: Halaman Tabel (paling kompleks)

statistic_subjects
  └─ statistic_subsubjects
      └─ statistic_indicators
          └─ statistic_data

Tab Tabel
 └─ Subject (3 kartu besar)
     └─ Dropdown Subsubject
         └─ List Indicator
             └─ Table Screen (pagination)



nah bingungnya gua itu disini son pada halaman tabel yang bisa diakses lewat main_navigation, halaman utamanya itu terdiri dari 3 elemen subjek yaitu Statistik Demografi dan Sosial, Statistik Ekonomi, dan Statistik Lingkungan Hidup dan Multi-domain. dan di setiap subjek itu menampilkan dropdown berupa sub subjek. dan setiap sub subjek itu ketika di klik juga berisi beberapa indikator son. biar gampang gua kasih gambaran kasarnya aja dan lebih lengkapnya lu bisa akses disini: https://bondowosokab.bps.go.id/id/statistics-table?subject=519.

- Statistik Demografi dan Sosial:
    - Kependudukan dan Migrasi:
        - Faktor Penyebab Perceraian menurut Bulan di kabupaten Bondowoso 2018
        - Hasil Sensus Penduduk 2020 per Kecamatan (jiwa)
        - Hasil sensus Penduduk Kabupaten Bondowoso
        - Jumlah Nikah dan Rujuk di Kabupaten Bondowoso, 2018
        - ...
    - Tenaga Kerja
    - Pendidikan
    - Kesehatan
    - Konsumsi dan Pendapatan
    - Perlindungan Sosial
    - Pemukiman dan Perumahan
    - Hukum dan Kriminal
    - Budaya
    - Aktivitas Politik dan Komunitas Lainnya
    - Penggunaan Waktu

- Statistik Ekonomi:
    - Statistik Makroekonomi
    - Neraca Ekonomi
    - Statistik Bisnis
    - Statistik Sektoral
    - Keuangan Pemerintah, Fiskal dan Statistik Sektor Publik
    - Perdagangan Internasional dan Neraca Pembayaran
    - Harga-Harga
    - Biaya Tenaga Kerja
    - Ilmu Pengetahuan, Teknologi, dan Inovasi
    - Pertanian, Kehutanan, Perikanan
    - Energi
    - Pertambangan, Manufaktur, Konstruksi
    - Transportasi
    - Pariwisata
    - Perbankan, Asuransi dan Finansial

- Statistik Lingkungan Hidup dan Multi-domain:
    - Lingkungan
    - Statistik Regional dan Statistik Area Kecil
    - Statistik dan Indikator Multi-domain
    - Buku Tahunan dan Ringkasan Sejenis
    - Kondisi Tempat Tinggal, Kemmiskinan, dan Permasalahan Sosial Lintas Sektor
    - Gender dan Kelompok Populasi Khusus
    - Masyarakat Informasi
    - Globalisasi
    - Indikator Milenium Development Goals (MDGs)
    - Perkembangan Berkelanjutan
    - Kewiraswastaan

maksudnya itu gini son nanti di 3 subjek itu ada beberapa sub subjek seperti Kependudukan dan Migrasi pada subjek Statistik Demografi dan Sosial. dan di dalam sub subjek itu ada tabel seperti Hasil Sensus Penduduk 2020 per Kecamatan (jiwa). nah gua itu bingung son ngatur datanya gimana sedangkan database gua masih ada tabel seperti ini: 

+------------------------+
| Tables_in_james_bond   |
+------------------------+
| cache                  |
| cache_locks            |
| categories             |
| failed_jobs            |
| infographics           |
| job_batches            |
| jobs                   |
| migrations             |
| news                   |
| personal_access_tokens |
| publications           |
| search_history         |
| statistic_data         |
| users                  |
+------------------------+

apa gua harus rombak database gua lagi son untuk tabel itu biar ga perlu ribet lagi nantinya kalo ada perubahan? tolong gua son gua bingung disini
