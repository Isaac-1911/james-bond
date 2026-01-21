<?php

namespace App\Http\Controllers\Web;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Http;
use App\Models\News;

class NewsWebController extends Controller
{
    public function index() {
        $news = News::orderBy('created_at', 'desc')->paginate(6);

        return view('news.index', compact('news'));
    }

    public function show($id){
        $news = News::findOrFail($id);
        $latestNews = News::latest()->take(5)->get();

        return view('news.show', compact('news'));
    }
}
