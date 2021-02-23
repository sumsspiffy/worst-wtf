<?php 

// remove vars
session_start();
unset($_SESSION['userkey']);
unset($_SESSION['active']);

header("Location: ../index.php");

?>