<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StatisticSubject extends Model
{
    protected $table = 'statistic_subjects';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'name',
        'slug'
    ];

    public function subsubjects(){
        return $this->hasMany(StatisticSubsubject::class, 'subject_id');
    }
}
