<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%" class="sortable">
    <thead>
        <tr>
            <th style="width:30px;" <cfif params.order EQ "position">class="headersort#params.sort#"</cfif>>#linkTo(text="Pos", params="order=position&sort=#params.asort#", title="Position")#</th>
            <th style="width:120px;" <cfif params.order EQ "token">class="headersort#params.sort#"</cfif>>#linkTo(text="Internal Code", params="order=token&sort=#params.asort#")#</th>
            <th <cfif params.order EQ "name">class="headersort#params.sort#"</cfif>>#linkTo(text="Feature Name", params="order=name&sort=#params.asort#")#</th>
            <th style="width:40px;">Unit</th>
            <th>Description</th>
            <th style="width:80px;" <cfif params.order EQ "isactive">class="headersort#params.sort#"</cfif>>#linkTo(text="Is Active", params="order=isactive&sort=#params.asort#")#</th>
            <th style="width:150px;" <cfif params.order EQ "updatedAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Updated", params="order=updatedAt&sort=#params.asort#")#</th>
            <th style="width:40px;">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
    <cfloop query="features">
        <tr <cfif features.currentRow MOD 2>class="even"</cfif>>
            <td>#features.position#)</td>
            <td>#HTMLEditFormat(features.token)#</td>
            <td>#HTMLEditFormat(features.name)#</td>
            <td>#HTMLEditFormat(features.unit)#</td>
            <td>#HTMLEditFormat(Left(features.description, 80))#<cfif Len(features.description) GT 80> (...)</cfif></td>
            <td>#YesNoFormat(features.isactive)#</td>
            <td class="nowrap">#formatDateTime(features.updatedAt)#</td>
            <td class="actions">
                #linkTo(text="Edit", action="featureEdit", key=features.id)#
            </td>
        </tr>
    </cfloop>
    </tbody>
</table>

<div class="pagination right">#paginationLinksFull()#</div>
</cfoutput>