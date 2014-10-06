(function($) {
   
   $.fn.uiforms = function(settings) {
     var config = { };
 
     if (settings) $.extend(config, settings);
 
     this.each(function() {
         // Add permanent classes
         $('form').addClass('uiforms-form ui-widget ui-corner-all');
         $('fieldset').addClass('uiforms-fieldset ui-widget-content ui-corner-all');
         $('legend').addClass('uiforms-legend ui-corner-all');
         $('label').addClass('uiforms-label');
         $(':input').addClass('uiforms-input ui-corner-all');
         $(':text').addClass('uiforms-text');
         $(':password').addClass('uiforms-password');
         $(':radio').addClass('uiforms-radio');
         $(':checkbox').addClass('uiforms-checkbox');
         $(':submit').addClass('uiforms-submit');
         $(':image').addClass('uiforms-image');
         $(':reset').addClass('uiforms-reset');
         $(':button').addClass('uiforms-button');
         $(':file').addClass('uiforms-file');
         // Dynamically add and remove classes
        // $(':input').hover(function() {
        //    $(this).addClass('ui-state-hover');
        // }, function() {
        //     $(this).removeClass('ui-state-hover');  
        // });
         $(':input').focus(function() {
            $(this).addClass('ui-state-focus');   
         });
         $(':input').blur(function() {
            $(this).removeClass('ui-state-focus');   
         });
     });
     
     return this;
   
   };
 
})(jQuery);