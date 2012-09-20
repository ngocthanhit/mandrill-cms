<script type="text/javascript">
$(document).ready(function(){
    $(".showCreateDuplicatePostBox").click(function(event) {
        $('<div/>').dialog2({
            title: "Add Duplicate",
            content: "/index.cfm/posts/duplicatePost/" + $(this).attr('alt'),
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
<!---  Link to add new post --->

<!---  Listing of all "posts" --->
<table class="table table-striped table-bordered">
    <thead class="hero-unit">
        <tr>
            <th width="70%">&nbsp;</th>
            <!---<th <cfif params.order EQ "title">class="headersort#params.sort#"</cfif>>#linkTo(text="Post", params="order=title&sort=#params.asort#")# </th>--->
            <!---<th <cfif params.order EQ "firstname">class="headersort#params.sort#"</cfif>>#linkTo(text="Author", params="order=firstname&sort=#params.asort#")# </th>--->
            <th width="10%" <cfif params.order EQ "STATUS">class="headersort#params.sort#"</cfif>>#linkTo(text="Status", params="order=STATUS&sort=#params.asort#")# </th>
            <th width="10%"<cfif params.order EQ "createdAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Updated", params="order=createdAt&sort=#params.asort#")# </th>
            <th width="10%">Options</th>
        </tr>
    </thead>
    <tbody>
    <cfloop query="allPosts">
        <tr>
           <td>
                #HtmlEditFormat(title)#
           </td>
           <!---<td>#HtmlEditFormat(firstname)# #HtmlEditFormat(lastname)#</td>--->
           <td>#STATUS#</td>
           <td><cfif updatedAt neq "">#DateFormat(updatedAt,"mm/dd/yyyy")#<cfelse>#DateFormat(createdAt,"mm/dd/yyyy")#</cfif></td>
            <td>
                <cfif isGuest() OR isAuthor()>
                    <cfif isAuthor() && (userid EQ getUserAttr("id"))>
                         #linkTo(text="Edit",action="addeditpost",key=id)# | #linkto(text="Delete",action="Deletepost",key=id,confirm="Are you sure you want to delete this post ?")#
                    </cfif>
                <cfelse>
                    #linkTo(text="Edit",action="addeditpost",key=id)# | #linkto(text="Delete",action="Deletepost",key=id,confirm="Are you sure you want to delete this post ?")# <!---| #linkto(text="Duplicate",class="showCreateDuplicatePostBox",alt=id)#--->
                </cfif>
            </td>
        </tr>
    </cfloop>
    </tbody>
</table>

<div class="pagination right">
    #paginationLinksFull()#
</div>
</cfoutput>
<div style="clear:both;"></div>
<div class="bendl"></div>
<div class="bendr"></div>
