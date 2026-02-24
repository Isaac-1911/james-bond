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
        Schema::create('statistic_indicators', function (Blueprint $table) {
            $table->id();
            $table->foreignId('subsubject_id')
                ->constrained('statistic_subsubjects')
                ->cascadeOnDelete();

            $table->string('title');
            $table->string('unit')->nullable(); // jiwa, persen, dll
            $table->text('description')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('statistic_indicators');
    }
};
