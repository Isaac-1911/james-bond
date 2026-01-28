<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StatisticIndicator extends Model {

    protected $table = 'statistic_indicators';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'subsubject_id',
        'title',
        'unit',
        'description'
    ];

    public function subsubject() {
        return $this->belongsTo(StatisticSubsubject::class);
    }

    public function data() {
        return $this->hasMany(StatisticData::class, 'indicator_id');
    }
}

