<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\News;
use App\Models\Infographic;
use App\Models\Publication;
use App\Models\SearchHistory;

class SearchWebController extends Controller
{
    public function index(Request $request)
    {
        $q = $request->q;

        SearchHistory::create([
            'keyword' => $q
        ]);

        $news = News::where('title', 'like', "%$q%")
            ->orWhere('summary', 'like', "%$q%")
            ->get();

        $infographics = Infographic::where('title', 'like', "%$q%")
            ->orWhere('description', 'like', "%$q%")
            ->get();

        $publications = Publication::where('title', 'like', "%$q%")
            ->get();

        return view('search.index', compact(
            'q',
            'news',
            'infographics',
            'publications'
        ));
    }
}
