<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\StatisticSubject;

class StatisticSubjectController extends Controller
{
    public function index()
    {
        return response()->json([
            'status' => 'success',
            'data' => StatisticSubject::select('id', 'name')->get()
        ]);
    }
}
