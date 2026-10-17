<?php
// TAA GUI configuration file.
global $DB;

$DB['TYPE']     = 'POSTGRESQL';
$DB['SERVER']   = 'taa-db';
$DB['PORT']     = '5432';
$DB['DATABASE'] = 'taa';
$DB['USER']     = 'taa';
$DB['PASSWORD'] = 'taa_password';

// Schema name. Used for PostgreSQL.
$DB['SCHEMA'] = '';

$ZBX_SERVER      = 'taa-server';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = 'TAA monitoring tizimi';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
