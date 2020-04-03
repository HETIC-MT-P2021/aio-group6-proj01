
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

// $sql = $conn->prepare("SELECT messages from logs_table");
// $sql->execute();

// echo "<br> <br>" . "Logs:" . "<br> <br>";

// while($row = $sql->fetch()) {
//         echo $row['messages'] . "<br>";
//     }

$conn = null;    
?>