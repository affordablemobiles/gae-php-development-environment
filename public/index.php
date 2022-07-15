<?php

namespace GcrDevStartup;

$_SERVER['DOCUMENT_ROOT'] = $_SERVER['GCR_DEV_RELATIVE_PATH'];

$hostPart = explode(".", str_replace("-dot-", ".", $_SERVER['HTTP_HOST']));

if (strpos($hostPart[0], "dev-") === 0) {
    $user = substr($hostPart[0], 4);
    $_SERVER['DOCUMENT_ROOT'] = '/tmp/www/' . $user . '/' . $_SERVER['GCR_DEV_RELATIVE_PATH'];
    $path = $_SERVER['DOCUMENT_ROOT'] . '/public/index.php';

    if (is_file($path)) {
        require $path;
        exit();
    }
}


http_response_code(404);
?>
<pre>Development Environment Not Found!</pre>
