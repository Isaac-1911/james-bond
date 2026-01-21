<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SearchHistory extends Model
{
    protected $table = 'search_history';
    protected $primaryKey = 'search_id';

    protected $fillable = [
        'user_id',
        'keyword'
    ];

    public $timestamps = false;
}
