<?php

namespace App\Http\Controllers\Api\v1;

use App\Models\City;
use App\Models\Recipe;
use App\Models\Traits\ApiResponseTrait;
use App\Models\Traits\GetChangesTrait;
use App\Models\Traits\GetQrTrait;
use App\Models\Traits\GetUser;
use App\User;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use App\Models\Comment;
use App\Models\Contact;


class UserController extends Controller
{
    use ApiResponseTrait, GetUser, GetQrTrait;

    protected function getModelByDataSource($dataSource)
    {
        $className = 'App\Models\\' . studly_case(str_singular($dataSource));
        $model = class_exists($className) ? new $className : null;
        return $model;
    }

    public function getUsersRating(Request $request, $number = 20)
    {
        $search = [
            'is_admin' => 0,
            'is_active' => 1,
            'is_blocked' => 0,
        ];
        if ($request->input('city_id')) {
            $search['city_id'] = $request->input('city_id');
        }
        if ($request->input('number')) {
            $number = $request->input('number');
        }
        $users = User::where($search)
            ->where('points', '>', 0)
            ->orderBy('points', 'desc')
            ->take($number)
            ->get(['id', 'name', 'avatar', 'city_id', 'points', 'level']);

        if (!is_null($users)) {
            return $this->sendSuccessResponse(['users' => $users], 200);
        } else return $this->sendFailedResponse('Пользователь не найден', 401.4);
    }

    public function profile()
    {
        $user = $this->getUser();
        $pointsToNextLevel = $user->getPointsToNextLevel();

        if ($user) {
            $table = DB::select('select * from (
                select r.id, r.published_at, "recipes" as model from recipes as r where r.is_published = 1 and r.user_id =' . $user->id . '
                union select l.id, l.published_at, "lifehacks" as model from lifehacks as l where l.is_published = 1 and l.user_id =' . $user->id . '
                ) as g ORDER BY published_at DESC');

            $posts = collect($table)->map(function ($item) use ($user) {
                $model = $this->getModelByDataSource($item->model)->find($item->id);
                $params['posts'] = true;
                $data = ($model instanceof Recipe) ? $this->recipesResponseWrapper($model, $params) : $this->lifehacksResponseWrapper($model, $params);
                $data->put('model', $item->model);
                return $data;
            }, $table);

            $city = City::find($user->city_id);

            $profile = compact('user', 'pointsToNextLevel', 'posts', 'city');
            return $this->sendSuccessResponse($profile, 200);
        }

        return $this->sendFailedResponse('Пользователь не найден', 401.4);
    }

    public function getComments($dataSource, $id)
    {
        $model = $this->getModelByDataSource($dataSource)->find(intval($id));
        $comments = $model->comments()->isApproved()->with('user:id,name,avatar')->get(['id', 'body','user_id','created_at']);
        if (! is_null($model))
            return $this->sendSuccessResponse($comments ?? [], 200);
        else return $this->sendFailedResponse('Ресурс не найден', 405);
    }

    public function complainComment($id)
    {
        $comment = Comment::find($id);
        if (!$comment->is_complained) {
            $comment->update([
                'is_complained' => 1,
            ]);
            return $this->sendSuccessResponse('Жалоба успешно отправлена администратору', 200);
        } else  return $this->sendFailedResponse("Комментарий не существует", 405);
    }

    
    public function getFavourite()
    {
        $user = $this->getUser();
        $favourites = $user->favourites()->latest()->get();
        if ($favourites) {
            $posts = $favourites->map(function ($item) use ($user) {
                $model = (new $item->favouriteable_type)->find($item->favouriteable_id);
                $params['posts'] = true;
                $data = ($model instanceof Recipe) ? $this->recipesResponseWrapper($model, $params) : $this->lifehacksResponseWrapper($model, $params);
                $data->put('model', $model->getTable());
                return $data;
            });
        }

        return $this->sendSuccessResponse($posts ?? [], 200);
    }
}
