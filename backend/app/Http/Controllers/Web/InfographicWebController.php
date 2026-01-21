<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Infographic;

class InfographicWebController extends Controller
{
    public function index(){
        $infographics = Infographic::latest()->get();

        return view('infographics.index', compact('infographics'));
    }

    public function show($id){
        $infographic = Infographic::findOrFail($id);

        return view('infographics.show', compact('infographic'));

    }
}
