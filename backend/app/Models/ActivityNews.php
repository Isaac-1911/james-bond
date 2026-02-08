<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ActivityNews extends Model
{
    protected $table = 'activity_news';
    protected $primaryKey = 'activity_news_id';

    protected $fillable = [
        'title',
        'summary',
        'image_url',
        'release_date'
    ];

    public $timestamps = true;

    public function getImageUrlAttribute($value){
        return $value
            ? asset('storage/' . $value)
            : null;
    }
}
