<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Lcobucci\JWT\Parser;

class UserController extends Controller
{
    public function ValidarToken(Request $request)
    {
        return auth('api')->user();
    }

    public function Logout(Request $request)
    {
        $request->user()->token()->revoke();

        return [ 'message' => 'Token Revoked' ];
    }   
}
