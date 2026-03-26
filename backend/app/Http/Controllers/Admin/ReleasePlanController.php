<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\ReleasePlan;
use Illuminate\Http\Request;

class ReleasePlanController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $releasePlan = ReleasePlan::all();
        return view('admin.release_plan.index', compact('releasePlan'));

    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('admin.release_plan.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
