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
	$page = $_GET['page'];

	if(empty($page))
	{
		header("Location: /index.php?page=1");
	}

	else
	{
		$one = 1 + (($page - 1) * 20);
		$one_one = $one + 20;

		$two = 20;

		$order_query = "SELECT * FROM `$db_table` ORDER BY `date` DESC LIMIT $one, $two";

		$connect_and_order = mysqli_query($connect, $order_query);
		$total_items = mysqli_num_rows($connect_and_order);

		if($total_items >= 1)
		{
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

			$id = $one - 1;

			while($row = mysqli_fetch_array($connect_and_order))
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

			$tpq = "SELECT * FROM `warnings`";
			$tpq_done = mysqli_query($connect, $tpq);
			$total_pages = (mysqli_num_rows($tpq_done)) / 20;


			for($i = 1; $i <= $total_pages + 1; $i++)
			{
				echo "<a href='/index.php?page=$i'>$i</a> ";
			}
			echo "<br><p align='center'>Showing results $one to $one_one. (Page $page)</p>";
			mysqli_close($connect);
		}

		else
		{
			echo "No results found!";
		}
	}
	?>
    </body

    <footer>
		<p align='center'>Coded by <a href='http://steamcommunity.com/profiles/76561198028510846'>B3none</a>.</p>
    </footer>
</html>
