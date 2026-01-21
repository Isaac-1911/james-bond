<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Publication;

class PublicationWebController extends Controller
{
    public function index() {
        $publications = Publication::latest()->paginate(9);

        return view('publications.index', compact('publications'));
    }

    public function show($id) {
        $publication = Publication::findOrFail($id);

        return view('publications.show', compact('publication'));
    }
}
