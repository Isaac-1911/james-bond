<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Category;
use App\Helpers\ApiResponse;

class CategoryController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return ApiResponse::success(
            Category::all(),
            'Category list'
        );
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'description' => 'nullable'
        ]);

        $category = Category::create($request->all());

        return ApiResponse::success(
            $category,
            'Category created!',
            201
        );
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $category = Category::findOrFail($id);

        return ApiResponse::success(
            $category,
            'Category detail'
        );
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $category = Category::findOrFail($id);

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:100',
            'description' => 'nullable|string'
        ]);

        $category->update($request->all());

        // return response()->json([
        //     'status' => 'success',
        //     'data' => $category
        // ]);

        return ApiResponse::success(
            $category,
            'Category Updated'
        );
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $category = Category::findOrFail($id);
        $category->delete();

        return ApiResponse::success(
            null,
            'Resource Deleted!'
        );
    }
}
