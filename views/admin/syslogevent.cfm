<cfoutput>
<table cellpadding="0" cellspacing="0" class="table table-striped">
    <tbody>
        <tr>
            <th style="width:100px;">Page:</th>
            <td>#HTMLEditFormat(currentEvent.action)#</td>
        </tr>
        <tr>
            <th>User:</th>
            <td>
                <cfif isObject(currentEventUser)>
                #currentEventUser.id#)
                #HTMLEditFormat(currentEventUser.email)# -
                #HTMLEditFormat(currentEventUser.firstName)# #HTMLEditFormat(currentEventUser.lastName)#
                of #HTMLEditFormat(currentEventAccount.name)#
                <cfelse>
                [deleted user]
                </cfif>
            </td>
        </tr>
        <tr>
            <th>Type:</th>
            <td>#getLogTypeText(currentEvent.type)#</td>
        </tr>
        <tr>
            <th>Moment:</th>
            <td>#formatDateTime(currentEvent.createdAt)#</td>
        </tr>
        <tr>
            <th>Remote IP:</th>
            <td>#currentEvent.remoteIp#</td>
        </tr>
        <tr>
            <th>Message:</th>
            <td>#HTMLEditFormat(currentEvent.message)#</td>
        </tr>
        <tr class="noline">
            <th>Details:</th>
            <td>#HTMLEditFormat(currentEvent.detail)#</td>
        </tr>
    </tbody>
</table>
</cfoutput>