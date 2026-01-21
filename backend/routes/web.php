<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Web\HomeController;
use App\Http\Controllers\Web\InfographicWebController;
use App\Http\Controllers\Web\NewsWebController;
use App\Http\Controllers\Web\PublicationWebController;
use App\Http\Controllers\Web\SearchWebController;

use App\Http\Controllers\Admin\AuthController;
use App\Http\Controllers\Admin\PublicationController as AdminPublicationController;
use App\Http\Controllers\Admin\NewsController as AdminNewsController;
use App\Http\Controllers\Admin\InfographicController as AdminInfographicController;
use App\Http\Controllers\Admin\StatisticController as AdminStatisticController;
use App\Http\Controllers\StatisticDataController;
use App\Http\Controllers\Web\StatisticWebController;

/*
|--------------------------------------------------------------------------
| PUBLIC WEB
|--------------------------------------------------------------------------
*/

Route::get('/', [HomeController::class, 'index']);

Route::get('/news', [NewsWebController::class, 'index']);
Route::get('/news/{id}', [NewsWebController::class, 'show']);

Route::get('/infographics', [InfographicWebController::class, 'index']);
Route::get('/infographics/{id}', [InfographicWebController::class, 'show']);

Route::get('/publications', [PublicationWebController::class, 'index']);
Route::get('/publications/{id}', [PublicationWebController::class, 'show']);

Route::get('/search', [SearchWebController::class, 'index']);

Route::get('/statistics' ,[StatisticWebController::class, 'index']);

/*
|--------------------------------------------------------------------------
| ADMIN AUTH
|--------------------------------------------------------------------------
*/

Route::get('/admin/login', [AuthController::class, 'showLogin'])->name('admin.login');
Route::post('/admin/login', [AuthController::class, 'login']);
Route::post('/admin/logout', [AuthController::class, 'logout']);

/*
|--------------------------------------------------------------------------
| ADMIN PANEL (PROTECTED)
|--------------------------------------------------------------------------
*/

Route::prefix('admin')
    ->middleware('admin')
    ->group(function () {

        Route::get('/', fn () => view('admin.dashboard'));
        Route::get('/dashboard', fn () => view('admin.dashboard'));

        Route::resource('publications', AdminPublicationController::class)
            ->except(['show', 'edit', 'update']);

        Route::resource('news', AdminNewsController::class)
            ->except(['show', 'edit', 'update']);

        Route::resource('infographics', AdminInfographicController::class)
            ->except(['show', 'edit', 'update']);

        Route::resource('statistics', AdminStatisticController::class)
            ->except(['show', 'edit', 'update']);
    });
