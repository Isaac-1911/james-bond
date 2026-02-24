<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('statistic_table_columns', function (Blueprint $table) {
            $table->id();

            $table->foreignId('table_id')
                  ->constrained('statistic_tables')
                  ->cascadeOnDelete();

            $table->string('key_name');      // contoh: male, female, total
            $table->string('label');         // contoh: Penduduk (Laki-laki)
            $table->string('unit')->nullable(); // ribu jiwa, %, km²
            $table->integer('order_index');

            $table->timestamps();

            $table->unique(['table_id', 'key_name']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('statistic_table_columns');
    }
};

