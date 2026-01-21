<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AuthController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\StatisticDataController;
use App\Http\Controllers\NewsController;
use App\Http\Controllers\PublicationController;
use App\Http\Controllers\InfographicController;
use App\Http\Controllers\SearchHistoryController;

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


// Statistic Data
Route::get('/statistics', [StatisticDataController::class, 'index']);
Route::get('/statistics/{id}', [StatisticDataController::class, 'show']);
Route::get('/statistics/chart', [StatisticDataController::class, 'chart']);



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

    // Search History (Opsional)
    Route::get('/search-history', [SearchHistoryController::class, 'index']);
    Route::post('/search-history', [SearchHistoryController::class, 'store']);
    Route::delete('/search-history/{id}', [SearchHistoryController::class, 'destroy']);
});
