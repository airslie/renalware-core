<html>
<head>
 <title>PHP Test</title>
</head>
<body>

<form action="hello_world.php" method="post">
  <p>Your name: <input type="text" name="name" /></p>
  <p>Your age: <input type="text" name="age" /></p>
  <p><input type="submit" value="Submit"/></p>
</form>

Hi <?php echo ($_POST['name']); ?>.
You are <?php echo (int)$_POST['age']; ?> years old.

<?php echo '<p>Hello World</p>';

?>
</body>
</html>