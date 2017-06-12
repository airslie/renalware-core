$(document).ready(function(){
  $('#modality-description-select').change(function() {
    var selectedModal = $('#modality-description-select option:selected').text();

    if(selectedModal === "Death") {
      $('.hide-death').hide();
    } else {
      $('.hide-death').show();
    }
  });
});
