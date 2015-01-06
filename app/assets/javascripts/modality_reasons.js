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

  $('#modal-reason-code').click(function() {

    var bigModal = $('<div></div>').attr('class','show');
    var smallModal = $('<div><b class="close fi-x"></b><h5 class="g-center ">Renal Registry Reason for Change Codes</h5></div>').attr('class','modal-window ');
    var modalHolder = $('<div id=modal-holder></div>');
    var hd_pd_table = $('<table><caption>Haemodialysis to PD</caption><thead><tr><th>RR Code</th><th>Reason for Change</th></tr></thead><tbody id="hd-pd"></tbody></table>');
    var pd_hd_table = $('<table><caption>PD to Haemodialysis</caption><thead><tr><th>RR Code</th><th>Reason for Change</th></tr></thead><tbody id="pd-hd"></tbody></table>');

    bigModal.attr('id','big-modal').appendTo('div#wrapper');
    smallModal.attr('id','small-modal').appendTo('div#big-modal');
    modalHolder.appendTo('div#small-modal');
    hd_pd_table.appendTo('div#modal-holder');
    pd_hd_table.appendTo('div#modal-holder');

    $('.close').click(function() {
      $('#big-modal').remove();
    });

    $.ajax({
        url: '/modality_reasons.json',
        data: { modal_change_type: "HaemodialysisToPd" },
        success: function(json) {
          console.log(json);

          for (var i = 0; i < json.length; i++) {
            var reason_rr_code = json[i].rr_code;
            var reason_description = json[i].description;
            var tr_td_html = _.template("<tr><td><%=rr_code%></td><td><%=description%></td></tr>")({ rr_code: reason_rr_code, description: reason_description });
            $('#hd-pd').append(tr_td_html);
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
          console.log(json);

          for (var i = 0; i < json.length; i++) {
            var reason_rr_code = json[i].rr_code;
            var reason_description = json[i].description;
            var tr_td_html = _.template("<tr><td><%=rr_code%></td><td><%=description%></td></tr>")({ rr_code: reason_rr_code, description: reason_description });
            $('#pd-hd').append(tr_td_html);
          }
        },
        error: function(json) {
          console.log("Modality Reasons failed to load");
          console.log(json);
        }
      });

  });

});