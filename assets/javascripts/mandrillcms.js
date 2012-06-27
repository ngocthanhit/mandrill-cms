
// function to toggle "published on future date" div
function toggleDiv(id)
{
    var elementID = document.getElementById(id);
    if(elementID.style.display == 'none')
    {
        $(".btn-primary").eq(0).removeClass("btn-primary");
        $("#" + id).show();
    }
    else
    {
        $(".btn").eq(1).addClass("btn-primary");
        $("#" + id).hide();
    }
    return false;
}

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

})(jQuery);