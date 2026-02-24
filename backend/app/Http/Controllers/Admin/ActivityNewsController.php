<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\ActivityNews;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ActivityNewsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $activityNews = ActivityNews::latest()->get();
        return view('admin.activity_news.index', compact('activityNews'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('admin.activity_news.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|max:150',
            'summary' => 'required',
            'image' => 'required',
            'pdf' => 'required|mimes:pdf|max:20000',
            'release_date' => 'required|date',
        ]);

        $pdfPath = $request->file('pdf')->store('activity_news', 'public_direct');

        $imagePath = null;
        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')->store('activity_news', 'public_direct');
        }

        ActivityNews::create([
            'title' => $request->title,
            'summary' => $request->summary,
            'image_url' => $imagePath,
            'file_url' => $pdfPath,
            'release_date' => $request->release_date
        ]);

        return redirect('/admin/activity-news')->with('succes', 'Activity news berhasil ditambahkan');
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $activityNews = ActivityNews::findOrFail($id);

        if ($activityNews->image_url) {
            Storage::disk('public')->delete(
                str_replace(asset('storage/') . '/', '', $activityNews->image_url)
            );
        }

        if ($activityNews->file_url){
            Storage::disk('public')->delete(
                str_replace(asset('storage/') . '/', '', $activityNews->file_url)
            );
        }

        $activityNews->delete();

        return back()->with('success', 'Activity News berhasil dihapus');
    }
}
