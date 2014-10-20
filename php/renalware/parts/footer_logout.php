<div id="footer">
	<p><?php echo ("<b>$user</b> logged out: " . Date("D d M Y H:i:s")); ?></font> after <?php echo $mins; ?> mins<br>
	Use of Renalware SQL indicated acceptance with the <a href="license.php" >Terms of Use.</a></p>
<?php
ob_end_flush();
?>
</div>
</body>
</html>