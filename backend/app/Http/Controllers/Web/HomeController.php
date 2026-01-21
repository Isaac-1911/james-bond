<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\News;
use App\Models\Infographic;
use App\Models\StatisticData;
use App\Models\Publication;

class HomeController extends Controller
{
    public function index(){

        $latestNews = News::latest()->take(3)->get();

        return view('home', [
        'newsCount' => News::count(),
        'publicationCount' => Publication::count(),
        'statCount' => StatisticData::count(),
        'latestNews' => $latestNews
    ]);
    }

}
