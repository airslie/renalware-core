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
  initDatePicker(container, '.datetimepicker', {
    format: "dd-mm-yyyy hh:ii", pickTime: true, minuteStep: 1
  });
}

function initClockpickersIn(container) {
  var elem = ".clockpicker";
  var pickerOptions = {
    placement: "right", align: "left", donetext: "Set", autoclose: "true"
  };

  $(container + ' ' + elem).clockpicker(pickerOptions);

  $(container + ' ' + elem + '-wrapper .prefix i').on('click', function() {
    // FIXME: does not work, although the picker is found.
    $(this).closest(elem + '-wrapper')
      .find(elem)
      .clockpicker("show");
  });
}

$(function() {
  if ($('small.error').length > 0) {
    $('html, body').animate({
      scrollTop: ($('small.error').first().offset().top-100)
    },500);
  }

  initDatepickersIn("body");
  initDateTimepickersIn("body");
  initClockpickersIn("body");
});
