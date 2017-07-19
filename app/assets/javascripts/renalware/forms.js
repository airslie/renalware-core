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

function initSearchableSelects(container) {
  $(container + " .searchable_select").select2();
}


$(function() {
  // Removed the auto scroll-to-error feature as it is not working with
  // the new layout - it causes the top menu and patient header to scroll irretrievably off
  // the top of the page. Adjusting the offset eg -300 helps but can lead to the bottom of
  // the page being cut off instead. If this feature is required, we need to find a more standard
  // way to ask the browser to scroll to an element.
  // if ($('small.error').length > 0) {
  //   $('html, body').animate({
  //     scrollTop: ($('small.error').first().offset().top - 300)
  //   },500);
  // }

  initDatepickersIn("body");
  initDateTimepickersIn("body");
  initClockpickersIn("body");
  initSearchableSelects("body");
});
