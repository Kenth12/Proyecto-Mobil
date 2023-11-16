<?php


require_once "conexion.php";
if(isset($_POST["id"]) ){

	$id  = $_POST["id"];
	 
	$sql = "DELETE FROM T_PRODUCTOS WHERE PRO_ID = ? ";

	$st  		= $con->prepare($sql);
	$valores 	= array($id);
	$rst        = $st->execute($valores);
	if( $rst > 0){
		echo json_encode(array("mensaje"=>"Se elimino un producto"));
	}else{
		echo json_encode(array("mensaje"=>"Error al eliminar"));
	}
}else{
	$pID = isset($_POST["id"]) ? "": "[id]";
	echo json_encode(array("mensaje"=>"Falta el parametro $pID en la peticion"));
}