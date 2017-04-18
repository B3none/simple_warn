<html>
    <head>
        <style>
        table, th, td {
            border: 1px solid black;
            border-collapse: collapse;
        }
        th, td {
            padding: 5px;
            text-align: left;    
        }
        </style>
    </head>
<body>

<?php
/*
* Code by B3none -> http://steamcommunity.com/profiles/76561198028510846
*/

include('includes/config.php');
echo"<title>$page_title</title>";

$order_query = "SELECT * FROM `$db_table` ORDER BY `date`";
$connect_and_order = mysql_query($order_query, $connect);

echo "
<table id='warnings'>
    <tr>
        <th>Warning ID</th>
        <th>Warning Type</th>
        <th>Server</th>
        <th>Client</th>
        <th>Admin</th>
        <th>Date</th>
    </tr>
</td>";

$id = 0;
while($row = mysql_fetch_array($connect_and_order))
{
    $id++;
    
    if()
    {
        
    }
}

mysql_close($connect_and_order);
?>
