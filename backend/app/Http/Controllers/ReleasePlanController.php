<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\ReleasePlan;

class ReleasePlanController extends Controller
{
    public function index()
    {
        return response()->json([
            'status' => 'success',
            'data' => ReleasePlan::orderBy('planned_date')->get()->map(function ($item) {
                return [
                    'id' => $item->id,
                    'title' => $item->title,
                    'type' => $item->type,
                    'planned_date' => $item->planned_date->format('Y-m-d'),
                    'released_date' => $item->released_date
                        ? $item->released_date->format('Y-m-d')
                        : null,
                    'target_id' => $item->target_id
                ];
            }),
        ]);
    }
}
