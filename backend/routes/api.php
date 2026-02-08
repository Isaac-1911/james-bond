<?php

use App\Http\Controllers\ActivityNewsController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\StatisticDataController;
use App\Http\Controllers\NewsController;
use App\Http\Controllers\PublicationController;
use App\Http\Controllers\InfographicController;
use App\Http\Controllers\SearchHistoryController;
use App\Http\Controllers\Api\StatisticTableController;
use App\Http\Controllers\Api\StatisticSubjectController;
use App\Http\Controllers\Api\StatisticSubsubjectController;
use App\Http\Controllers\ChatController;
use App\Http\Controllers\FeedbackController;
use App\Http\Controllers\ReleasePlanController;
use App\Models\Infographic;
use App\Models\StatisticTable;


/*
|--------------------------------------------------------------------------
| PUBLIC API (TANPA LOGIN)
|--------------------------------------------------------------------------
*/

// Category
Route::get('/category', [CategoryController::class, 'index']);
Route::get('/category/{id}', [CategoryController::class, 'show']);

// Infographic
Route::get('/infographic', [InfographicController::class, 'index']);
Route::get('/infographic/{id}', [InfographicController::class, 'show']);

// News
Route::get('/news', [NewsController::class, 'index']);
Route::get('/news/{id}', [NewsController::class, 'show']);

// Publications
Route::get('/publication/{publication}/download', [PublicationController::class, 'download']);
Route::get('/publication', [PublicationController::class, 'index']);
Route::get('/publication/{id}', [PublicationController::class, 'show']);


Route::get('/dashboard/summary', function () {
    return response()->json([
        'status' => 'success',
        'data' => [
            'news_count' => \App\Models\News::count(),
            'publication_count' => \App\Models\Publication::count(),
            'statistic_count' => \App\Models\StatisticTable::count(),
            'last_update' => now()->toDateString(),
        ]
    ]);
});

Route::get('/search', function (Illuminate\Http\Request $request) {
    $q = $request->query('q');

    return response()->json([
        'status' => 'success',
        'data' => [
            'news' => \App\Models\News::where('title', 'like', "%$q%")->get(),

            'publications' => \App\Models\Publication::where('title', 'like', "%$q%")->get(),

            'statistics' => StatisticTable::with([
                'subsubject:id,name,subject_id',
                'subsubject.subject:id,name'
            ])
                ->where('title', 'like', "%$q%")
                ->get()
                ->map(function ($table) {
                    return [
                        'id' => $table->id,
                        'title' => $table->title,
                        'subject_name' => $table->subsubject->subject->name ?? null,
                        'subsubject_name' => $table->subsubject->name ?? null,
                    ];
                }),

            'infographics' => Infographic::where('title', 'like', "%$q%")->get(),
        ]
    ]);
});


Route::prefix('/statistic')->group(function () {
    Route::get('/subjects', [StatisticSubjectController::class, 'index']);
    Route::get('/subsubjects/{subject}', [StatisticSubsubjectController::class, 'index']);
    Route::get('/tables/{subsubject}', [StatisticTableController::class, 'index']);
    Route::get('/table/{table}', [StatisticTableController::class, 'show']);
});


Route::get('/statistic/table/{id}', [StatisticTableController::class, 'show']);
Route::get('/statistic/tables', [StatisticTableController::class, 'indexAll']);

Route::get('/release-plans', [ReleasePlanController::class, 'index']);
Route::get('/release-plans/{id}', [ReleasePlanController::class, 'show']);

Route::get('/activity-news', [ActivityNewsController::class, 'index']);
Route::get('/activity-news/{id}', [ActivityNewsController::class, 'show']);

Route::post('/feedback', [FeedbackController::class, 'store']);

Route::post('/chat', [ChatController::class, 'chat']);

/*
|--------------------------------------------------------------------------
| ADMIN API (HARUS LOGIN SANCTUM)
|--------------------------------------------------------------------------
*/

Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum', 'is_admin')->group(function () {

    // Category
    Route::post('/category', [CategoryController::class, 'store']);
    Route::put('/category/{id}', [CategoryController::class, 'update']);
    Route::delete('/category/{id}', [CategoryController::class, 'destroy']);

    // Infographic
    Route::post('/infographic', [InfographicController::class, 'store']);
    Route::put('/infographic/{id}', [InfographicController::class, 'update']);
    Route::delete('/infographic/{id}', [InfographicController::class, 'destroy']);

    // News
    Route::post('/news', [NewsController::class, 'store']);
    Route::put('/news/{id}', [NewsController::class, 'update']);
    Route::delete('/news/{id}', [NewsController::class, 'destroy']);

    // Publications
    Route::post('/publication', [PublicationController::class, 'store']);
    Route::put('/publication/{id}', [PublicationController::class, 'update']);
    Route::delete('/publication/{id}', [PublicationController::class, 'destroy']);

    // Statistics
    Route::post('/statistics', [StatisticDataController::class, 'store']);
    Route::put('/statistics/{id}', [StatisticDataController::class, 'update']);
    Route::delete('/statistics/{id}', [StatisticDataController::class, 'destroy']);

    // Activity News
    Route::post('/activity-news', [ActivityNewsController::class, 'store']);
    Route::put('/activity-news/{id}', [ActivityNewsController::class, 'update']);
    Route::delete('activity-news/{id}', [ActivityNewsController::class, 'destroy']);

    // Release Plans
    Route::post('/release-plans', [ReleasePlanController::class, 'store']);
    Route::put('/release-plans/{id}', [ReleasePlanController::class, 'update']);
    Route::delete('/release-plans/{id}', [ReleasePlanController::class, 'destroy']);

    // Search History (Opsional)
    Route::get('/search-history', [SearchHistoryController::class, 'index']);
    Route::post('/search-history', [SearchHistoryController::class, 'store']);
    Route::delete('/search-history/{id}', [SearchHistoryController::class, 'destroy']);
});
