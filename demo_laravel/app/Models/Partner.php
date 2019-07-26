<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Partner extends Model
{
    use SoftDeletes;

    public $prefix = 'products';

    protected $fillable = [
        'id',
        'name',
        'points',
        'image',
    ];

    protected $dates = ['deleted_at'];


}
