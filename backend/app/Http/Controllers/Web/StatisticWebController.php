<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\StatisticData;
use App\Models\Category;
use Illuminate\Http\Request;

class StatisticWebController extends Controller
{
    public function index(Request $request)
    {
        $categories = Category::orderBy('name')->get();

        $query = StatisticData::with('category');

        if ($request->filled('category')) {
            $query->where('category_id', $request->category);
        }

        $statistics = $query->orderBy('period')->get();

        // data untuk chart
        $chartLabels = $statistics->pluck('period');
        $chartValues = $statistics->pluck('value');
        $chartTitle  = optional($statistics->first())->title;

        return view('statistics.index', compact(
            'categories',
            'statistics',
            'chartLabels',
            'chartValues',
            'chartTitle'
        ));
    }
}
