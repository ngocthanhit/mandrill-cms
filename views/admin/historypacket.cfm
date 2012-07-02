<cfoutput>
<table cellpadding="0" cellspacing="0" class="table table-striped">
    <tbody>
        <tr>
            <th style="width:100px;">Type:</th>
            <td>#iif(currentChange.type EQ 'r', De('Data replaced'), De('Data deleted'))#</td>
        </tr>
        <tr>
            <th>Object:</th>
            <td>#HTMLEditFormat(currentChange.modelcode)# ###currentChange.modelid#</td>
        </tr>
        <tr>
            <th>User:</th>
            <td>
                <cfif isObject(currentChangeUser)>
                #currentChangeUser.id#)
                #HTMLEditFormat(currentChangeUser.email)# -
                #HTMLEditFormat(currentChangeUser.firstName)# #HTMLEditFormat(currentChangeUser.lastName)#
                of #HTMLEditFormat(currentChangeAccount.name)#
                <cfelse>
                [deleted user]
                </cfif>
            </td>
        </tr>
        <tr>
            <th>Moment:</th>
            <td>#formatDateTime(currentChange.createdAt)#</td>
        </tr>
        <tr class="noline">
            <th style="vertical-align:top;">Packet dump:</th>
            <td colspan="2"><cfdump var="#DeserializeJSON(currentChange.packet)#" /></td>
        </tr>
    </tbody>
</table>
</cfoutput>