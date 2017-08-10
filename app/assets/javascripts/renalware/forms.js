// On forms with more than one submit button, apply the disable-with label to
// only the clicked button, and just disable the other buttons.
// See for instance the HD Session form.
$(document).on('click', '.form-with-multiple-submit-buttons :submit', function () {
    var buttons = $('.form-with-multiple-submit-buttons :submit').not($(this));
    buttons.removeAttr('data-disable-with');
    buttons.attr('disabled', true);
});

function initDatePicker(container, elem, pickerOptions) {
  $(container + ' ' + elem).fdatepicker(pickerOptions);

  $(container + ' ' + elem + '-wrapper .prefix i').on('click', function() {
    $(this).closest(elem + '-wrapper')
      .find(elem)
      .fdatepicker('show');
  });
}

function initDatepickersIn(container) {
  initDatePicker(container, '.datepicker', {format: "dd-M-yyyy"});
}

function initDateTimepickersIn(container) {
  initDatePicker(container, '.datetimepicker', {
    format: "dd-M-yyyy hh:ii", pickTime: true, minuteStep: 1
  });
}

function initClockpickersIn(container) {
  var elem = ".clockpicker";
  var pickerOptions = {
    placement: "right", align: "left", donetext: "Set", autoclose: "true"
  };

  $(container + ' ' + elem).clockpicker(pickerOptions);

  // Clicking on the clock icon should display the clocpicker
  $(container + ' ' + elem + '-wrapper .input-group-addon').on('click', function() {
    $(this).closest(elem + '-wrapper').find(elem).clockpicker("show");
  });
}

$(function() {
  initDatepickersIn("body");
  initDateTimepickersIn("body");
  initClockpickersIn("body");
});
