// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){

  $('.medication-type-select').change(function(e) {
    var select_box = $(e.currentTarget);
    var selected_medication_type = select_box.val();

    var med_form = select_box.closest('.med-form');
    
    switch (selected_medication_type) {
      case "":
        med_form.find('.provider-gp').prop("checked", true);
      break;
      case "Esa":
        med_form.find('.provider-hospital').prop("checked", true);
      break;
      case "Immunosuppressant":
        med_form.find('.provider-home-delivery').prop("checked", true);
      break;
    }

    $.ajax({
      url: '/drugs.json',
      data: { medication_type: selected_medication_type },
      success: function(json) {
        console.log(json);
        var drug_select_box = med_form.find('.drug-select');
        drug_select_box.html('');

        for (var i = 0; i < json.length; i++) {
          var drug_id = json[i].id;
          var drug_name = json[i].name;
          var option_html = _.template("<option value=<%=id%>><%=name%></option>")({ id: drug_id, name: drug_name });
          drug_select_box.append(option_html);
        }
      },
      error: function(json) {
        console.log("Drug list failed to load");
        console.log(json);
      }
    });

  });

});


