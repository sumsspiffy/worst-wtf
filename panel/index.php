<?php 

    require_once($_SERVER['DOCUMENT_ROOT']."/core/config.php");

    if($Local::IsBlacklisted()) { $Local::Redirect("blacklisted"); }

    // auto redirect
    if($Local::IsActive()) { header("Location: dashboard"); } 

    include("authorize.php"); // the html & css

?>