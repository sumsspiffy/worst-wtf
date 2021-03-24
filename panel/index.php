<?php 
	
    // include the config for class access
    require_once($_SERVER['DOCUMENT_ROOT']."/core/config.php");

    // auto redirect if sessions currently active & users blacklisted
    if($Local::IsBlacklisted()) { $Local::Redirect("blacklisted"); }

    // auto redirect if sessions currently active
    if($Local::IsActive()) { header("Location: dashboard"); } 

    include("authorize.php"); // the html & css

?>