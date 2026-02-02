<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StatisticTable extends Model
{
    protected $table = 'statistic_tables';

    protected $fillable = [
        'subsubject_id',
        'title',
        'description',
        'last_updated',
        'source',
    ];

    protected $casts = [
        'last_updated' => 'date',
    ];

    public function subsubject()
    {
        return $this->belongsTo(
            StatisticSubsubject::class,
            'subsubject_id'
        );
    }

    public function columns()
    {
        return $this->hasMany(
            StatisticTableColumn::class,
            'table_id'
        )->orderBy('order_index');
    }

    public function rows()
    {
        return $this->hasMany(
            StatisticTableRow::class,
            'table_id'
        )->orderBy('row_order');
    }

}
