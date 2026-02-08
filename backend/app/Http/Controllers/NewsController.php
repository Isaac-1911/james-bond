<?php

namespace App\Http\Controllers;

use App\Helpers\ApiResponse;
use App\Models\News;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class NewsController extends Controller
{
    /**
     * GET /api/news
     */
    public function index()
    {
        $data = News::all();

        return ApiResponse::success(
            $data,
            'News list'
        );
    }

    /**
     * POST /api/news
     */
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string',
            'release_date' => 'required|date',
            'summary' => 'nullable|string',
            'image' => 'required|image|max:20000'
        ]);

        // simpan PATH saja
        $path = $request->file('image')->store('news', 'public');

        $news = News::create([
            'title' => $request->title,
            'release_date' => $request->release_date,
            'summary' => $request->summary,
            'image_url' => $path
        ]);

        return ApiResponse::success(
            $news,
            'News created',
            201
        );
    }

    /**
     * GET /api/news/{id}
     */
    public function show(string $id)
    {
        $news = News::findOrFail($id);

        return ApiResponse::success(
            $news,
            'News detail'
        );
    }

    /**
     * PUT /api/news/{id}
     */
    public function update(Request $request, string $id)
    {
        $news = News::findOrFail($id);

        $request->validate([
            'title' => 'required|string',
            'release_date' => 'nullable|date',
            'summary' => 'nullable|string',
            'image' => 'sometimes|image|max:12000'
        ]);

        if ($request->hasFile('image')) {
            // ambil PATH asli dari DB
            $oldPath = $news->getRawOriginal('image_url');

            if ($oldPath && Storage::disk('public')->exists($oldPath)) {
                Storage::disk('public')->delete($oldPath);
            }

            $newPath = $request->file('image')->store('news', 'public');
            $news->image_url = $newPath;
        }

        if ($request->title !== null) {
            $news->title = $request->title;
        }

        if ($request->release_date !== null) {
            $news->release_date = $request->release_date;
        }

        if ($request->summary !== null) {
            $news->summary = $request->summary;
        }

        $news->save();

        return ApiResponse::success(
            $news,
            'News updated'
        );
    }

    /**
     * DELETE /api/news/{id}
     */
    public function destroy(string $id)
    {
        $news = News::findOrFail($id);

        // hapus file pakai PATH asli
        $path = $news->getRawOriginal('image_url');

        if ($path && Storage::disk('public')->exists($path)) {
            Storage::disk('public')->delete($path);
        }

        $news->delete();

        return ApiResponse::success(
            null,
            'News deleted'
        );
    }
}
