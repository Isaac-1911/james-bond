<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use App\Models\StatisticTable;

class ChatController extends Controller
{
    public function chat(Request $request)
    {
        $question = trim($request->input('message'));
        $tableId  = $request->input('table_id');

        if ($question === '') {
            return response()->json([
                'answer' => 'Pertanyaan kosong.'
            ], 400);
        }

        /*
        =====================================================
        1. BASE SYSTEM PROMPT
        =====================================================
        */
        $baseSystemPrompt = <<<PROMPT
Kamu adalah Asisten Resmi James Bond Data Portal.

Nama kamu adalah Cong Wo alias Kacong Bondowoso

James Bond Data Portal adalah aplikasi portal data statistik dan informasi publik
milik instansi pemerintah daerah Kabupaten Bondowoso. Aplikasi ini TIDAK berhubungan dengan tokoh fiksi,
film, atau agen rahasia.

Peran kamu adalah sebagai asisten informasi dan panduan pengguna aplikasi.
Kamu membantu pengguna:
- memahami fungsi menu dan fitur aplikasi
- memahami konteks umum data statistik yang ditampilkan
- memahami tujuan dan kegunaan data bagi publik

Karakter jawaban kamu:
- informatif
- jelas
- tenang
- netral
- mudah dipahami oleh masyarakat umum

Batasan penting:
- Kamu BUKAN analis statistik
- Kamu TIDAK menarik kesimpulan numerik
- Kamu TIDAK membandingkan angka
- Kamu TIDAK melakukan prediksi, tren, atau evaluasi data

Namun, kamu BOLEH:
- menjelaskan topik data secara umum
- menjelaskan konteks dan latar belakang data
- menjelaskan kegunaan data secara wajar
- membantu pengguna memahami istilah atau struktur data

Gaya bahasa:
- Bahasa Indonesia formal namun ramah
- Tidak menggunakan label seperti “Jawaban:” atau “Penjelasan:”
- Tidak mengulang pertanyaan pengguna
- Tidak membuka dengan salam atau sapaan umum
- Jawaban boleh 2–5 kalimat jika diperlukan untuk kejelasan

Struktur berpikir:
- Pahami dulu maksud pertanyaan
- Identifikasi apakah pertanyaan terkait fitur aplikasi atau tabel statistik
- Jawab secara langsung dan kontekstual
- Akhiri jawaban secara alami tanpa tambahan yang tidak perlu

PROMPT;

        /*
        =====================================================
        2. MODE DETECTION
        =====================================================
        */
        $mode = $tableId ? 'table_context' : 'guide';

        /*
        =====================================================
        3. MODE PROMPT + CONTEXT
        =====================================================
        */
        if ($mode === 'table_context') {

            $table = StatisticTable::find($tableId);

            if (!$table) {
                return response()->json([
                    'answer' => 'Tabel statistik tidak ditemukan.'
                ], 404);
            }

            $modePrompt = <<<PROMPT
MODE: TABLE_CONTEXT

Aturan:
- Jawab secara deskriptif dan kontekstual
- Jangan mengulang pertanyaan pengguna
- Jangan menambahkan label seperti "Jawaban:" atau "Pertanyaan:"
- Jawaban boleh cukup panjang selama tetap jelas dan informatif
- Jelaskan topik utama tabel, konteks data, dan kegunaan data secara umum
- Sebutkan sumber data jika tersedia
- Jangan menyebutkan angka detail dari tabel
- Jangan menarik kesimpulan statistik numerik
- Hentikan jawaban setelah penjelasan selesai
PROMPT;

            $contextPrompt = <<<PROMPT
KONTEKS TABEL STATISTIK:

Judul: {$table->title}
Deskripsi: {$table->description}
Sumber: {$table->source}
Terakhir diperbarui: {$table->last_updated}

Gunakan konteks ini untuk menjelaskan:
- topik utama tabel
- jenis informasi yang disajikan
- kegunaan data bagi pengguna

Jangan menyebutkan angka atau nilai spesifik dari tabel.
PROMPT;
        } else {

            $modePrompt = <<<PROMPT
MODE: GUIDE

Aturan:
- Jawab pertanyaan secara langsung tanpa mengulang pertanyaan
- Jangan menambahkan label seperti "Jawaban:" atau "Pertanyaan:"
- Jawaban berupa paragraf informatif yang mudah dipahami
- Jelaskan fungsi menu atau fitur aplikasi dengan jelas
- Gunakan bahasa Indonesia formal dan ramah
- Jangan membahas angka atau analisis statistik
- Hentikan jawaban setelah penjelasan selesai
PROMPT;

            $contextPrompt = <<<PROMPT
Konteks aplikasi:

Menu utama dalam aplikasi:
- Beranda: menampilkan ringkasan konten terbaru
- Publikasi: dokumen laporan statistik resmi
- Statistik: tabel data statistik terstruktur
- Infografis: penyajian data dalam bentuk visual
- Berita Kegiatan: informasi aktivitas dan rilis data
- Rencana Terbit: jadwal rilis publikasi dan berita statistik

Gunakan konteks ini untuk menjelaskan fungsi menu atau alur penggunaan aplikasi.

PROMPT;
        }

        /*
        =====================================================
        4. FINAL PROMPT
        =====================================================
        */
        $finalPrompt = implode("\n\n", [
            $baseSystemPrompt,
            $modePrompt,
            $contextPrompt,
            "Pertanyaan:\n{$question}\n\nBerikan jawaban secara langsung sesuai aturan di atas."
        ]);

        /*
        =====================================================
        5. CALL LLM
        =====================================================
        */
        try {

            // =================================================
            // LLAMA.CPP (DISIMPAN UNTUK FUTURE / FALLBACK)
            // =================================================
            /*
    $response = Http::timeout(120)->post(
        'http://127.0.0.1:8080/completion',
        [
            'prompt'      => $finalPrompt,
            'n_predict'   => 200,
            'temperature' => 0.25,
            'stream'      => false,
        ]
    );

    $answer = trim($response['content'] ?? '');
    */

            // =================================================
            // GEMINI (PRIMARY ENGINE)
            // =================================================
            $response = Http::timeout(30)
                ->withHeaders([
                    'Content-Type' => 'application/json',
                    'X-Goog-Api-Key' => config('services.gemini.key'),
                ])
                ->post(
                    'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash-lite:generateContent',
                    [
                        'contents' => [
                            [
                                'role' => 'user',
                                'parts' => [
                                    ['text' => $finalPrompt],
                                ],
                            ],
                        ],
                        'generationConfig' => [
                            'temperature' => 0.35,
                            'maxOutputTokens' => 600,
                        ],
                    ]
                );

            $data = $response->json();

            $answer = '';

            if (!empty($data['candidates'][0]['content']['parts'])) {
                foreach ($data['candidates'][0]['content']['parts'] as $part) {
                    if (isset($part['text'])) {
                        $answer .= $part['text'];
                    }
                }
            }

            $answer = trim($answer);

            if ($answer === '') {
                $answer = 'Informasi tersedia dalam aplikasi, namun belum dapat dijelaskan lebih lanjut oleh asisten.';
            }

            return response()->json([
                'answer' => $answer
            ]);
        } catch (\Throwable $e) {
            return response()->json([
                'answer' => 'AI sedang sibuk, silakan coba lagi.',
            ], 500);
        }
    }
}
