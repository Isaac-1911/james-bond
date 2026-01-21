<?php
use Illuminate\Auth\AuthenticationException;

function unauthenticated($request, AuthenticationException $exception)
{
    return response()->json([
        'status' => 'error',
        'message' => 'Unauthenticated'
    ], 401);
}
