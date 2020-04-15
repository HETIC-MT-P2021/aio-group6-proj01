
<?php 	

$servername = "mysqldb";
$username = "ig_project";
$password = "root";
$db = "ig_db_test";

try{
	$conn = new PDO("mysql:host=$servername;dbname=$db", $username, $password);

if ($conn){
	echo "Connected to server!";
	}
} catch (PDOException $e){
	echo $e->getMessage()."<br>";
	die();
}

$conn = null;    
?>