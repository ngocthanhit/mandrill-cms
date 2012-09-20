<!---  Link to add new page --->
<script type="text/javascript">
$(document).ready(function(){
    $(".showCreateDuplicatePageBox").click(function(event) {
        $('<div/>').dialog2({
            title: "Add Duplicate",
            content: "/index.cfm/pages/duplicatePage/" + $(this).attr('alt'),
            id: "Insert_Duplicate"
        });
        event.preventDefault();
    });
})
function validateCreateDuplicateForm() {
    if($("#title").val()==""){
        alert('Plase first enter title in title field.');
        $("#title").focus();
        return false;
    }
    return true;
}
</script>
<cfoutput>
<cffunction name="getdataParent">
    <cfargument name="parentID" type="numeric" required="yes">
    <cfargument name="count" type="numeric" required="yes">
    <cfquery name="getChilds" dbtype="query">
        SELECT  * FROM pages WHERE parentID =  #arguments.parentID#
    </cfquery>
    <cfif getChilds.recordcount GT 0>
        <cfloop query="getChilds">
             <tr>
                <td style="padding-left:#20*count#px !important;">#HtmlEditFormat(title)#</td>
              <!---  <td>#HtmlEditFormat(firstname)# #HtmlEditFormat(lastname)#</td>--->
                <td>#STATUS#</td>
                <td>#DateFormat(createdAt,"mm/dd/yyyy")#</td>
                <td>#linkto(text="Edit",action="addeditpage",key=id)# | #linkto(text="Delete",action="Deletepage",key=id,confirm="Are you sure you want to delete this page or its sub-pages ?")# <!---| #linkto(text="Duplicate",class="showCreateDuplicatePageBox",alt=id)#---></td>
            </tr>
            #getdataParent(id,count+1)#
        </cfloop>
      </cfif>
</cffunction>
<!---  Listing of all "pages" --->
    <table class="table table-striped table-bordered">
        <thead class="hero-unit">
            <tr>
                <th width="70%">&nbsp;</th>
                <!--- <th <cfif params.order EQ "title">class="headersort#params.sort#"</cfif>>#linkTo(text="Page", params="order=title&sort=#params.asort#")# </th>--->
                 <!---<th <cfif params.order EQ "firstname">class="headersort#params.sort#"</cfif>>#linkTo(text="Author", params="order=firstname&sort=#params.asort#")# </th>--->
                 <th width="10%" <cfif params.order EQ "STATUS">class="headersort#params.sort#"</cfif>>#linkTo(text="Status", params="order=STATUS&sort=#params.asort#")# </th>
                 <th width="10%"<cfif params.order EQ "createdAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Updated", params="order=createdAt&sort=#params.asort#")# </th>
                 <th width="10%">Options</th>
            </tr>
        </thead>
        <tbody>
     <cfif pages.recordcount GT 0>
         <cfquery name="getParents" dbtype="query">
            SELECT  * FROM pages WHERE parentID IS NULL
        </cfquery>
         <cfloop query="getParents">
            <tr>
                <td>#HtmlEditFormat(title)#</td>
               <!--- <td>#HtmlEditFormat(firstname)# #HtmlEditFormat(lastname)#</td>--->
                <td>#STATUS#</td>
                <td><cfif updatedAt neq "">#DateFormat(updatedAt,"mm/dd/yyyy")#<cfelse>#DateFormat(createdAt,"mm/dd/yyyy")#</cfif></td>
                <td>#linkto(text="Edit",action="addeditpage",key=id)# | #linkto(text="Delete",action="Deletepage",key=id,confirm="Are you sure you want to delete this page or its sub-pages ?")# <!---| #linkto(text="Duplicate",class="showCreateDuplicatePageBox",alt=id)#---></td>
            </tr>
            #getdataParent(id,1)#
    </cfloop>
       </cfif>
    </tbody>
</table>


<div class="pagination right">
    #paginationLinksFull()#
</div>
</cfoutput>
<div style="clear:both;"></div>
<div class="bendl"></div>
<div class="bendr"></div>
