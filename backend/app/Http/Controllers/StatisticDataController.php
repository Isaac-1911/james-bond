<?php

namespace App\Http\Controllers;

use App\Helpers\ApiResponse;
use App\Models\StatisticData;
use Illuminate\Http\Request;

class StatisticDataController extends Controller
{
    /**
     * GET /api/statistics
     */
    /**
 * GET /api/statistics
 * Support filter by year (?year=2024)
 */
public function index(Request $request)
{
    $query = StatisticData::with('category')
        ->orderBy('period', 'desc');

    // 🔥 FILTER PER TAHUN (AllStat-style)
    if ($request->has('year')) {
        $year = $request->query('year');
        $query->where('period', 'like', $year . '%');
    }

    $data = $query->get();

    return ApiResponse::success(
        $data,
        'Statistic data list'
    );
}


    /**
     * POST /api/statistics
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'category_id' => 'nullable|integer|exists:categories,category_id',
            'title'       => 'nullable|string|max:200',
            'description' => 'nullable|string',
            'value'       => 'nullable|numeric',
            'unit'        => 'nullable|string|max:25',
            'period'      => 'nullable|string|max:25'
        ]);

        $stat = StatisticData::create($validated);

        return ApiResponse::success(
            $stat,
            'Statistic data created',
            201
        );
    }

    /**
     * GET /api/statistics/{id}
     */
    public function show(string $id)
    {
        $stat = StatisticData::with('category')->findOrFail($id);

        return ApiResponse::success(
            $stat,
            'Statistic data detail'
        );
    }

    /**
     * PUT /api/statistics/{id}
     */
    public function update(Request $request, string $id)
    {
        $stat = StatisticData::findOrFail($id);

        $validated = $request->validate([
            'category_id' => 'nullable|integer|exists:categories,category_id',
            'title'       => 'sometimes|required|string|max:200',
            'description' => 'nullable|string',
            'value'       => 'sometimes|required|numeric',
            'unit'        => 'nullable|string|max:50',
            'period'      => 'nullable|string|max:100'
        ]);

        $stat->update($validated);

        return ApiResponse::success(
            $stat,
            'Statistic data updated'
        );
    }

    /**
     * DELETE /api/statistics/{id}
     */
    public function destroy(string $id)
    {
        $stat = StatisticData::findOrFail($id);
        $stat->delete();

        return ApiResponse::success(
            null,
            'Statistic data deleted'
        );
    }

    /**
     * 🔥 BONUS — GET /api/statistics/chart
     * Endpoint khusus Flutter chart
     */
    public function chart(Request $request)
    {
        $request->validate([
            'category_id' => 'required|integer|exists:categories,category_id'
        ]);

        $data = StatisticData::where('category_id', $request->category_id)
            ->orderBy('period')
            ->get(['period', 'value', 'unit', 'title']);

        return ApiResponse::success(
            $data,
            'Statistic chart data'
        );
    }
}
