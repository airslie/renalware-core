<h1>All Fruits<h1>

<p>
<?php
$link = mysqli_connect("localhost","lat","","cuke_php_test") or die("Error " . mysqli_error($link));
$query = "SELECT * FROM fruits" or die("Error in the consult.." . mysqli_error($link));
$result = $link->query($query);

while($row = mysqli_fetch_array($result)) {
  echo $row["name"] . "<br>";
}
?>
<p>