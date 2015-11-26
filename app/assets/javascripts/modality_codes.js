$(document).ready(function(){

  $('#modality-code-select').change(function() {

    var selectedModal = $('#modality-code-select option:selected').text();

    if(selectedModal === "Death") {
      $('.hide-death').hide();
    } else {
      $('.hide-death').show();
    }

  });
});
