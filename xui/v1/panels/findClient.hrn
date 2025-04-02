<?php

require_once "api.php";
$v2m = new V2rayManager();
$panelUsername = $_POST["username"];
$PanelPassword = $_POST["password"];
$inbound = $_POST["inbound"];
$email = $_POST["email"];
$serverUrl = $_POST["serverUrl"];
echo $v2m->findClientByEmailInRow($panelUsername, $PanelPassword, $inbound, $email, $serverUrl);
