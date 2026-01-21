<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class News extends Model
{
    protected $table = 'news';
    protected $primaryKey = 'news_id';

    protected $fillable = [
        'title',
        'release_date',
        'image_url',
        'summary'
    ];

    public $timestamps = true;

    public function getImageUrlAttribute($value)
{
    return $value
        ? asset('storage/' . $value)
        : null;
}

}
