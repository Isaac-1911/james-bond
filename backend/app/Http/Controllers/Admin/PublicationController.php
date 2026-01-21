<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Publication;

class PublicationController extends Controller
{
    /**
     * List semua publikasi
     */
    public function index()
    {
        $publications = Publication::latest()->get();
        return view('admin.publications.index', compact('publications'));
    }

    /**
     * Form tambah publikasi
     */
    public function create()
    {
        return view('admin.publications.create');
    }

    /**
     * Simpan publikasi baru
     */
    public function store(Request $request)
    {
        // ===============================
        // VALIDATION (NAMA FIELD BENAR)
        // ===============================
        $request->validate([
            'title'        => 'required|max:255',
            'release_date' => 'required|date',
            'summary'      => 'required',
            'cover'        => 'nullable|image|mimes:jpg,jpeg,png|max:10240',
            'pdf'          => 'required|mimes:pdf|max:20240',
        ]);

        // ===============================
        // UPLOAD COVER (OPSIONAL)
        // ===============================
        $coverPath = null;
        if ($request->hasFile('cover')) {
            $coverPath = $request->file('cover')->store('covers', 'public');
        }

        // ===============================
        // UPLOAD PDF (WAJIB)
        // ===============================
        $pdfPath = $request->file('pdf')->store('publications', 'public');

        // ===============================
        // SIMPAN KE DATABASE
        // ===============================
        Publication::create([
            'title'        => $request->title,
            'release_date' => $request->release_date,
            'summary'      => $request->summary,
            'cover_url'    => $coverPath, // ← path, bukan URL
            'file_url'     => $pdfPath,   // ← path, bukan URL
        ]);

        return redirect('/admin/publications')
            ->with('success', 'Publikasi berhasil ditambahkan');
    }

    /**
     * Hapus publikasi
     */
    public function destroy($id)
    {
        Publication::findOrFail($id)->delete();

        return back()->with('success', 'Publikasi berhasil dihapus');
    }
}
