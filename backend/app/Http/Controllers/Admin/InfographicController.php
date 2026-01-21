<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Infographic;

class InfographicController extends Controller
{
    public function index()
    {
        $infographics = Infographic::latest()->get();
        return view('admin.infographics.index', compact('infographics'));
    }

    public function create()
    {
        return view('admin.infographics.create');
    }

    public function store(Request $request)
    {
        $request->validate([
            'title'       => 'required|max:100',
            'description' => 'required',
            'image'       => 'required|image|mimes:jpg,jpeg,png|max:10240',
        ]);

        // upload image
        $imagePath = $request->file('image')->store('infographics', 'public');

        Infographic::create([
            'title'       => $request->title,
            'description' => $request->description,
            'image_url'   => $imagePath,
        ]);

        return redirect('/admin/infographics')->with('success', 'Infografis berhasil ditambahkan');
    }

    public function destroy($id)
    {
        Infographic::findOrFail($id)->delete();
        return back()->with('success', 'Infografis berhasil dihapus');
    }
}
