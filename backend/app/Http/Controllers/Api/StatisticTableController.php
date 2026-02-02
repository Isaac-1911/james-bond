<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\StatisticTable;

class StatisticTableController extends Controller
{
    // list tabel dalam subsubject
    public function index(int $subsubjectId)
    {
        return response()->json([
            'status' => 'success',
            'data' => StatisticTable::where('subsubject_id', $subsubjectId)
                ->select('id', 'title', 'last_updated')
                ->orderByDesc('last_updated')
                ->get()
        ]);
    }

    // detail tabel (kolom + baris)
    public function show(int $tableId)
    {
        $table = StatisticTable::with(['columns', 'rows'])
            ->findOrFail($tableId);

        return response()->json([
            'status' => 'success',
            'data' => [
                'id' => $table->id,
                'title' => $table->title,
                'description' => $table->description,
                'last_updated' => optional($table->last_updated)->toDateString(),
                'source' => $table->source,
                'columns' => $table->columns->map(fn ($col) => [
                    'key' => $col->key_name,
                    'label' => $col->label,
                    'unit' => $col->unit,
                ]),
                'rows' => $table->rows->map(fn ($row) => [
                    'label' => $row->row_label,
                    'data' => $row->data,
                ]),
            ]
        ]);
    }

    public function indexAll()
{
    $tables = StatisticTable::with([
        'subsubject:id,subject_id,name',
        'subsubject.subject:id,name'
    ])->get();

    return response()->json([
        'status' => 'success',
        'data' => $tables->map(function ($table) {
            return [
                'id' => $table->id,
                'title' => $table->title,
                'subsubject_id' => $table->subsubject_id,
                'subsubject_name' => $table->subsubject->name ?? null,
                'subject_id' => $table->subsubject->subject->id ?? null,
                'subject_name' => $table->subsubject->subject->name ?? null,
            ];
        }),
    ]);
}

}
