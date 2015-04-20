// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
   
  //drug type by select
  $('.medication-type-select').change(function(e) {
    console.log("Hello");
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
        console.log(json);
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
  var timer;

  $('.find_drug').keydown(function(e) {
    var $enteredDrug = $(e.currentTarget);
    var drugValue = $enteredDrug.val();
    var $medForm = $enteredDrug.closest('.med-form');
    var $findDrugList = $enteredDrug.closest('.find-drug-list');

    if(timer) clearTimeout(timer);

    timer = setTimeout(function() {
      $.ajax({
        url: '/drugs/search.json',
        data: { drug_search: drugValue },
        success: function(json) {
          console.log(json);
          var $drugResults = $medForm.find('.drug-results');
          $drugResults.html('').show();

          for (var i = 0; i < json.length; i++) {
            var drugId = json[i].id;
            var drugName = json[i].name;
            var optionHtml = _.template("<li class='drug-select-link' data-drug-id=<%=id%>><%= name %></li>")({ id: drugId, name: drugName });
            $drugResults.append(optionHtml);
          }
        },
        error: function(json) {
          console.log("Drug list failed to load");
          console.log(json);
        }
      });

      $.ajax({
        url: '/drugs/search.json',
        data: { drug_search: drugValue },
        success: function(json) {
          console.log(json);
          var $drugResults = $findDrugList.find('.drug-results-admin');
          $drugResults.html('').show();

          for (var i = 0; i < json.length; i++) {
            var drugId = json[i].id;
            var drugType = json[i].type;
            var drugName = json[i].name;
            var foundHtml = _.template("<li class='row drug-list' data-drug-id=<%=id%>><div class='large-4 columns'><%= type %></div><div class='large-4 columns'><%= name %></div><div class='large-2 columns'><a href='/drugs/<%=id%>/edit'>Edit</a></div><div class='large-2 columns'><a class='delete' data-confirm='Are you sure you want to delete this drug?' data-method='delete' href='/drugs/<%=id%>'>Delete</a></div></li>")({ id: drugId, name: drugName, type: drugType });
            $drugResults.append(foundHtml);
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
    var $bullet = $(e.currentTarget);
    console.log($bullet);
    var $medForm = $bullet.closest('.med-form');
    var drugId = $bullet.data('drug-id');
    console.log("clicked on a drug" + drugId);
    $medForm.find('.selected-medicatable-id').val(drugId);

    // Show the selected drug
    $medForm.find('.find_drug').val($bullet.html());
    $medForm.find('.drug-results').hide();
  });

  // set hidden value of chosen medication via select dropdown
  $('.medication-type-select').change(function(e) {
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
      console.log(selectedDrug);
      $medForm.find('.selected-medicatable-id').val(selectedDrug);
    });

  });

});

