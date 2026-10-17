<?php
// TAAE GUI configuration file.
global $DB;

$DB['TYPE']     = 'POSTGRESQL';
$DB['SERVER']   = 'taae-db';
$DB['PORT']     = '5432';
$DB['DATABASE'] = 'taae';
$DB['USER']     = 'taae';
$DB['PASSWORD'] = 'taae_password';

// Schema name. Used for PostgreSQL.
$DB['SCHEMA'] = '';

$ZBX_SERVER      = 'taae-server';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = 'TAAE monitoring tizimi';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
