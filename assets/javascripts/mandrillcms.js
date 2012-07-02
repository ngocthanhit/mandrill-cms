
(function($){

    /*
     * Apply required asterisk by CSS class
     */
    $.fn.requiredInput = function(options){

        var self = this,
            settings = {
                'requiredText': '<span class="required">*</span>'
            };

        if (options) { 
            $.extend(settings, options);
        }
        
        return self.each(function() {
            var el = $(this);
            el.parent().children('label').append( settings.requiredText );
        });
        
    },

    /*
     * Bind quick toggle events for boolean fields
     */
    $.fn.bindToggleLinks = function(options){


        this.bind("click", function() {

            var self = $(this);

            self.text("").addClass("toggling");

            $.get("/ajax/toggle/?format=json", {model : self.attr("model"), key : self.attr("key"), field : self.attr("field")}, function (data) {

                if ((typeof data.success == "undefined") || !data.success) {
                    alert("We apologize, but unexpected processing error happened.");
                }
                else {
                    self.removeClass("toggling").text(data.message);
                }

            });

        });


    }
/*
    * function to toggle "published on future date" div
*/


})(jQuery);
$(document).ready(function() {

 $(".futureDateCont").click(function(e)
          {
            var containerID = $(this).attr('class') ;
              if($("#" + containerID).css('display') == 'none')
                {
                    $(".SubmitButton").eq(1).removeClass("btn-primary");
                    $("#" + containerID).show();
                }
                else
                {
                    $(".SubmitButton").eq(1).addClass("btn-primary");
                    $("#" + containerID).hide();
                }
                e.preventDefault();
        }).trigger('click');
});
