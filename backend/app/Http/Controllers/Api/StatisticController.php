<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\StatisticSubject;
use App\Models\StatisticSubsubject;
use App\Models\StatisticIndicator;
use App\Models\StatisticData;

class StatisticController extends Controller
{
    public function subjects() {
        return StatisticSubject::all();
    }

    public function subsubjects(StatisticSubject $subject) {
        return $subject->subsubjects;
    }

    public function indicators(StatisticSubsubject $subsubject) {
        return $subsubject->indicators;
    }

    public function data(StatisticIndicator $indicator) {
        return $indicator->data()->paginate(20);
    }
}
