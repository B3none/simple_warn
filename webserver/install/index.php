<?php
include('includes/config.php');

if($connect === true)
{
	$creation_query = 'CREATE TABLE IF NOT EXISTS `warnings`.`warnings` ( `warningid` INT NOT NULL AUTO_INCREMENT , `warningtype` TEXT NOT NULL , `server` TEXT NOT NULL , `date` TEXT NOT NULL , `client` TEXT NOT NULL , `reason` TEXT NOT NULL , `admin` TEXT NOT NULL , PRIMARY KEY (`warningid`))';
	if(mysql_query($creation_query) == true)
	{
		echo'<h1>Sweet!</h1>
		<br>
		<p>Your table creation was successfull!</p>
		<br>
		<p>Simply delete the "install" directory to progress (<b><u>This is for security reasons!</b></u>)</p>';
	}
}
else
{
	echo '<h1>FAILURE<h1>
	<br>
	<p><b>SQL Connection failed</b>: please check your settings in "includes/config.php" and try again!</p>';
}

?>
