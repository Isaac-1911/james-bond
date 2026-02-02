<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('statistic_table_rows', function (Blueprint $table) {
            $table->id();

            $table->foreignId('table_id')
                  ->constrained('statistic_tables')
                  ->cascadeOnDelete();

            $table->string('row_label'); // 0-4, 5-9, Maesan, Grujugan
            $table->integer('row_order')->default(0);

            $table->json('data'); // isi kolom dinamis

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('statistic_table_rows');
    }
};

