<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StatisticData extends Model
{
    protected $table = 'statistic_data';
    protected $primaryKey = 'data_id';

    protected $fillable = [
        'category_id',
        'title',
        'description',
        'value',
        'unit',
        'period'
    ];

    public $timestamps = true;

    public function category(){
        return $this->belongsTo(Category::class, 'category_id');
    }
}
