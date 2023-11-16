<?php
$user     = "root";
$password = "";
$server   = "mysql:host=localhost;dbname=app_end_point";

$con     = new PDO($server, $user, $password);
$con->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// echo sha1('%&LostPwfsdfasd');