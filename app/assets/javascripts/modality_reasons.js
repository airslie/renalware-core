// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){

  $('.modal-change-type').change(function(e) {

    var select_box = $(e.currentTarget);
    var selected_change_type = select_box.val();

    var modality_form = select_box.closest('.modality-form');

    $.ajax({
        url: '/modality_reasons.json',
        data: { modal_change_type: selected_change_type },
        success: function(json) {
          console.log(json);
          var reason_select_box = modality_form.find('.modality-reason-select');
          reason_select_box.html('');

          for (var i = 0; i < json.length; i++) {
            var reason_id = json[i].id;
            var reason_description = json[i].description;
            var option_html = _.template("<option value=<%=id%>><%=description%></option>")({ id: reason_id, description: reason_description });
            reason_select_box.append(option_html);
          }
        },
        error: function(json) {
          console.log("Modality Reasons failed to load");
          console.log(json);
        }
      });

  });

  $('#modality-code-select').change(function() {
    var selected_modal = $('#modality-code-select option:selected').text();

    if(selected_modal === "Death") {
      $('.update-death').show();
    } else {
      $('.update-death').hide();
    }

  });

});