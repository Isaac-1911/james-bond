<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Publication extends Model
{
    protected $table = 'publications';
    protected $primaryKey = 'publication_id';

    protected $fillable = [
        'title',
        'release_date',
        'pdf_file',
        'summary',
        'publication_category',
        'cover_url',
        'file_url',
        'description',
        'catalog_number',
        'publication_number',
        'isbn',
        'download_count',
        'is_featured',

    ];

    protected $casts = [
        'is_featured' => 'boolean'
    ];

    public $timestamps = true;

    public function category()
    {
        return $this->belongsTo(Category::class, 'publication_category');
    }

    public function getFileUrlAttribute($value)
    {
        return $value
            ? asset('storage/' . $value)
            : null;
    }
}
