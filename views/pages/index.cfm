<!---  Link to add new page --->
<cfoutput>
#linkTo(text="+ Add Page",action="addeditpage",class="btn btn-primary")#
<br /><br />

<!---  Listing of all "pages" --->
    <table class="table table-striped table-bordered">
        <thead class="hero-unit">
            <tr>
                 <th <cfif params.order EQ "title">class="headersort#params.sort#"</cfif>>#linkTo(text="Page", params="order=title&sort=#params.asort#")# </th>
                 <th <cfif params.order EQ "firstname">class="headersort#params.sort#"</cfif>>#linkTo(text="Author", params="order=firstname&sort=#params.asort#")# </th>
                 <th <cfif params.order EQ "STATUS">class="headersort#params.sort#"</cfif>>#linkTo(text="Status", params="order=STATUS&sort=#params.asort#")# </th>
                 <th <cfif params.order EQ "createdAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Date", params="order=createdAt&sort=#params.asort#")# </th>
            </tr>
        </thead>
        <tbody>
     <cfloop query="pages">
            <tr>
                <td>#linkto(text=HtmlEditFormat(title),action="addeditpage",key=pageid)#</td>
                <td>#HtmlEditFormat(firstname)# #HtmlEditFormat(lastname)#</td>
                <td>#STATUS#</td>
                <td>#DateFormat(createdAt,"mm/dd/yyyy")#</td>
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
