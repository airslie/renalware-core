$(document).ready(function(){
  $('#modality-description-select').change(function() {
    var selectedModal = $('#modality-description-select option:selected').text();

    if(selectedModal === "Death") {
      $('.hide-death').hide();
      alert("Please note that after saving the Death modality, all current prescriptions will be terminated!")
    } else {
      $('.hide-death').show();
    }
  });
});
