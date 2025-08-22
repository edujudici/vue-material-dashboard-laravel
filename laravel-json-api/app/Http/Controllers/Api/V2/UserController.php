<?php

namespace App\Http\Controllers\Api\V2;

use App\Models\User;
use LaravelJsonApi\Laravel\Http\Controllers\JsonApiController;

class UserController extends JsonApiController
{
    protected string $model = User::class;

    protected function creating($model, $request)
    {
        $this->hashPassword($model, $request);
    }

    protected function updating($model, $request)
    {
        $this->hashPassword($model, $request);
    }

    protected function hashPassword($model, $request)
    {
        if ($request->has('password')) {
            $model->password = bcrypt($request->input('password'));
        }
    }
}
