<?php


require_once "conexion.php";
if(isset($_POST["nombre"]) && isset($_POST["precio"]) && isset($_POST["descripcion"]) && isset($_POST["id"])){

	$nombre  = $_POST["nombre"];
	$des     = $_POST["descripcion"];
	$precio  = $_POST["precio"];
	$id      = $_POST["id"];

	$sql = "UPDATE T_PRODUCTOS SET
	        PRO_NOMBRE = ?, PRO_PRECIO = ? , PRO_DESCRIPCION = ?
	        WHERE PRO_ID = ?";

	$st  		= $con->prepare($sql);
	$valores 	= array($nombre, $precio, $des, $id);
	$rst        = $st->execute($valores);
	if( $rst > 0){
		echo json_encode(array("mensaje"=>"Se actualizo un producto"));
	}else{
		echo json_encode(array("mensaje"=>"Error al actualizar"));
	}
}else{
	$pNombre = isset($_POST["nombre"]) 		? "": "[nombre]";
	$pPrecio = isset($_POST["precio"]) 		? "": "[precio]";
	$pDes    = isset($_POST["descripcion"]) ? "": "[descripcion]";
	$pid     = isset($_POST["id"]) 			? "": "[id]";
	echo json_encode(array("mensaje"=>"Faltan los parametros $pNombre $pPrecio $pDes $pid en la peticion"));
}