<?php

namespace App\Http\Controllers;

use App\Helpers\ApiResponse;
use App\Models\Publication;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class PublicationController extends Controller
{
    /**
     * GET /api/publication
     */
    public function index()
    {
        $data = Publication::orderBy('release_date', 'desc')->get();

        return ApiResponse::success(
            $data,
            'Publication list'
        );
    }

    /**
     * POST /api/publication
     */
    public function store(Request $request)
    {
        $request->validate([
            'title'                => 'required|string|max:25',
            'release_date'         => 'nullable|date',
            'summary'              => 'nullable|string',
            'publication_category' => 'required|integer',
            'pdf'                  => 'required|file|mimes:pdf|max:20000'
        ]);

        // simpan PATH saja
        $path = $request->file('pdf')->store('publications', 'public');

        $publication = Publication::create([
            'title'                => $request->title,
            'release_date'         => $request->release_date,
            'summary'              => $request->summary,
            'publication_category' => $request->publication_category,
            'file_url'             => $path
        ]);

        return ApiResponse::success(
            $publication,
            'Publication created',
            201
        );
    }

    /**
     * GET /api/publication/{id}
     */
    public function show(string $id)
    {
        $publication = Publication::findOrFail($id);

        return ApiResponse::success(
            $publication,
            'Publication detail'
        );
    }

    /**
     * PUT /api/publication/{id}
     */
    public function update(Request $request, string $id)
    {
        $publication = Publication::findOrFail($id);

        $request->validate([
            'title'                => 'nullable|string|max:25',
            'release_date'         => 'nullable|date',
            'summary'              => 'nullable|string',
            'publication_category' => 'nullable|integer',
            'pdf'                  => 'sometimes|file|mimes:pdf|max:20000'
        ]);

        if ($request->hasFile('pdf')) {
            // ambil PATH asli dari DB
            $oldPath = $publication->getRawOriginal('file_url');

            if ($oldPath && Storage::disk('public')->exists($oldPath)) {
                Storage::disk('public')->delete($oldPath);
            }

            $newPath = $request->file('pdf')->store('publications', 'public');
            $publication->file_url = $newPath;
        }

        if ($request->title !== null) {
            $publication->title = $request->title;
        }

        if ($request->release_date !== null) {
            $publication->release_date = $request->release_date;
        }

        if ($request->summary !== null) {
            $publication->summary = $request->summary;
        }

        if ($request->publication_category !== null) {
            $publication->publication_category = $request->publication_category;
        }

        $publication->save();

        return ApiResponse::success(
            $publication,
            'Publication updated'
        );
    }

    /**
     * DELETE /api/publication/{id}
     */
    public function destroy(string $id)
    {
        $publication = Publication::findOrFail($id);

        $path = $publication->getRawOriginal('file_url');

        if ($path && Storage::disk('public')->exists($path)) {
            Storage::disk('public')->delete($path);
        }

        $publication->delete();

        return ApiResponse::success(
            null,
            'Publication deleted'
        );
    }



public function download(Publication $publication)
{
    $path = $publication->getRawOriginal('file_url');

    if (!$path || !Storage::disk('public')->exists($path)) {
        return ApiResponse::error(
            'File not found',
            null,
            404
        );
    }

    return response()->download(
        storage_path('app/public/' . $path)
    );
}



}
