$(function() {
  if ($('small.error').length > 0) {
    $('html, body').animate({
      scrollTop: ($('small.error').first().offset().top-100)
    },500);
  }

  $('.datepicker').fdatepicker({
    format: "dd/mm/yyyy"
  });

  $('.datepicker-wrapper i').on('click', function() {
    $(this).closest('.datepicker-wrapper').find('.datepicker').fdatepicker('show');
  })
});