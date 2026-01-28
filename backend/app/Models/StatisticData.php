<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StatisticData extends Model
{
    protected $table = 'statistic_data';
    protected $primaryKey = 'id';

    protected $fillable = [
        'id',
        'indicator_id',
        'year',
        'region',
        'value'
    ];

    public $timestamps = true;

    public function category(){
        return $this->belongsTo(Category::class, 'category_id');
    }

    public function indicator(){
        return $this->belongsTo(StatisticIndicator::class);
    }
}
