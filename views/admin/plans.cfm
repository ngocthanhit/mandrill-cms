<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%" class="sortable">
    <thead>
        <tr>
            <th style="width:30px;" <cfif params.order EQ "position">class="headersort#params.sort#"</cfif>>#linkTo(text="Pos", params="order=position&sort=#params.asort#", title="Position")#</th>
            <th <cfif params.order EQ "name">class="headersort#params.sort#"</cfif>>#linkTo(text="Plan Name", params="order=name&sort=#params.asort#")#</th>
            <th style="width:80px;" <cfif params.order EQ "price">class="headersort#params.sort#"</cfif>>#linkTo(text="Price", params="order=price&sort=#params.asort#")#</th>
            <th>Description</th>
            <th style="width:80px;" <cfif params.order EQ "isactive">class="headersort#params.sort#"</cfif>>#linkTo(text="Is Active", params="order=isactive&sort=#params.asort#")#</th>
            <th style="width:80px;" <cfif params.order EQ "ispublic">class="headersort#params.sort#"</cfif>>#linkTo(text="Is Public", params="order=ispublic&sort=#params.asort#")#</th>
            <th style="width:150px;" <cfif params.order EQ "updatedAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Updated", params="order=updatedAt&sort=#params.asort#")#</th>
            <th style="width:50px;">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
    <cfloop query="plans">
        <tr <cfif plans.currentRow MOD 2>class="even"</cfif>>
            <td>#plans.position#)</td>
            <td>#HTMLEditFormat(plans.name)#</td>
            <td>#DollarFormat(plans.price)#</td>
            <td>#HTMLEditFormat(Left(plans.description, 80))#<cfif Len(plans.description) GT 80> (...)</cfif></td>
            <td>#YesNoFormat(plans.isactive)#</td>
            <td>#YesNoFormat(plans.ispublic)#</td>
            <td class="nowrap">#formatDateTime(plans.updatedAt)#</td>
            <td class="actions">
                #linkTo(text="Quotas", action="planQuotas", key=plans.id)#
                #linkTo(text="Edit", action="planEdit", key=plans.id)#
            </td>
        </tr>
    </cfloop>
    </tbody>
</table>

<div class="pagination right">#paginationLinksFull()#</div>
</cfoutput>