
<cfoutput>
<!---  Listing of all "pages" --->
    <table class="table table-striped table-bordered">
        <thead class="hero-unit">
            <tr>
                 <th>Page</th>
                 <th>Author</th>
                 <th>Status</th>
                 <th>Date</th>
                 <th>Action</th>
            </tr>
         </thead>
        <tbody>
     <cfloop query="pages">
            <tr>
                <td>#HtmlEditFormat(title)#</td>
                <td>#HtmlEditFormat(firstname)# #HtmlEditFormat(lastname)#</td>
                <td>#STATUS#</td>
                <td>#DateFormat(createdAt,"mm/dd/yyyy")#</td>
                <td class="Add"> <a class="btn btn-primary AddButton" href="javascript:setpageval('#id#')" >
                <i class="icon-plus icon-white"></i>
                <span >ADD</span>
                </a></td>
            </tr>
    </cfloop>
    </tbody>
</table>
</cfoutput>
<div style="clear:both;"></div>
<div class="bendl"></div>
<div class="bendr"></div>
<cfabort>
