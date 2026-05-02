<?php
header('Content-Type: application/json');

$profil = [
    'name' => 'Raifanka Raisa Ramadhan',
    'nim' => '2311102205',
    'almet' => 'Telyu'
];

echo json_encode($profil);
?>
