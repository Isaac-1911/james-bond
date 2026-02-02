<?php

namespace App\Http\Controllers;

use App\Models\StatisticSubject;
use App\Models\StatisticSubsubject;
use App\Models\StatisticTable;
use Illuminate\Http\JsonResponse;

class StatisticController extends Controller
{
    /**
     * GET /api/statistic/subjects
     */
    public function subjects(): JsonResponse
    {
        return response()->json([
            'status' => 'success',
            'data' => StatisticSubject::select('id', 'name')->get()
        ]);
    }

    /**
     * GET /api/statistic/subsubjects/{subject_id}
     */
    public function subsubjects(int $subjectId): JsonResponse
    {
        return response()->json([
            'status' => 'success',
            'data' => StatisticSubsubject::where('subject_id', $subjectId)
                ->select('id', 'name')
                ->get()
        ]);
    }

    /**
     * 🔄 REFACTOR
     * GET /api/statistic/indicators/{subsubject_id}
     * SEKARANG = LIST TABEL STATISTIK
     */
    public function indicators(int $subsubjectId): JsonResponse
    {
        return response()->json([
            'status' => 'success',
            'data' => StatisticTable::where('subsubject_id', $subsubjectId)
                ->select('id', 'title', 'last_updated')
                ->orderByDesc('last_updated')
                ->get()
        ]);
    }

    /**
     * 🔄 REFACTOR
     * GET /api/statistic/data/{table_id}
     * SEKARANG = DETAIL TABEL (columns + rows)
     */
    public function data(int $tableId): JsonResponse
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
}
