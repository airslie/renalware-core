<?php
  $host = "localhost";
  $dbuser = 'renalware';
  $pass = 'password';
  $usedb = $_ENV['PHP_ENV'] == "test" ? 'renalware_test' : 'renalware';
  $mysqli = new mysqli($host, $dbuser, $pass, $usedb);
?>