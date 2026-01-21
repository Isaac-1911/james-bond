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
        'publication_category',
        'description'
    ];

    public $timestamps = true;

    public function category(){
        return $this->belongsTo(Category::class, 'publication_category');
    }

   public function getFileUrlAttribute($value)
{
    return $value
        ? asset('storage/' . $value)
        : null;
}

}
