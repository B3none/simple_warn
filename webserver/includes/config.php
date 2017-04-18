<?php

$db_host = ""; // The IP address of your MySQL database.
$db_user = ""; // The user of the database.
$db_password = ""; // The password of the user.
$db = "warnings"; // The name of the database (Default = warnings).
$db_table = "warnings"; // The table of the database.

$connect_initial = mysql_connect($db_host, $db_user, $db_password);
$connect = mysql_select_db($db_table, $connect_initial);

?>
