<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StatisticTableColumn extends Model
{
    protected $table = 'statistic_table_columns';

    protected $fillable = [
        'table_id',
        'key_name',
        'label',
        'unit',
        'order_index',
    ];

    public function table()
    {
        return $this->belongsTo(
            StatisticTable::class,
            'table_id'
        );
    }
}
