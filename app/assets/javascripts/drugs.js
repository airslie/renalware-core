// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){

  //drug type by select
  $(document).on('change', '.medication-type-select', function(e) {
    var $selectBox = $(e.currentTarget);
    var selectedMedicationType = $selectBox.val();
    var $medForm = $selectBox.closest('.med-form');

    var $providerHospital = $medForm.find('.provider-hospital');
    var $standard = $medForm.find('.standard');
    var $drugBySelect = $medForm.find('.drug-by-select');
    var $providerGp = $medForm.find('.provider-gp');

    switch (selectedMedicationType) {
      case "antibiotic":
        $providerGp.prop("checked", true);
        $standard.hide();
        $drugBySelect.show();
      break;
      case "esa":
        $providerHospital.prop("checked", true);
        $standard.hide();
        $drugBySelect.show();
      break;
      case "immunosuppressant":
        $providerGp.prop("checked", true);
        $standard.hide();
        $drugBySelect.show();
      break;
      default:
        $providerGp.prop("checked", true);
        $standard.show();
        $drugBySelect.hide();
      break;
    }

    $.ajax({
      url: '/drugs/selected_drugs.json',
      data: { medication_switch: selectedMedicationType },
      success: function(json) {
        var $drugSelectBox = $medForm.find('.drug-select');
        $drugSelectBox.html('');

        for (var i = 0; i < json.length; i++) {
          var drugId = json[i].id;
          var drugName = json[i].name;
          var optionHtml = _.template("<option class='drug-select-link' value=<%=id%>><%=name%></option>")({ id: drugId, name: drugName });
          $drugSelectBox.append(optionHtml);
        }
      },
      error: function(json) {
        console.log("Drug list failed to load");
        console.log(json);
      }
    });

  });

  // drug search
  var timer,
      // TODO: Get rid of this.
      drugAdminTemplate = "<li class='row drug-list' data-drug-id=<%=id%>><div class='large-4 columns'></div><div class='large-4 columns'><a href='/drugs/<%=id%>/drug_drug_types'><%= name %></a></div><div class='large-2 columns'><a href='/drugs/<%=id%>/edit'>Edit</a></div><div class='large-2 columns'><a class='delete' data-confirm='Are you sure you want to delete this drug?' data-method='delete' href='/drugs/<%=id%>'>Delete</a></div></li>",
      medicationsTemplate = "<li id=drug-<%=id%> class='drug-select-link' data-drug-id=<%=id%>><%= name %></li>";

   // $(document).on('change', '.medication-type-select', function(e) {
  $(document).on('keyup', '.find_drug', function(e) {

    var $drugSearchInput = $(e.currentTarget),
        query = $drugSearchInput.val();
        $medForm = $drugSearchInput.closest('.med-form');
        $drugResults = $drugSearchInput.siblings('.drug-results');

    if(timer) clearTimeout(timer);

    timer = setTimeout(function() {
      if (query.length > 2) {
        $.ajax({
          url: '/drugs.json',
          data: { q : { name_or_drug_types_name_start : query } },
          success: function(json) {
            $drugResults.html('').show();
            for (var i = 0; i < json.length; i++) {
              var htmlTemplate = location.pathname === '/drugs' ? drugAdminTemplate : medicationsTemplate,
                  resultsHtml = _.template(htmlTemplate)(json[i]);
              $drugResults.append(resultsHtml);
            }
          }
        });
      }
    }, 500);
  });

  // set hidden value of chosen medication via search
  $('body').on('click', '.drug-select-link', function(e) {
    var $bullet = $(e.currentTarget);
    var $medForm = $bullet.closest('.med-form');
    var drugId = $bullet.data('drug-id');
    $medForm.find('.selected-medicatable-id').val(drugId);

    // Show the selected drug
    $medForm.find('.find_drug').val($bullet.html());
    $medForm.find('.drug-results').hide();
  });

  // set hidden value of chosen medication via select dropdown
  $(document).on('change', '.medication-type-select', function(e) {
    var $bullet = $(e.currentTarget);
    var $medForm = $bullet.closest('.med-form');
    var delay = 1000;
    setTimeout(function(){
      var selectedDrug = $medForm.find('.drug-select').val();
      $medForm.find('.selected-medicatable-id').val(selectedDrug);
    }, delay);

    $('.drug-select').change(function(e) {
      var $bullet = $(e.currentTarget);
      var $medForm = $bullet.closest('.med-form');
      var selectedDrug = $medForm.find('.drug-select').val();
      $medForm.find('.selected-medicatable-id').val(selectedDrug);
    });

  });

});

