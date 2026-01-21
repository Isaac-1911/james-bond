<?php

namespace App\Http\Controllers;

use App\Helpers\ApiResponse;
use App\Models\Infographic;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class InfographicController extends Controller
{
    /**
     * GET /api/infographic
     */
    public function index()
    {
        $data = Infographic::all();

        return ApiResponse::success(
            $data,
            'Infographic list'
        );
    }

    /**
     * POST /api/infographic
     */
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'nullable|string',
            'description' => 'nullable|string',
            'image' => 'required|image|max:12000'
        ]);

        // simpan PATH saja
        $path = $request->file('image')->store('infographics', 'public');

        $infographic = Infographic::create([
            'title' => $request->title,
            'description' => $request->description,
            'image_url' => $path
        ]);

        return ApiResponse::success(
            $infographic,
            'Infographic created',
            201
        );
    }

    /**
     * GET /api/infographic/{id}
     */
    public function show(string $id)
    {
        $infographic = Infographic::findOrFail($id);

        return ApiResponse::success(
            $infographic,
            'Infographic detail'
        );
    }

    /**
     * PUT /api/infographic/{id}
     */
    public function update(Request $request, string $id)
    {
        $infographic = Infographic::findOrFail($id);

        $request->validate([
            'title' => 'nullable|string',
            'description' => 'nullable|string',
            'image' => 'sometimes|image|max:4096'
        ]);

        if ($request->hasFile('image')) {
            // ambil PATH asli dari DB (bukan hasil accessor)
            $oldPath = $infographic->getRawOriginal('image_url');

            if ($oldPath && Storage::disk('public')->exists($oldPath)) {
                Storage::disk('public')->delete($oldPath);
            }

            $newPath = $request->file('image')->store('infographics', 'public');
            $infographic->image_url = $newPath;
        }

        if ($request->title !== null) {
            $infographic->title = $request->title;
        }

        if ($request->description !== null) {
            $infographic->description = $request->description;
        }

        $infographic->save();

        return ApiResponse::success(
            $infographic,
            'Infographic updated'
        );
    }

    /**
     * DELETE /api/infographic/{id}
     */
    public function destroy(string $id)
    {
        $infographic = Infographic::findOrFail($id);

        // hapus file pakai PATH asli
        $path = $infographic->getRawOriginal('image_url');

        if ($path && Storage::disk('public')->exists($path)) {
            Storage::disk('public')->delete($path);
        }

        $infographic->delete();

        return ApiResponse::success(
            null,
            'Infographic deleted'
        );
    }
}
