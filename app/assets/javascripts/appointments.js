$(document).ready(function() {

  $("input.patient_checkbox").click(function(e) {
    var patient_id = this.value;
    var patient_hidden_input =
      $('input[name="request_form_options[patient_ids][]"][value="' + patient_id + '"]');

    patient_hidden_input.prop('disabled', !this.checked);
  });
});
