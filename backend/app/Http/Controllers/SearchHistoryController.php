<?php

namespace App\Http\Controllers;

use App\Helpers\ApiResponse;
use App\Models\SearchHistory;
use Illuminate\Http\Request;

class SearchHistoryController extends Controller
{
    /**
     * GET /api/search-history
     */
    public function index()
    {
        $data = SearchHistory::with('user')
            ->orderBy('search_id', 'desc')
            ->get();

        return ApiResponse::success(
            $data,
            'Search history list'
        );
    }

    /**
     * POST /api/search-history
     */
    public function store(Request $request)
    {
        $request->validate([
            'keyword' => 'required|string|max:100'
        ]);

        $history = SearchHistory::create([
            'user_id' => auth()->id(), // null kalau tidak login
            'keyword' => $request->keyword
        ]);

        return ApiResponse::success(
            $history,
            'Search history created',
            201
        );
    }

    /**
     * DELETE /api/search-history/{id}
     */
    public function destroy(string $id)
    {
        $history = SearchHistory::findOrFail($id);
        $history->delete();

        return ApiResponse::success(
            null,
            'Search history deleted'
        );
    }
}
