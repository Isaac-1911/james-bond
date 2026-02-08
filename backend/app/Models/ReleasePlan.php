<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ReleasePlan extends Model
{
    protected $primaryKey = 'id';
    protected $table = 'release_plans';

    protected $fillable = [
        'title',
        'type',
        'planned_date',
        'released_date',
        'target_id'
    ];

    protected $casts = [
        'planned_date' => 'date',
        'released_date' => 'date',
    ];
}
