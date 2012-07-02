<cfoutput>
<div class="block">

    <div class="block_head">
        <div class="bheadl"></div>
        <div class="bheadr"></div>
        <h2>System Log Filters</h2>
    </div>

    <div class="block_content">

        #flashRender()#

        #startFormTag(action="syslog")#
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
            <select name="fpage" class="styled">
                <option value="">- all pages -</option>
            <cfloop query="pages">
                <option value="#pages.action#"<cfif params.fpage EQ pages.action> selected="selected"</cfif>>#pages.action#</option>
            </cfloop>
            </select>
        </div>
        <div class="floated">
            <select name="ftype" class="styled">
                <option value=""<cfif params.ftype EQ ""> selected="selected"</cfif>>- all types -</option>
                <option value="I"<cfif params.ftype EQ "I"> selected="selected"</cfif>>information</option>
                <option value="W"<cfif params.ftype EQ "W"> selected="selected"</cfif>>warnings</option>
                <option value="E"<cfif params.ftype EQ "E"> selected="selected"</cfif>>errors</option>
            </select>
        </div>

        <div class="clear" style="padding:4px;"></div>

        <div class="floated" style="width:75px;">&nbsp;</div>
        <div class="floated">
            #submitTag(class="submit small", name="apply", value="Apply")#
            #submitTag(class="submit small", name="reset", value="Reset")#
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
        <h2>System Log Events</h2>
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
                    <th <cfif params.order EQ "action">class="headersort#params.sort#"</cfif>>#linkTo(text="Page", params="order=action&sort=#params.asort#")#</th>
                    <th <cfif params.order EQ "email">class="headersort#params.sort#"</cfif>>#linkTo(text="User", params="order=email&sort=#params.asort#")#</th>
                    <th style="width:20px;">Type</th>
                    <th>Message</th>
                    <th style="width:100px;" <cfif params.order EQ "remoteIp">class="headersort#params.sort#"</cfif>>#linkTo(text="Remote IP", params="order=remoteIp&sort=#params.asort#")#</th>
                    <th style="width:120px;" <cfif params.order EQ "createdAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Moment", params="order=createdAt&sort=#params.asort#")#</th>
                    <td style="width:40px;">&nbsp;</td>
                </tr>
            </thead>
            <tbody>
            <cfloop query="currentEvents">
                <tr <cfif currentEvents.currentRow MOD 2>class="even"</cfif>>
                    <td>#currentEvents.currentRow#)</td>
                    <td>#HTMLEditFormat(currentEvents.action)#</td>
                    <td class="nowrap"><cfif currentEvents.email NEQ "">#HTMLEditFormat(currentEvents.email)#<cfelse>[deleted user]</cfif></td>
                    <td title="#getLogTypeText(currentEvents.type)#" style="color:###getLogTypeColor(currentEvents.type)#">#currentEvents.type#</td>
                    <td>#HTMLEditFormat(currentEvents.message)#</td>
                    <td>#currentEvents.remoteIp#</td>
                    <td class="nowrap">#formatDateTimeCompact(currentEvents.createdAt)#</td>
                    <td class="nowrap">#linkTo(text="View", action="syslog-event", key=currentEvents.id)#</td>
                </tr>
            </cfloop>
            <cfif currentEvents.recordCount EQ 0>
                <tr class="even">
                    <td colspan="8">No records found matching current criteria</td>
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