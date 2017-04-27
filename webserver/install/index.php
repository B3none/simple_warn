<?php
include('../includes/config.php');

if($connect === true)
{
	$creation_query = 'CREATE TABLE IF NOT EXISTS `'.$db_name.'`.`'.$db_table.'`
	(
		`warningid` INT NOT NULL AUTO_INCREMENT ,
		`warningtype` TEXT NOT NULL ,
		`server` TEXT NOT NULL ,
		`date` DATE NOT NULL ,
		`client` TEXT NOT NULL ,
		`client_steamid` TEXT NOT NULL ,
		`reason` TEXT NOT NULL ,
		`admin` TEXT NOT NULL ,
		`admin_steamid` TEXT NOT NULL ,
		PRIMARY KEY (`warningid`)
	);';

	if(mysqli_query($creation_query) === true)
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
