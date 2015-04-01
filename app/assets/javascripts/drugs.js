// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){

  //drug type by select
  $('.medication-type-select').change(function(e) {
    var select_box = $(e.currentTarget);
    var selected_medication_type = select_box.val();

    var med_form = select_box.closest('.med-form');

    switch (selected_medication_type) {
      case "Antibiotic":
        med_form.find('.provider-hospital').prop("checked", true);
        med_form.find('.standard').hide();
        med_form.find('.esa-or-immno').show();
      break;
      case "Peritonitis":
        med_form.find('.provider-hospital').prop("checked", true);
        med_form.find('.standard').hide();
        med_form.find('.esa-or-immno').show();
      break;
      case "ESA":
        med_form.find('.provider-hospital').prop("checked", true);
        med_form.find('.standard').hide();
        med_form.find('.esa-or-immno').show();
      break;
      case "Immunosuppressant":
        med_form.find('.provider-gp').prop("checked", true);
        med_form.find('.standard').hide();
        med_form.find('.esa-or-immno').show();
      break;
      default:
        med_form.find('.provider-gp').prop("checked", true);
        med_form.find('.standard').show();
        med_form.find('.esa-or-immno').hide();
      break;
    }

    $.ajax({
      url: '/drugs.json',
      data: { medication_type: selected_medication_type},
      success: function(json) {
        console.log(json);
        var drug_select_box = med_form.find('.drug-select');
        drug_select_box.html('');

        for (var i = 0; i < json.length; i++) {
          var drug_id = json[i].id;
          var drug_name = json[i].name;
          var option_html = _.template("<option class='drug-select-link' value=<%=id%>><%=name%></option>")({ id: drug_id, name: drug_name });
          drug_select_box.append(option_html);
        }
      },
      error: function(json) {
        console.log("Drug list failed to load");
        console.log(json);
      }
    });

  });

  // drug search
  var timer;

  $('.find_drug').keydown(function(e) {
    var entered_drug = $(e.currentTarget);
    var drug_value = entered_drug.val();
    var med_form = entered_drug.closest('.med-form');
    var find_drug_list = entered_drug.closest('.find-drug-list');

    if(timer) clearTimeout(timer);

    timer = setTimeout(function() {
      $.ajax({
        url: '/drugs/search.json',
        data: { drug_search: drug_value },
        success: function(json) {
          console.log(json);
          var drug_results = med_form.find('.drug-results');
          drug_results.html('').show();

          for (var i = 0; i < json.length; i++) {
            var drug_id = json[i].id;
            var drug_name = json[i].name;
            var option_html = _.template("<li class='drug-select-link' data-drug-id=<%=id%>><%= name %></li>")({ id: drug_id, name: drug_name });
            drug_results.append(option_html);
          }
        },
        error: function(json) {
          console.log("Drug list failed to load");
          console.log(json);
        }
      });

      $.ajax({
        url: '/drugs/search.json',
        data: { drug_search: drug_value },
        success: function(json) {
          console.log(json);
          var drug_results = find_drug_list.find('.drug-results-admin');
          drug_results.html('').show();

          for (var i = 0; i < json.length; i++) {
            var drug_id = json[i].id;
            var drug_type = json[i].type;
            var drug_name = json[i].name;
            var found_html = _.template("<li class='row drug-list' data-drug-id=<%=id%>><div class='large-4 columns'><%= type %></div><div class='large-4 columns'><%= name %></div><div class='large-2 columns'><a href='/drugs/<%=id%>/edit'>Edit</a></div><div class='large-2 columns'><a class='delete' data-confirm='Are you sure you want to delete this drug?' data-method='delete' href='/drugs/<%=id%>'>Delete</a></div></li>")({ id: drug_id, name: drug_name, type: drug_type });
            (drug_results).append(found_html);
          }
        },
        error: function(json) {
          console.log("Drug list failed to load");
          console.log(json);
        }
      });


    }, 500);
  });

  // set hidden value of chosen medication via search
  $('body').on('click', '.drug-select-link', function(e) {
    var bullet = $(e.currentTarget);
    console.log(bullet);
    var med_form = bullet.closest('.med-form');
    var drugId = bullet.data('drug-id');
    console.log("clicked on a drug" + drugId);
    med_form.find('.selected-medicatable-id').val(drugId);

    // Show the selected drug
    med_form.find('.find_drug').val(bullet.html());
    med_form.find('.drug-results').hide();
  });

  // set hidden value of chosen medication via select dropdown
  $('.medication-type-select').change(function(e) {
    var bullet = $(e.currentTarget);
    var med_form = bullet.closest('.med-form');
    var delay = 1000;
    setTimeout(function(){
      var selected_drug = med_form.find('.drug-select').val();
      med_form.find('.selected-medicatable-id').val(selected_drug);
    }, delay);

    $('.drug-select').change(function(e) {
      var bullet = $(e.currentTarget);
      var med_form = bullet.closest('.med-form');
      var selected_drug = med_form.find('.drug-select').val();
      med_form.find('.selected-medicatable-id').val(selected_drug);
    });

  });
});

