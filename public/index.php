<?php

if (strpos($_SERVER['REQUEST_URI'], '/_gae-development-env/healthz') === 0){
    http_response_code(425);
    die('STARTUP');
}

?><pre>Development Environment Failed, try re-loading.</pre>