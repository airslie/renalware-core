
$(document).on('ready ajaxSuccess', function(event, xhr, status) {
  $('.chosen-select').chosen({
      allow_single_deselect: true,
      no_results_text: 'No results matched',
      width: '400px'})
});
