
(function($){

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
    $(".futureDateCont").click(function()
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
                event.preventDefault();
        }).trigger('click');

})(jQuery);