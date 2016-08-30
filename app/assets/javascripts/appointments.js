$(document).ready(function() {
  $('#uncheck_all_appointments_link').click(function() {
    $(".patient_checkbox").prop("checked", false);
    $('input[name="request[patient_ids][]"]').prop("disabled", true);
  });

  $("input.patient_checkbox").click(function(e) {
    var patient_id = this.value;
    var patient_hidden_input =
      $('input[name="request[patient_ids][]"][value="' + patient_id + '"]');

    patient_hidden_input.prop('disabled', !this.checked);
  });
});
