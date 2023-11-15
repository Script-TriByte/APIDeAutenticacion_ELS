<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UsuarioController;

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::prefix('v1')->group(function ()
{
    Route::get('/validate',[UsuarioController::class,"ValidateToken"])->middleware('auth:api');
    Route::get('/logout',[UsuarioController::class,"Logout"])->middleware('auth:api');


});

Route::prefix('v2')->middleware('auth:api')->group(function ()
{
    Route::get('/validar',
        [UsuarioController::class,"ValidarToken"]
    );

    Route::get('/logout',
        [UsuarioController::class,"Logout"]
    );
});
