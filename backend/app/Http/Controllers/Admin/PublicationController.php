<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Publication;
use Illuminate\Support\Facades\Storage;

class PublicationController extends Controller
{
    public function index()
    {
        $publications = Publication::latest()->get();
        return view('admin.publications.index', compact('publications'));
    }

    public function create()
    {
        return view('admin.publications.create');
    }

    public function store(Request $request)
    {
        $request->validate([
            'title'        => 'required|max:255',
            'release_date' => 'nullable|date',
            'summary'      => 'nullable',
            'description'  => 'nullable',
            'catalog_number'     => 'nullable',
            'publication_number' => 'nullable|string|max:255',
            'isbn'                => 'nullable|string|max:255',
            'cover'        => 'nullable|image|mimes:jpg,jpeg,png|max:10240',
            'pdf'          => 'required|mimes:pdf|max:20480',
        ]);

        // cover
        $coverPath = null;
        if ($request->hasFile('cover')) {
            $coverPath = $request->file('cover')->store('covers', 'public_direct');
        }

        // pdf
        $pdfPath = $request->file('pdf')->store('publications', 'public_direct');

        Publication::create([
            'title'              => $request->title,
            'release_date'       => $request->release_date,
            'summary'            => $request->summary,
            'description'        => $request->description,
            'catalog_number'     => $request->catalog_number,
            'publication_number' => $request->publication_number,
            'isbn'               => $request->isbn,
            'cover_url'          => $coverPath,
            'file_url'           => $pdfPath,
        ]);

        return redirect('/admin/publications')
            ->with('success', 'Publikasi berhasil ditambahkan');
    }

    public function destroy($id)
    {
        $publication = Publication::findOrFail($id);

        if ($publication->cover_url) {
            Storage::disk('public')->delete(
                str_replace(asset('storage/') . '/', '', $publication->cover_url)
            );
        }

        if ($publication->file_url) {
            Storage::disk('public')->delete(
                str_replace(asset('storage/') . '/', '', $publication->file_url)
            );
        }

        $publication->delete();

        return back()->with('success', 'Publikasi berhasil dihapus');
    }
}
