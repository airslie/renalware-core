<?php
$displaytime = date("D j M Y  G:i:s");
$fields = "ix_id, ixstamp, ixname, obxblock";
$tables = "hl7data.pathol_ixdata";
$where = "WHERE ixpid='$hospno1'"; // default
$orderby = "ORDER BY ixdate DESC"; //incl ORDER BY prn
//get total num
$sql= "SELECT ix_id FROM $tables $where";
$result = $mysqli->query($sql);
$numtotal = $result->num_rows;
$sql= "SELECT $fields FROM $tables $where $orderby LIMIT $portallimit";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"header\">There are no investigations! </p>";
	}
else
	{
	echo "<p class=\"header\">$numtotal investigations ($numrows most recent displayed).</p>
	<ul class=\"portal\">";
	while ($row = $result->fetch_assoc()) {
		$ix_id=$row["ix_id"];
		$ixname=$row["ixname"];
		$obxblockdata=explode("\r",$row["obxblock"]);
		$datarows="";
		foreach ($obxblockdata as $key => $value) {
			$obxrowarray=explode("|",$value);
			$stflag=$obxrowarray[2];
			$obxtype=str_replace('^Lab_PathNET',"",$obxrowarray[3]);
			$obxresult=$obxrowarray[5];
			$obxflag=$obxrowarray[8];
			$class = ($obxflag) ? $obxflag : "N" ;
			if ($stflag=="ST") {
				$datarows.= "<tr class=\"$class\">
				<td>$obxtype</td>
				<td>$obxresult</td>
				<td>$obxflag</td>
				</tr>";
			}
		}
		
		$datatable ="<table>$datarows</table>";
		$showhide = "<i><a class=\"tg\" onclick=\"toggl('pix$ix_id');\">toggle</a></i>";
		echo '<li>' . $row["ixstamp"] . "&nbsp;&nbsp;<b>$ixname</b> $showhide</li>";
		echo "<li id=\"pix$ix_id\" style=\"display:none;padding:5px;margin-left:35px;font-size: 10px;\">$datatable</li>";
		}
	echo "</ul>";
	}
?>