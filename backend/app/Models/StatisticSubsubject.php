<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StatisticSubsubject extends Model {

    protected $table = 'statistic_subsubjects';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'subject_id',
        'name',
        'slug'
    ];

    public function subject() {
        return $this->belongsTo(StatisticSubject::class);
    }

    public function indicators() {
        return $this->hasMany(StatisticIndicator::class, 'subsubject_id');
    }
}

