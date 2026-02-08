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
        1. BASE SYSTEM PROMPT (IDENTITAS AI)
        =====================================================
        */
        $baseSystemPrompt = <<<PROMPT
Kamu adalah Asisten James Bond Data Portal.

James Bond Data Portal adalah aplikasi portal data statistik dan informasi publik,
bukan tokoh fiksi, bukan film, dan tidak berhubungan dengan agen rahasia.

Peran kamu adalah membantu pengguna memahami aplikasi
dan menjelaskan konteks data yang ditampilkan.

Kamu tidak menarik kesimpulan numerik
dan tidak melakukan analisis statistik mendalam.
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
- Jelaskan:
  • topik utama tabel
  • konteks data secara umum
  • kegunaan data secara wajar
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
KONTEKS APLIKASI:

Menu utama:
- Beranda: ringkasan konten terbaru
- Publikasi: laporan statistik resmi dalam bentuk dokumen
- Statistik: tabel data statistik terstruktur
- Infografis: visualisasi data
- Berita Kegiatan
- Rencana Terbit
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
            $response = Http::timeout(120)->post(
                'http://127.0.0.1:8080/completion',
                [
                    'prompt'      => $finalPrompt,
                    'n_predict'   => 200,
                    'temperature' => 0.25,
                    'stream'      => false,
                    'stop' => [
                        "\nPertanyaan:",
                        "\nPERTANYAAN",
                    ],

                ]
            );

            $answer = trim($response['content'] ?? '');

            /*
            =====================================================
            6. LIGHT SANITIZER (KOSMETIK SAJA)
            =====================================================
            */
            $answer = preg_replace('/^(jawaban\s*:)\s*/i', '', $answer);
            $answer = preg_replace('/(pertanyaan|question)\s*:.*$/is', '', $answer);
            $answer = trim($answer);

            if ($answer === '') {
                $answer = 'Informasi tersedia dalam aplikasi, namun belum dapat dijelaskan lebih lanjut oleh asisten.';
            }

            if ($mode === 'guide') {
                $replacements = [
                    'melakukan analisis statistik' => 'memahami data secara umum',
                    'melihat trend' => 'melihat gambaran umum data',
                    'mengambil keputusan data-driven' => 'sebagai bahan referensi informasi',
                ];

                foreach ($replacements as $from => $to) {
                    $answer = str_ireplace($from, $to, $answer);
                }
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
