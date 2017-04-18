<?php

$db_host = "localhost"; // The IP address of your MySQL database.
$db_user = "root"; // The user of the database.
$db_password = ""; // The password of the user.
$db_name = "warnings"; // The name of the MySQL Database.
$db_table = "warnings"; // The table of the database (Default = warnings).

$connect_initial = mysql_connect($db_host, $db_user, $db_password);
$connect = mysql_select_db($db_name, $connect_initial);

?>
