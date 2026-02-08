<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Feedback extends Model
{
    protected $table = 'feedbacks';

    protected $fillable = [
        'rating',
        'job',
        'tags',
        'message',
        'user_agent',
        'ip_address',
    ];

    protected $casts = [
        'tags' => 'array',
    ];
}
