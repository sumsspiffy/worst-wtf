<?php 

// remove vars
unset($_SESSION['userkey']);
unset($_SESSION['active']);

header("Location: ../index.php");

?>