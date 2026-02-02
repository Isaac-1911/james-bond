<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\StatisticSubject;
use App\Models\StatisticSubsubject;
use App\Models\StatisticTable;
use App\Models\StatisticTableColumn;
use App\Models\StatisticTableRow;

class StatisticExampleTableSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Subject
        $subject = StatisticSubject::firstOrCreate(
            ['slug' => 'demografi-sosial'],
            ['name' => 'Statistik Demografi dan Sosial']
        );

        // 2. Subsubject
        $subsubject = StatisticSubsubject::firstOrCreate(
            [
                'subject_id' => $subject->id,
                'slug' => 'kependudukan-dan-migrasi',
            ],
            [
                'name' => 'Kependudukan dan Migrasi',
            ]
        );

        // 3. Statistic Table (judul tabel)
        $table = StatisticTable::create([
            'subsubject_id' => $subsubject->id,
            'title' => 'Jumlah Penduduk Menurut Kelompok Umur dan Jenis Kelamin di Kabupaten Bondowoso, 2021',
            'description' => 'Tabel ini menyajikan jumlah penduduk menurut kelompok umur dan jenis kelamin.',
            'last_updated' => '2021-12-31',
            'source' => 'BPS Kabupaten Bondowoso',
        ]);

        // 4. Columns
        $columns = [
            ['key' => 'male', 'label' => 'Penduduk (Laki-laki)', 'unit' => 'ribu jiwa'],
            ['key' => 'female', 'label' => 'Penduduk (Perempuan)', 'unit' => 'ribu jiwa'],
            ['key' => 'total', 'label' => 'Jumlah Penduduk', 'unit' => 'ribu jiwa'],
        ];

        foreach ($columns as $index => $col) {
            StatisticTableColumn::create([
                'table_id' => $table->id,
                'key_name' => $col['key'],
                'label' => $col['label'],
                'unit' => $col['unit'],
                'order_index' => $index,
            ]);
        }

        // 5. Rows
        $rows = [
            '0-4'   => ['male' => 29.4, 'female' => 28.2, 'total' => 57.6],
            '5-9'   => ['male' => 30.1, 'female' => 29.0, 'total' => 59.1],
            '10-14' => ['male' => 31.2, 'female' => 30.4, 'total' => 61.6],
            '15-19' => ['male' => 32.0, 'female' => 31.1, 'total' => 63.1],
            '20-24' => ['male' => 33.5, 'female' => 32.8, 'total' => 66.3],
        ];

        $order = 0;
        foreach ($rows as $label => $data) {
            StatisticTableRow::create([
                'table_id' => $table->id,
                'row_label' => $label,
                'row_order' => $order++,
                'data' => $data,
            ]);
        }
    }
}
