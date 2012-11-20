<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%" class="sortable">
    <thead>
        <tr>
            <th style="width:20px;">&nbsp;</th>
            <th <cfif params.order EQ "name">class="headersort#params.sort#"</cfif>>#linkTo(text="Discount Name", params="order=name&sort=#params.asort#")#</th>
            <th style="width:80px;" <cfif params.order EQ "discount">class="headersort#params.sort#"</cfif>>#linkTo(text="Discount", params="order=discount&sort=#params.asort#")#</th>
            <th style="width:80px;" <cfif params.order EQ "coupon">class="headersort#params.sort#"</cfif>>#linkTo(text="Coupon", params="order=coupon&sort=#params.asort#")#</th>
            <th>Description</th>
            <th style="width:80px;" <cfif params.order EQ "isactive">class="headersort#params.sort#"</cfif>>#linkTo(text="Is Active", params="order=isactive&sort=#params.asort#")#</th>
            <th style="width:80px;" <cfif params.order EQ "expirationDate">class="headersort#params.sort#"</cfif>>#linkTo(text="Exp. Date", params="order=expirationDate&sort=#params.asort#")#</th>
            <th style="width:150px;" <cfif params.order EQ "updatedAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Updated", params="order=updatedAt&sort=#params.asort#")#</th>
            <th style="width:50px;">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
    <cfloop query="discounts">
        <tr <cfif discounts.currentRow MOD 2>class="even"</cfif>>
            <td>#discounts.currentRow#)</td>
            <td>#HTMLEditFormat(discounts.name)#</td>
            <td>#discounts.discount#%</td>
            <td>#HTMLEditFormat(discounts.coupon)#</td>
            <td>#HTMLEditFormat(Left(discounts.description, 80))#<cfif Len(discounts.description) GT 80> (...)</cfif></td>
            <td>#YesNoFormat(discounts.isactive)#</td>
            <td>#formatDate(discounts.expirationDate)#</td>
            <td class="nowrap">#formatDateTime(discounts.updatedAt)#</td>
            <td class="actions">
                <cfif discounts.isactive>
                #linkTo(text="Apply", action="discountApply", key=discounts.id)#
                <cfelse>
                <strike title="Inactive discount cannot be applied any more">Apply</strike>
                </cfif>
                #linkTo(text="Edit", action="discountEdit", key=discounts.id)#
            </td>
        </tr>
    </cfloop>
    </tbody>
</table>

<div class="pagination right">#paginationLinksFull()#</div>
</cfoutput>