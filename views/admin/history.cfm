<cfoutput>
<div>

    <div class="page-header">           
        <h2>Data History Filters</h2>
    </div>

    <div class="well content">

        #flashRender()#

        #startFormTag(action="history")#
        <fieldset>

        <div class="clear" style="padding:4px;"></div>

        <div class="floated" style="width:75px;">
            <label>Date from</label>
        </div>
        <div class="floated">
            <input type="text" name="datefrom" value="#DateFormat(params.datefrom, get('defaultDateFormat'))#" class="text date_picker" />
        </div>
        <div class="floated" style="width:30px;">
            <label style="width:20px; text-align:right;">to</label>
        </div>
        <div class="floated">
            <input type="text" name="dateto" value="#DateFormat(params.dateto, get('defaultDateFormat'))#" class="text date_picker" />
        </div>

        <div class="clear" style="padding:4px;"></div>

        <div class="floated" style="width:75px;">
            <label>Show</label>
        </div>
        <div class="floated">
            <select name="fuserid" class="styled">
                <option value="">- all users -</option>
            <cfloop query="users">
                <option value="#users.id#"<cfif params.fuserid EQ users.id> selected="selected"</cfif>>#HTMLEditFormat(users.email)#</option>
            </cfloop>
            </select>
        </div>
        <div class="floated">
            <select name="fmodel" class="styled">
                <option value="">- all objects -</option>
            <cfloop query="objects">
                <option value="#objects.modelcode#"<cfif params.fmodel EQ objects.modelcode> selected="selected"</cfif>>#objects.modelcode#</option>
            </cfloop>
            </select>
        </div>
        <div class="floated">
            <select name="ftype" class="styled">
                <option value=""<cfif params.ftype EQ ""> selected="selected"</cfif>>- all types -</option>
                <option value="r"<cfif params.ftype EQ "r"> selected="selected"</cfif>>data replaced</option>
                <option value="d"<cfif params.ftype EQ "d"> selected="selected"</cfif>>data deleted</option>
            </select>
        </div>

        <div class="clear" style="padding:4px;"></div>

        <div class="floated" style="width:75px;">&nbsp;</div>
        <div class="floated">
            #submitTag(class="submit small", name="apply", value="Apply", class="btn btn-primary btn-large")#
            #submitTag(class="submit small", name="reset", value="Reset", class="btn btn-large")#
        </div>

        <div class="clear" style="padding:4px;"></div>

        </fieldset>
        #endFormTag()#

    </div>

    <div class="bendl"></div>
    <div class="bendr"></div>

</div>

<div class="block">

    <div class="block_head">
        <div class="bheadl"></div>
        <div class="bheadr"></div>
        <h2>Data History Events</h2>
        <ul>
            <li class="active">
                Show by:
                <cfloop list="#get('showBySize')#" index="p">
                #linkTo(text=p, params="pagesize=#p#", class=iif(params.pagesize EQ p, De('active'), De('')), key=view.showByKey)#
                </cfloop>
            </li>
        </ul>
    </div>

    <div class="block_content">

        <table cellpadding="0" cellspacing="0" width="100%" class="table table-striped">
            <thead>
                <tr>
                    <th style="width:20px;">&nbsp;</th>
                    <th style="width:40px;" <cfif params.order EQ "type">class="headersort#params.sort#"</cfif>>#linkTo(text="Type", params="order=type&sort=#params.asort#")#</th>
                    <th <cfif params.order EQ "email">class="headersort#params.sort#"</cfif>>#linkTo(text="User", params="order=email&sort=#params.asort#")#</th>
                    <th <cfif params.order EQ "modelcode">class="headersort#params.sort#"</cfif>>#linkTo(text="Object", params="order=modelcode&sort=#params.asort#")#</th>
                    <th>Packet</th>
                    <th style="width:120px;" <cfif params.order EQ "createdAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Moment", params="order=createdAt&sort=#params.asort#")#</th>
                    <td style="width:40px;">&nbsp;</td>
                </tr>
            </thead>
            <tbody>
            <cfloop query="currentChanges">
                <tr <cfif currentChanges.currentRow MOD 2>class="even"</cfif>>
                    <td>#currentChanges.currentRow#)</td>
                    <td title="#iif(currentChanges.type EQ 'r', De('Data replaced'), De('Data deleted'))#">#UCase(currentChanges.type)#</td>
                    <td class="nowrap"><cfif currentChanges.email NEQ "">#HTMLEditFormat(currentChanges.email)#<cfelse>[deleted user]</cfif></td>
                    <td>#HTMLEditFormat(currentChanges.modelcode)#-#currentChanges.modelid#</td>
                    <td style="overflow:hidden;">#HTMLEditFormat(Replace(currentChanges.packet, ',', ', ', 'ALL'))#</td>
                    <td class="nowrap">#formatDateTimeCompact(currentChanges.createdAt)#</td>
                    <td class="nowrap">#linkTo(text="View", action="history-packet", key=currentChanges.id)#</td>
                </tr>
            </cfloop>
            <cfif currentChanges.recordCount EQ 0>
                <tr class="even">
                    <td colspan="7">No records found matching current criteria</td>
                </tr>
            </cfif>
            </tbody>
        </table>

        <div class="pagination right">
            #paginationLinksFull()#
        </div>

    </div>

    <div class="bendl"></div>
    <div class="bendr"></div>

</div>
</cfoutput>