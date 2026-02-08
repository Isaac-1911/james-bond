<?php

namespace App\Http\Controllers;

use App\Helpers\ApiResponse;
use App\Http\Controllers\Controller;
use App\Models\ReleasePlan;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;

class ReleasePlanController extends Controller
{
    public function index()
    {
        return response()->json([
            'status' => 'success',
            'data' => ReleasePlan::orderBy('planned_date')->get()->map(function ($item) {
                return [
                    'id' => $item->id,
                    'title' => $item->title,
                    'type' => $item->type,
                    'planned_date' => $item->planned_date->format('Y-m-d'),
                    'released_date' => $item->released_date
                        ? $item->released_date->format('Y-m-d')
                        : null,
                    'target_id' => $item->target_id
                ];
            }),
        ]);
    }

    public function store(Request $request){

        $request->validate([
            'title' => 'required|string',
            'type' => 'required',
            'planned_date' => 'required|date',
            'released_date' => 'date',
        ]);

        $release_plan = ReleasePlan::create([
            'title' => $request->title,
            'type' => $request->type,
            'planned_date' => $request->planned_date,
            'released_date' => $request->released_date,
            'target_id' => $request->target_id
        ]);

        return ApiResponse::success(
            $release_plan,
            'Release Plan Created',
            201
        );
    }

    public function show(string $id){
        $release_plan = ReleasePlan::findOrFail($id);

        return ApiResponse::success(
            $release_plan,
            'Success!'
        );
    }

    public function update(Request $request, string $id){
        $release_plan = ReleasePlan::findOrFail($id);

          $request->validate([
            'title' => 'required|string',
            'type' => 'required',
            'planned_date' => 'required|date',
            'released_date' => 'date',
        ]);

        if ($request->title !== null){
            $release_plan->title = $request->title;
        }

        if ($request->type !== null){
            $release_plan->type = $request->type;
        }

        if ($request->planned_date !== null){
            $release_plan->planned_date = $request->planned_date;
        }

        if ($request->released_date !== null){
            $release_plan->released_date = $request->released_date;
        }

        if ($request->target_id !== null){
            $release_plan->target_id = $request->target_id;
        }

        $release_plan->save();

        return ApiResponse::success(
            $release_plan,
            'Release Plan Updated!',
            201
        );

    }

    public function destroy(string $id){
        $release_plan = ReleasePlan::findOrFail($id);

        $release_plan->delete();

        return ApiResponse::success(
            null,
            'Release Plan Deleted!'
        );
    }
}
