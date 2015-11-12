function initDatePicker(container, elem, pickerOptions) {
  $(container + ' ' + elem).fdatepicker(pickerOptions);

  $(container + ' ' + elem + '-wrapper .prefix i').on('click', function() {
    $(this).closest(elem + '-wrapper')
      .find(elem)
      .fdatepicker('show');
  });
}

function initDatepickersIn(container) {
  initDatePicker(container, '.datepicker', {format: "dd-mm-yyyy"});
}

function initDateTimepickersIn(container) {
  initDatePicker(container, '.datetimepicker', {format: "dd-mm-yyyy hh:ii", pickTime: true});
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
