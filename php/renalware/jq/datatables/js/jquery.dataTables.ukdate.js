jQuery.fn.dataTableExt.oSort['uk_date-asc']  = function(a,b) {
	var ukDatea = a.split('/');
	var ukDateb = b.split('/');
	
	var x = (ukDatea[2] + ukDatea[1] + ukDatea[0]) * 1;
	var y = (ukDateb[2] + ukDateb[1] + ukDateb[0]) * 1;
	
	return ((x < y) ? -1 : ((x > y) ?  1 : 0));
};

jQuery.fn.dataTableExt.oSort['uk_date-desc'] = function(a,b) {
	var ukDatea = a.split('/');
	var ukDateb = b.split('/');
	
	var x = (ukDatea[2] + ukDatea[1] + ukDatea[0]) * 1;
	var y = (ukDateb[2] + ukDateb[1] + ukDateb[0]) * 1;
	
	return ((x < y) ? 1 : ((x > y) ?  -1 : 0));
};
jQuery.fn.dataTableExt.aTypes.unshift(
	function ( sData )
	{
		if (sData.match(/^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[012])\/(|19|20|21)\d\d$/))
		{
			return 'uk_date';
		}
		return null;
	} 
);