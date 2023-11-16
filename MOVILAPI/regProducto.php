<?php
header('Access-Control-Allow-Headers: access');
header('Access-Control-Allow-Origin: *');
$metodo = $_SERVER['REQUEST_METHOD'];
if ($metodo != "POST") {
	http_response_code(400);
	echo json_encode(array("mensaje"=>"Metodo incorrecto debe ser POST"));
	die();
}
// Token 
define('API_KEY', "e1f602bf73cc96f53c10bb7f7953a438fb7b3c0a");
$headers = apache_request_headers();
if(isset($headers["authorization"])){
	if($headers["authorization"] == 'e1f602bf73cc96f53c10bb7f7953a438fb7b3c0a'){
		require_once "conexion.php";
		if(isset($_POST["nombre"]) && isset($_POST["precio"]) && isset($_POST["descripcion"])){

			$nombre  = $_POST["nombre"];
			$des     = $_POST["descripcion"];
			$precio  = $_POST["precio"];
			if(empty(trim($nombre)) || empty(trim($precio)) || empty(trim($des)) ){
				echo json_encode(array("mensaje"=>"Todos los campos son obligatorios"));

			}else{
					$sql = "INSERT INTO T_PRODUCTOS
					        (PRO_NOMBRE, PRO_PRECIO, PRO_DESCRIPCION)
					        VALUES(? , ? , ? )";

					$st  		= $con->prepare($sql);
					$valores 	= array($nombre, $precio, $des);
					$rst        = $st->execute($valores);
					if( $rst > 0){
						echo json_encode(array("mensaje"=>"Se registro un producto"));
					}else{
						echo json_encode(array("mensaje"=>"Error al registrar"));
					}
			}
		}else{
			$pNombre = isset($_POST["nombre"]) ? "": "[nombre]";
			$pPrecio = isset($_POST["precio"]) ? "": "[precio]";
			$pDes    = isset($_POST["descripcion"]) ? "": "[descripcion]";
			echo json_encode(array("mensaje"=>"Faltan los parametros $pNombre $pPrecio $pDes en la peticion"));
		}
	}else{
		http_response_code(400);
		echo json_encode(array("mensaje"=>"API_KEY incorrecto"));
		die();
	}	
}else{
	http_response_code(400);
	echo json_encode(array("mensaje"=>"Falta el API_KEY"));
	die();
}

