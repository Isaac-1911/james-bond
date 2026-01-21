<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\News;

class NewsController extends Controller
{
    public function index()
    {
        $news = News::latest()->get();
        return view('admin.news.index', compact('news'));
    }

    public function create()
    {
        return view('admin.news.create');
    }

    public function store(Request $request)
    {
        $request->validate([
            'title'        => 'required|max:100',
            'release_date' => 'required|date',
            'summary'      => 'required',
        ]);

        // upload image
        $imagePath = null;
        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')->store('news', 'public');
        }

        News::create([
            'title'        => $request->title,
            'release_date' => $request->release_date,
            'summary'      => $request->summary,
            'image_url'    => $imagePath,
        ]);

        return redirect('/admin/news')->with('success', 'News berhasil ditambahkan');
    }

    public function destroy($id)
    {
        News::findOrFail($id)->delete();
        return back()->with('success', 'News berhasil dihapus');
    }
}
