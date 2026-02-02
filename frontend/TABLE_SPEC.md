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

INSERT INTO statistic_table_rows
(table_id, row_label, row_order, data, created_at, updated_at)
VALUES
(
  3,
  'Kabupaten Bondowoso',
  1,
  '{"male":382226,"female":393925,"total":776151}',
  NOW(),
  NOW()
),
(
  3,
  'Maesan',
  2,
  '{"male":23858,"female":24218,"total":48076}',
  NOW(),
  NOW()
),
(
  3,
  'Grujugan',
  3,
  '{"male":18438,"female":18676,"total":37114}',
  NOW(),
  NOW()
),
(
  3,
  'Tamanan',
  4,
  '{"male":19015,"female":19399,"total":38414}',
  NOW(),
  NOW()
),
(
  3,
  'Jambesari DS',
  5,
  '{"male":17884,"female":18202,"total":36086}',
  NOW(),
  NOW()
),
(
  3,
  'Pujer',
  6,
  '{"male":19672,"female":20554,"total":40226}',
  NOW(),
  NOW()
),
(
  3,
  'Tlogosari',
  7,
  '{"male":22642,"female":23062,"total":45704}',
  NOW(),
  NOW()
),
(
  3,
  'Sukosari',
  8,
  '{"male":7560,"female":7967,"total":15527}',
  NOW(),
  NOW()
),
(
  3,
  'Sumber Wringin',
  9,
  '{"male":16856,"female":17375,"total":34231}',
  NOW(),
  NOW()
);
