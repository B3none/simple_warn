<?php
include('includes/config.php');

if($connect === true)
{
	$creation_query = '
	SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
	SET time_zone = "+00:00";

	CREATE TABLE `warnings` (
	  `warningid` int(11) NOT NULL,
	  `warningtype` text NOT NULL,
	  `server` text NOT NULL,
	  `date` text NOT NULL,
	  `client` text NOT NULL,
	  `client_steamid` text NOT NULL,
	  `reason` text NOT NULL,
	  `admin` text NOT NULL,
	  `admin_steamid` text NOT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;

	ALTER TABLE `warnings` ADD PRIMARY KEY (`warningid`);
	  
	ALTER TABLE `warnings` MODIFY `warningid` int(11) NOT NULL AUTO_INCREMENT;';
	
	if(mysql_query($creation_query) == true)
	{
		echo'<h1>Sweet!</h1>
		<br>
		<p>Your table creation was successfull!</p>
		<br>
		<p>Simply delete the "install" directory to progress (<b><u>This is for security reasons!</b></u>)</p>
		';
	}
	
	else
	{
		echo'<h1>FAILURE</h1>
		<br>
		<p>The SQL query has failed.</p>';
	}
}
else
{
	echo '<h1>FAILURE<h1>
	<br>
	<p><b>SQL Connection failed</b>: please check your settings in "includes/config.php" and try again!</p>';
}

?>
