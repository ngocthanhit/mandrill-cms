<script type="text/javascript">
    function validateform() {
            if($("#siteid").val()==""){
                    alert('First choose site.');
                    $("#siteid").focus();
                    return false;
            }
        return true;
    }
</script>
<cfoutput>
<cfif IsDefined("Session.siteid") ><cfset selected=Session.siteid><cfelse><cfset selected=0></cfif>
    #startformtag(action="setChooseSite",onsubmit="return validateform();")#
        #selectTag(label="Sites : ",name="siteid",id="siteid", options=sites, valueField="id", textField="name",includeBlank="true",selected="#selected#")#
        #submitTag(value="Set")#
    #endformtag()#
</cfoutput>