// let text = `Route::any('rebuildCache', '\\App\\Services\\Model\\Company\\Department@rebuildCache');`;
// let text = `Route::any('rebuildCache', '\\V1_1\\Api\\Personal\\Company@checkCompany');`;
// let text = `Route::name('api_SCMFreight.')->resource('statement/SCMFreight/index', V1_1\\Api\\Statement\\SCMFreight::class);`;
// let text = `Route::post('payment/apply/repeal', [App\\Http\\Controllers\\Api\\Payment\\PaymentController::class, 'repeal'])->middleware('VerifyVip');`;
// let text = `Route::match(['get', 'put'], '/', ['Home\\Index', 'index'])->withoutMiddleWare();`;
// let text = `Route::apiResource('users', 'UserController');`;

let composerAutoLoadPSR = {
  "App\\": "app/",
  "think\\": "tools/think-orm",
};

// turn the match method preg to a usual string
if (text.indexOf("match(") !== -1) {
  //rewrite string
  text = text.replace(/match\(\s?\[(['"][a-zA-Z]+['"],?\s?)+\],/, "match(");
}

// match controller and method
let splitted = text.split(",").splice(1);

if (splitted.length == 1) {
  // match string @
  if (splitted[0].indexOf("@") > -1) {
    splitted = splitted[0].replace(/['"\s\);]/g, "").split("@");
  } else if (splitted[0].indexOf("::class") > -1) {
    // match string ::class
    splitted = splitted[0].replace(/['"\s\);]/g, "").split("::class");
    splitted[1] = "index";
  } else {
    // match resource mod
    splitted[0] = splitted[0].replace(/['"\s\);]/g, "");
    splitted[1] = "index";
  }
} else if (splitted.length == 2) {
  // match controller and method
  splitted[0] = splitted[0].replace(/[\['"\s]/g, "").replace("::class", "");
  splitted[1] = splitted[1].replace(/['"\s\]\);]/g, "");
}

// console.log(splitted);

let pathCtrl = "/app/Http/Controllers/";

let pathNamespace = "App\\Http\\Controllers";

let controllerFileName = splitted[0] + ".php";

// replace the http controllers namespace to empty string
if (controllerFileName.indexOf(pathNamespace) === 0) {
  controllerFileName = controllerFileName.slice(
    (pathNamespace + "\\").replace(/\\\\/g, "\\").length
  );
}

if (controllerFileName.charAt(0) === "\\") {
  for (_i in composerAutoLoadPSR) {
    if (controllerFileName.indexOf("\\" + _i) === 0) {
      controllerFileName = controllerFileName.slice(
        _i.length + 1 /** include the leading backslash */
      );
      controllerFileName =
        (composerAutoLoadPSR[_i] + "/").replace(/\/\//g, "/") +
        controllerFileName;
      break;
    }
  }
} else {
  controllerFileName =
    (pathCtrl + "/").replace(/\/\//g, "/") + controllerFileName;
}

controllerFileName = controllerFileName.replace(/\\/g, "/");

console.log(controllerFileName);
