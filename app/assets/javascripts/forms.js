function initDatePicker(container, elem, pickerOptions) {
  $(container + ' ' + elem).fdatepicker(pickerOptions);

  $(container + ' ' + elem + ' i').on('click', function() {
    $(this).closest(elem + 'wrapper')
      .find(elem)
      .fdatepicker('show');
  });
}

function initDatepickersIn(container) {
  initDatePicker(container, '.datepicker', {format: "dd-mm-yy"});
}

function initDateTimepickersIn(container) {
  initDatePicker(container, '.datetimepicker', {format: "dd-mm-yy hh:ii", pickTime: true});
}

$(function() {
  if ($('small.error').length > 0) {
    $('html, body').animate({
      scrollTop: ($('small.error').first().offset().top-100)
    },500);
  }

  initDatepickersIn("body");
  initDateTimepickersIn("body");
});
