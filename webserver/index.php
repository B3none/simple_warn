<html>
    <head>
        <style>
        table, th, td 
		{
            border: 2px solid black;
            border-collapse: collapse;
        }
		
        th, td 
		{
            padding: 5px;
            text-align: left;    
        }
		
		th
		{
			background-color: #4CAF50;
			color: white;
		}
		
		tr:nth-child(even)
		{
			background-color: #D3D3D3;
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
	
	if(file_exists('install/index.php'))
	{
		echo "
		<h1>ERROR!</h1>
		<p>Please delete the install directory</p>";
	}
	
	else
	{
		$order_query = "SELECT * FROM `$db_table` ORDER BY `date` DESC";
		$connect_and_order = mysql_query($order_query, $connect);

		echo "
		<table id='warnings' align='center'>
			<tr>
				<th>Warning ID</th>
				<th>Warning Type</th>
				<th>Server</th>
				<th>Client</th>
				<th>Client Steam ID</th>
				<th>Admin</th>
				<th>Admin Steam ID</th>
				<th>Reason</th>
				<th>Date</th>
			</tr>
		</td>";

		$id = 0;
		while($row = mysql_fetch_array($connect_and_order))
		{
			$id++;
			
			$warningtype = $row['warningtype'];
			$server = $row['server'];
			$client = $row['client'];
			$admin = $row['admin'];
			$date = $row['date'];
			$reason = $row['reason'];
			$admin_steamid = $row ['admin_steamid'];
			$client_steamid = $row ['client_steamid'];
			
			echo"<tr>
				<td>$id</td>
				<td>$warningtype</td>
				<td>$server</td>
				<td>$client</td>
				<td>$client_steamid</td>
				<td>$admin</td>
				<td>$admin_steamid</td>
				<td>$reason</td>
				<td>$date</td>
			</tr>
			";
		}
		echo"</table>";

		mysql_close($connect);
	}
	?>
    </body
	
    <footer>
		<br>
		<p align='center'>Coded by <a href='http://steamcommunity.com/profiles/76561198028510846'>B3none</a>.</p>
    </footer>
</html>
