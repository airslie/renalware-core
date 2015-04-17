// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){

 $('#modality-code-select').change(function() {

    var selectedModal = $('#modality-code-select option:selected').text();

    if(selectedModal === "Death") {
      $('.update-death').show();
    } else {
      $('.update-death').hide();
    }

  });

});