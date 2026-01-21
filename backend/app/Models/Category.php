<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    protected $table = 'categories';
    protected $primaryKey = 'category_id';

    protected $fillable = [
        'name',
        'description'
    ];

    public $timestamps = true;

    public function statisticData(){
        return $this->hasMany(StatisticData::class, 'category_id');
    }
}
