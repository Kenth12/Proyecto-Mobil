<?php



require_once "conexion.php";
$sql = "SELECT * FROM T_PRODUCTOS";
$st  = $con->prepare($sql);
$st->execute();
$rst = $st->fetchAll(PDO::FETCH_ASSOC);
echo json_encode($rst);