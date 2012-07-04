
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
$('.markItUp').wysihtml5();
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

    imagePreview();

});
/* ajax Upload methods  */
var current_perc = 0;
function updateProgressbar()
{
$('.progress .bar').each(function() {
   var me = $(this);
   var perc = me.attr("data-percentage");

   var progress = setInterval(function() {
       if (current_perc>=perc) {
        clearInterval(progress);
       } else {
        if(current_perc < 90){
             current_perc +=1;
             me.css('width', (current_perc)+'%');
        }
       }

       me.text((current_perc)+'%');

   }, 50);

  });
}


function ajaxFileUploadcsv(controlname)
{
   if($("#" +controlname).val() == "") return false;
   if($("#title").val() == "") return false;
        updateProgressbar();
        $.ajaxFileUpload
        (
             {
                  url:'/index.cfm/webfiles/upload',
                  secureuri:false,
                  fileElementId:controlname,
                  dataType: 'json',
                  data:{filefield:controlname,title:$("#title").val()},
                  success: function (data, status)
                       {
                            if(data == "success"){
                                 current_perc = 100;
                                 $('.progress .bar').css('width','100%');
                                 $("#importfilename").val('');
                                 $("#title").val('');
                                  setTimeout("window.location.reload()",1000);
                            }
                            else if(data == "errro"){
                                 $(".progress .bar").html('Upload Failed.').show();
                            }
                       },
                  error: function (data, status, e)
                       {
                            $(".progress .bar").html('Upload Failed.').show();
                       }
             }
        )
   $("#UploadFiles").click(function()
   {
        current_perc = 0;
        $('.progress .bar').css('width','0%');
        $('.progress .bar').html('');                    
   });

        return false;
}

this.imagePreview = function(){
    /* CONFIG */

        xOffset = 10;
        yOffset = 30;

        // these 2 variable determine popup's distance from the cursor
        // you might want to adjust to get the right result

    /* END CONFIG */
    $("a.preview").hover(function(e){
        this.t = this.title;
        this.title = "";
        var c = (this.t != "") ? "<br/>" + this.t : "";
        $("body").append("<p id='preview'><img src='"+ this.href +"' alt='Image preview' />"+ c +"</p>");
        $("#preview")
            .css("top",(e.pageY - xOffset) + "px")
            .css("left",(e.pageX + yOffset) + "px")
            .fadeIn("fast");
    },
    function(){
        this.title = this.t;
        $("#preview").remove();
    }).click(function(e){e.preventDefault();});
    $("a.preview").mousemove(function(e){
        $("#preview")
            .css("top",(e.pageY - xOffset) + "px")
            .css("left",(e.pageX + yOffset) + "px");
    });
};
