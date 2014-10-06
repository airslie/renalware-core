<script type="text/javascript">
$(function(){
	$pagetitle= location.pathname;
	if(!$page) {
		$pagetitle= 'index.html';
	}
	$('ul.navigation li a').each(function(){
		var $href = $(this).attr('href');
		if ( ($href == $page) || ($href == '') ) {
			$(this).addClass('on');
		} else {
			$(this).removeClass('on');
		}
	});
});
</script>