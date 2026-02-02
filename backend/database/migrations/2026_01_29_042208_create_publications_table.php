<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('publications', function (Blueprint $table) {
            $table->id('publication_id'); // PK sesuai model

            $table->string('title');
            $table->date('release_date')->nullable();

            // file & media
            $table->string('pdf_file')->nullable();
            $table->string('file_url')->nullable();
            $table->string('cover_url')->nullable();

            // konten
            $table->text('summary')->nullable();
            $table->text('description')->nullable();

            // metadata publikasi
            $table->unsignedBigInteger('publication_category')->nullable();
            $table->integer('catalog_number')->nullable();
            $table->string('publication_number')->nullable();
            $table->string('isbn')->nullable();

            $table->timestamps();

            // FK ke categories.category_id
            $table->foreign('publication_category')
                  ->references('category_id')
                  ->on('categories')
                  ->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('publications');
    }
};
