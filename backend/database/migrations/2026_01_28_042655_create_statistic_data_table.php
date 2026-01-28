<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Schema::create('statistic_data', function (Blueprint $table) {
        //     $table->id();

        //     $table->foreignId('indicator_id')
        //         ->constrained('statistic_indicators')
        //         ->cascadeOnDelete();

        //     $table->integer('year');
        //     $table->string('region'); // Kecamatan / Wilayah
        //     $table->decimal('value', 15, 4);

        //     $table->timestamps();
        // });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('statistic_data');
    }
};
