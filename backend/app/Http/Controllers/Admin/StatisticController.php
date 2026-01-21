<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\StatisticData;
use App\Models\Category;

class StatisticController extends Controller
{
    public function index()
    {
        $statistics = StatisticData::latest()->get();
        return view('admin.statistics.index', compact('statistics'));
    }

    public function create()
    {
        $categories = Category::all();
        return view('admin.statistics.create', compact('categories'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'category_id' => 'required|exists:categories,category_id',
            'title'       => 'nullable|max:100',
            'description' => 'nullable',
            'value'       => 'nullable|numeric',
            'unit'        => 'nullable|max:25',
            'period'      => 'nullable|max:25',
        ]);

        StatisticData::create([
            'category_id' => $request->category_id,
            'title'       => $request->title,
            'description' => $request->description,
            'value'       => $request->value,
            'unit'        => $request->unit,
            'period'      => $request->period,
        ]);

        return redirect('/admin/statistics')
            ->with('success', 'Data statistik berhasil ditambahkan');
    }

     public function destroy($id)
    {
        StatisticData::findOrFail($id)->delete();
        return back()->with('success', 'Data statistik berhasil dihapus');
    }
}
