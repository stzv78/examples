<?php

namespace App\Http\Controllers\Auth;

use App\User;
use App\Models\City;
use App\Http\Controllers\Controller;
use App\Models\Traits\ApiResponseTrait;
use Laravel\Socialite\Facades\Socialite;
use Exception;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Facades\JWTAuth;

class SocialController extends Controller
{
    use ApiResponseTrait;

    /**
     * Redirect to provider for authentication
     *
     * @param $driver
     * @return \Illuminate\Http\RedirectResponse
     */
    public function redirectToProvider($driver)
    {
        if(! (config()->has("services.{$driver}" ))){
            return redirect()->to(action('ApiController@error', ['error' => "Драйвер {$driver} не поддерживается"]));
        }

        try {
            return Socialite::driver($driver)->redirect();
        } catch (Exception $e){
                return redirect()->to(action('ApiController@error', ['error' => "Ошибка входа"]));
        }
    }

    /**
     * Login social user
     *
     * @param string $driver
     * @return \Illuminate\Http\RedirectResponse
     */
    public function handleProviderCallback($provider)
    {
        try {
            $socialUser = Socialite::driver($provider)->stateless()->user();
        } catch (Exception $e) {
            //return $this->sendFailedResponse($e->getMessage());
            return redirect()->to(action('ApiController@error', ['error' => $e->getMessage()]));
        }

        return $this->login($socialUser, $provider);
    }

    /**
     * @param User $user
     * @return \Illuminate\Http\RedirectResponse
     */
    public function login($user, $provider)
    {
        $authUser = User::where(['social_id' => $user->id, 'social_driver' => $provider])->first();

        if ($authUser) {
            $authUser->update([
                'name' => $user->name,
                'avatar' => $user->avatar,
                'social_id' => $user->id,
            ]);
        } else {
            $authUser = User::create([
                'name' => $user->name,
                'avatar' => $user->avatar,
                'social_driver' => $provider,
                'social_id' => $user->id,
            ]);
        }

        try {
            $token = JWTAuth::fromUser($authUser);

        } catch (JWTException $e) {
            //return $this->sendFailedResponse('Could not create token', 500);
            return redirect()->to(action('ApiController@error', ['error' => $e->getMessage()]));
        }

        return redirect()->to(action('ApiController@success', $this->returnAccessData($token, $authUser)));
    }

    /**
     * Get the token array structure.
     *
     * @param  string $token
     *
     * @return \Illuminate\Http\JsonResponse
     */
    protected function returnAccessData($token, $user)
    {
        $data = [
            'magnitapp_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => auth('api')->factory()->getTTL()*10,
            'name' => $user->name,
            'avatar' => $user->avatar,
            'level' => $user->level,
            'points' => $user->points,
            'pointsToNextLevel' => $user->getPointsToNextLevel(),
        ];

        return $data;
    }


    /**
     * @return \Illuminate\Http\RedirectResponse
     */
    public function logout()
    {
        auth('api')->logout();
        return $this->sendSuccessResponse("Successfully logged out", 200);
    }
}