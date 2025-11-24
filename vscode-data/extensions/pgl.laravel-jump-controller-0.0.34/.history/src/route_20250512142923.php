<?php

Route::apiResource('users.info', 'UserController');
Router::get('/bar', 'FooController::bar');
Route::get(
    '/user/profile',
    [UserProfileController::class, 'show']
)->name('profile');
Route::any('rebuildCache', '\\V1_1\\Api\\Personal\\Company@checkCompany');
Route::name('api_SCMFreight.')->resource('statement/SCMFreight/index', V1_1\Api\Statement\SCMFreight::class);
Route::post('payment/apply/repeal', [App\Http\Controllers\Api\Payment\PaymentController::class, 'repeal'])->middleware('VerifyVip');
Route::match(['get', 'put'], '/', ['Home\\Index', 'index'])->withoutMiddleWare();
Route::apiResource('users.info', 'UserController');
Route::any('/', 'Home\Index@index')->withoutMiddleware(VerifyCsrfToken::class);
Route::any(
    '/',
    [Home\Index::class, 'index']
)->withoutMiddleware(VerifyCsrfToken::class);
Route::apiResource('users/{1}/info', 'UserController');
