<cfoutput>
<html>
<style>
 td, div, p, li { font-family: Arial; color:##444444; }
 a { color:##008ee8; }
 ul { padding-left: 20px; }
 h2 { font-family: Arial; color: ##555555; font-size:13px; text-transform:uppercase; margin-top:10px; }
 h3 { font-family: Arial; color: ##555555; font-size:12px; text-transform:uppercase; margin-top:10px; }
 hr { border:1px solid ##e5e5e5; border-top:0; }
</style>
<body leftmargin="5" topmargin="5" bgcolor="##ffffff">

<table width="800" cellpadding="7" cellspacing="0">
<tr>
    <td>

        #includeContent()#

    </td>
</tr>
<tr>
    <td style="font-size:11px; color:##555555; padding-top:10px;">
        Sincerely,<br/>
        MandrillCMS Team<br/>
    </td>
</tr>
</table>

</body>
</html>
</cfoutput>