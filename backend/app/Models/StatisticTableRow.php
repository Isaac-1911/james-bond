<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StatisticTableRow extends Model
{
    protected $table = 'statistic_table_rows';

    protected $fillable = [
        'table_id',
        'row_label',
        'row_order',
        'data',
    ];

    protected $casts = [
        'data' => 'array', 
    ];

    public function table()
    {
        return $this->belongsTo(
            StatisticTable::class,
            'table_id'
        );
    }
}
