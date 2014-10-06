<?php
//Tue Dec 11 16:36:57 CET 2007
	$passgo=FALSE;
	$uid=$_POST['uid'];
	$pw1=$mysqli->real_escape_string($_POST['password1']);
	$pw2=$mysqli->real_escape_string($_POST['password2']);
	$pw1=trim($pw1);
	$pw2=trim($pw2);
	//ensure they match
	if ($pw1 == $pw2)
		{
			//validate per rules
			//requires numeric char
			if (eregi("^[[:alnum:]]{6,20}$", $pw1) and ereg("[[:digit:]]",$pw1))
				{
				$passgo=TRUE;
				}
			else
				{
				$passgo = FALSE;
				echo "<p class=\"alert\">Please enter a valid password (6 to 20 characters with at least one digit)!</p>";
				}
		}
	else
		{
			$passgo = FALSE;
			echo '<p class="alert">The two passwords did not match!</p>';
		}
	//handle valid pw
	if ($passgo)
		{
		$sql= "UPDATE userdata SET pass=PASSWORD('$pw1'), passmodifstamp=NOW(),newpwflag='0' WHERE uid=$uid";
		$result = $mysqli->query($sql);
			//log the event
			$eventtype='password changed';
			include "$rwarepath/run/logevent.php";
		$runmsgtxt="Thank you. Your password has been changed.";
		$_SESSION['runmsg']=$runmsgtxt;
		header("Location: $rwareroot/user/userhome.php");
		}
	else
		{ // Failed the validation test.
		echo '<p class="alert">Please try again.</p>';
		}
?>