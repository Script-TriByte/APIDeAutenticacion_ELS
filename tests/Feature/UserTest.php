<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;
use Illuminate\Support\Facades\Artisan;
use Laravel\Passport\Client;
use Illuminate\Support\Facades\Http;

class UserTest extends TestCase
{
    public function test_ObtenerTokenConClientIdValido()
    {
        Artisan::call('passport:client',[
            '--password' => true,
            '--no-interaction'=>true,
            '--name'=>'Test Client',
        ]);        
            
        $client = Client::findOrFail(1);

        $response = $this->post('/oauth/token',[
            "username" => "usuario@placeholder.com",
            "password" => "1234",
            "grant_type" => "password",
            "client_id" => "1",
            "client_secret" => $client->secret
        ]);

        $response->assertStatus(200);
        $response->assertJsonStructure([
            "token_type",
            "expires_in",
            "access_token",
            "refresh_token"
        ]);

        $response->assertJsonFragment([
            "token_type" => "Bearer"
        ]);

    }

    public function test_ObtenerTokenConClientIdInvalido()
    {
        $response = $this->post('/oauth/token',[
            "grant_type" => "password",
            "client_id" => "12345",
            "client_secret" => "clientInvalido"
        ]);
        $response->assertStatus(401);
        $response->assertJsonFragment([
            "error" => "invalid_client",
            "error_description" => "Client authentication failed",
            "message" => "Client authentication failed"
        ]);
    }

    public function test_ValidarTokenSinEnviarToken()
    {
        $response = $this->get('/api/v2/validar');

        $response->assertStatus(500);
    }

    public function test_ValidarTokenConTokenInvalido()
    {
        $response = $this->get('/api/v2/validar', [
            [ "Authorization" => "Token Invalido"]
        ]);

        $response->assertStatus(500);
    }

    public function test_ValidarTokenConTokenValido()
    {
        $client = Client::findOrFail(1);
        $tokenResponse = $this -> post("/oauth/token",[
            "username" => "usuario@placeholder.com",
            "password" => "1234",
            "grant_type" => "password",
            "client_id" => "1",
            "client_secret" => $client -> secret
        ]);

        $token = json_decode($tokenResponse->content(), true);
        
        $response = $this->get('/api/v2/validar',
            [ "Authorization" => "Bearer " . $token ['access_token']]
        );

        $response->assertStatus(200); 
    }

    public function test_LogoutSinToken()
    {
        $response = $this->get('/api/v2/logout');

        $response->assertStatus(500);
    }

    public function test_LogoutConTokenInvalido()
    {
        $response = $this->get('/api/v2/logout', [
            [ "Authorization" => "Token Invalido" ]
        ]);

        $response->assertStatus(500);
    }

    public function test_LogoutConTokenValido()
    {
        $client = Client::findOrFail(1);
        $tokenResponse = $this->post("/oauth/token", [
            "username" => "usuario@placeholder.com",
            "password" => "1234",
            "grant_type" => "password",
            "client_id" => "1",
            "client_secret" => $client->secret
        ]);

        $token = json_decode($tokenResponse->content(), true);
        
        $response = $this->get('/api/v2/logout',
            [ "Authorization" => "Bearer " . $token ['access_token']]
        );

        $response->assertStatus(200);
        $response->assertJsonFragment(
            ['message' => 'Token Revoked']
        );
    }
}