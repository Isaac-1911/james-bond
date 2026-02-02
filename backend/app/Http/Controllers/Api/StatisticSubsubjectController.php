<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\StatisticSubsubject;

class StatisticSubsubjectController extends Controller
{
    public function index(int $subjectId)
    {
        return response()->json([
            'status' => 'success',
            'data' => StatisticSubsubject::where('subject_id', $subjectId)
                ->select('id', 'name')
                ->get()
        ]);
    }
}
