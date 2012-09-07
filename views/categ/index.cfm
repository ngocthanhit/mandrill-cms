<script type="text/javascript">
    $(document).ready(function(e) {
        $("#savecategory").click(function(e) {
             $("#savecategory").attr('disabled','true');
             $("#savecategory").attr('content','waiting...');
           $.post("/index.cfm/categ/createNewcategory?category="+$("#category").val(), function(data) {
              data = $.trim(data);
              var content = "<input type=checkbox name=categoryID id=categoryID-" + data + " value=" + data + " /> " + $("#category").val() + "<br>";
              $(".categories").append(content);
              $("#Insert_Category").dialog2("close");
            });
        });
    });
</script>
<cfoutput>
    #textFieldtag(label="Category Name : ",name="category",id="category")#
    #ButtonTag(id="savecategory",value="Save",type="button",content="Save")#

</cfoutput>
<cfabort>