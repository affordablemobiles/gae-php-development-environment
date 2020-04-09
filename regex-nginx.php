<?php

$cfgfile = '/tmp/google-config/nginx.conf';

$nginxcfg = file_get_contents($cfgfile);

$nginxcfg = preg_replace('/root([\s]+)\/srv/', 'root$1/tmp/srv', $nginxcfg);

$healthcheck = file_get_contents('nginx-health-check.conf');

$additional_rewrite = file_get_contents('nginx-additional-rewrites.conf');

$nginxcfg = str_replace('rewrite', $healthcheck . "\n" . $additional_rewrite . "\nrewrite", $nginxcfg);

file_put_contents($cfgfile, $nginxcfg);