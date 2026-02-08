<?php

namespace App\Http\Controllers;

use App\Helpers\ApiResponse;
use App\Models\ActivityNews;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ActivityNewsController extends Controller
{
    public function index(){
        $data = ActivityNews::orderBy('created_at', 'desc')->get();

        return ApiResponse::success(
            $data,
            'Activity News List'
        );
    }

    public function store(Request $request){
        $request->validate([
            'title' => 'required|string',
            'release_date' => 'required|date',
            'summary' => 'nullable|string',
            'image_url' => 'nullable|string|max:20000'
        ]);

        $path = $request->file('image')->store('activity_news', 'public');

        $activity_news = ActivityNews::create([
            'title' => $request->title,
            'release_date' => $request->release_date,
            'summary' => $request->summary,
            'image_url' => $request->image_url
        ]);

        return ApiResponse::success(
            $activity_news,
            'Activity News Created!',
            201


        );
    }

    public function show(string $id){
        $activity_news = ActivityNews::findOrFail($id);

        return ApiResponse::success(
            $activity_news,
            'Success!'
        );
    }

    public function update(Request $request, string $id){

        $activity_news = ActivityNews::findOrFail($id);

        $request->validate([
            'title' => 'required|string',
            'release_date' => 'required|date',
            'summary' => 'nullable|string',
            'image_url' => 'nullable|string|max:20000'
        ]);

        if ($request->hasFile('image')){
            $oldPath = $activity_news->getRawOriginal('image_url');

            if ($oldPath && Storage::disk('public')->exists($oldPath)) {
                Storage::disk('public')->delete($oldPath);
            }

            $newPath = $request->file('image')->store('news', 'public');
            $activity_news->image_url = $newPath;
        }

        if ($request->title !== null) {
            $activity_news->title = $request->title;
        }

        if ($request->release_date !== null) {
            $activity_news->release_date = $request->release_date;
        }

        if ($request->summary !== null) {
            $activity_news->summary = $request->summary;
        }

        $activity_news->save();

        return ApiResponse::success(
            $activity_news,
            'News updated'
        );
    }

    public function destroy(string $id){
        $activity_news = ActivityNews::findOrFail($id);

        $path =$activity_news->getRawOriginal('image_url');

        if ($path && Storage::disk('public')->exists($path)){
            Storage::disk('public')->delete($path);
        }

        $activity_news->delete();

        return ApiResponse::success(
            null,
            'Activity News Deleted'
        );
    }
}
