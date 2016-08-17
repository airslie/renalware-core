$(document).ready(function(){
  $('#uncheck_all_appointments_link').click(function() {
    $(".patient_checkbox").prop("checked", false);
  });
});
