<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Infographic extends Model
{
    protected $table = 'infographics';
    protected $primaryKey = 'infographic_id';

    protected $fillable = [
        'title',
        'description',
        'image_url'
    ];

    public $timestamps = true;
}
