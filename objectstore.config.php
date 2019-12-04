<?php
$CONFIG = array (
  'objectstore' => array(
        'class' => '\\OC\\Files\\ObjectStore\\Swift',
        'arguments' => array(
                'username' => 'FIXME',
                'password' => 'FIXME',
                // the container to store the data in
                'bucket' => 'Nextcloud_Files',
                'autocreate' => false,
                'region' => 'GRA7',
                // The Identity / Keystone endpoint
                'url' => 'https://auth.cloud.ovh.net/v2.0',
                // optional on some swift implementations
                'tenantName' => 'FIXME',
                'serviceName' => 'swift',
        ),
  ),
);
