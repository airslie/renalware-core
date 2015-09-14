// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){

  $('.modal-change-type').change(function(e) {

    var $selectBox = $(e.currentTarget);
    var selectedChangeType = $selectBox.val();
    var $modalityForm = $selectBox.closest('.modality-form');

    $.ajax({
        url: '/modality_reasons.json',
        data: { modal_change_type: selectedChangeType },
        success: function(json) {
          // console.log(json);
          var $reasonSelectBox = $modalityForm.find('.modality-reason-select');
          $reasonSelectBox.html('');

          for (var i = 0; i < json.length; i++) {
            var reasonId = json[i].id;
            var reasonDescription = json[i].description;
            var optionHtml = _.template("<option value=<%=id%>><%=description%></option>")({ id: reasonId, description: reasonDescription });
            $reasonSelectBox.append(optionHtml);
          }
        },
        error: function(json) {
          console.log("Modality Reasons failed to load");
          console.log(json);
        }
      });

  });


  $('#modal-reason-code').click(function() {

    var $bigModal = $('<div></div>').attr('class','modal-show');
    var $smallModal = $('<div><b class="modal-close fi-x"></b><h5 class="g-center ">Renal Registry Reason for Change Codes</h5></div>').attr('class','modal-window ');
    var $modalHolder = $('<div id=modal-holder></div>');
    var $hdPdTable = $('<table><caption>Haemodialysis to PD</caption><thead><tr><th>RR Code</th><th>Reason for Change</th></tr></thead><tbody id="hd-pd"></tbody></table>');
    var $pdHdTable = $('<table><caption>PD to Haemodialysis</caption><thead><tr><th>RR Code</th><th>Reason for Change</th></tr></thead><tbody id="pd-hd"></tbody></table>');

    $bigModal.attr('id','big-modal').appendTo('div#wrapper');
    $smallModal.attr('id','small-modal').appendTo('div#big-modal');
    $modalHolder.appendTo('div#small-modal');
    $hdPdTable.appendTo('div#modal-holder');
    $pdHdTable.appendTo('div#modal-holder');

    $('.modal-close').click(function() {
      $('#big-modal').remove();
    });

    $.ajax({
        url: '/modality_reasons.json',
        data: { modal_change_type: "HaemodialysisToPd" },
        success: function(json) {
          // console.log(json);

          for (var i = 0; i < json.length; i++) {
            var reasonRrCode = json[i].rr_code;
            var reasonDescription = json[i].description;
            var trTdHtml = _.template("<tr><td><%=rr_code%></td><td><%=description%></td></tr>")({ rr_code: reasonRrCode, description: reasonDescription });
            $('#hd-pd').append(trTdHtml);
          }
        },
        error: function(json) {
          console.log("Modality Reasons failed to load");
          console.log(json);
        }
      });

    $.ajax({
        url: '/modality_reasons.json',
        data: { modal_change_type: "PdToHaemodialysis" },
        success: function(json) {
          // console.log(json);

          for (var i = 0; i < json.length; i++) {
            var reasonRrCode = json[i].rr_code;
            var reasonDescription = json[i].description;
            var trTdHtml = _.template("<tr><td><%=rr_code%></td><td><%=description%></td></tr>")({ rr_code: reasonRrCode, description: reasonDescription });
            $('#pd-hd').append(trTdHtml);
          }
        },
        error: function(json) {
          console.log("Modality Reasons failed to load");
          console.log(json);
        }
      });

  });

});