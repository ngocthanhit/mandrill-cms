component displayname="GoCardless" hint="GoCardless API v1 wrapper" {


	/*
     * Version 0.9 — July 20, 2012
     * API docs: https://gocardless.com/docs/api_guide/
     */


    /*
     * TODO:
     * - Check compatibility with CF9.
     * - Prepare usage examples and README.
     */


	variables.appid = "";
    variables.appsecret = "";
    variables.merchantid = "";
    variables.merchantaccesstoken = "";
    variables.apiurl = "";
    variables.environment = "";
    variables.useragent = "";
    variables.verbose = false;


    /*
     * @appid GoCardless App Id
     * @appsecret GoCardless App secret
     * @merchantid GoCardless Merchant Id
     * @merchantaccesstoken GoCardless Merchant access token
     * @environment The environment: sandbox or live
     * @useragent Custom useragent for HTTP requests
     * @verbose Append extended info to the output
     */
    public any function init(
        required string appid,
        required string appsecret,
        required string merchantid,
        required string merchantaccesstoken,
        string environment = "live",
        string useragent = server.ColdFusion.ProductName,
        boolean verbose = false
    )
    hint="Component initialization" {

        setAppId(arguments.appid);
        setAppSecret(arguments.appsecret);
        setMerchantId(arguments.merchantid);
        setMerchantAccessToken(arguments.merchantaccesstoken);
        setEnvironment(arguments.environment);
        setUserAgent(arguments.useragent);
        setVerbose(arguments.verbose);

        return this;

    }


    public void function setAppId(required string appid) hint="Set current App Id setting" {
        variables.appid = arguments.appid;
    }


    public string function getAppId() hint="Get current App Id setting" {
        return variables.appid;
    }


    public void function setAppSecret(required string appsecret) hint="Set current App Secret setting" {
        variables.appsecret = arguments.appsecret;
    }


    public string function getAppSecret() hint="Get current App Secret setting" {
        return variables.appsecret;
    }


    public void function setMerchantId(required string merchantid) hint="Set current Merchant Id setting" {
        variables.merchantid = arguments.merchantid;
    }


    public string function getMerchantId() hint="Get current Merchant Id setting" {
        return variables.merchantid;
    }


    public void function setMerchantAccessToken(required string merchantaccesstoken) hint="Set current Merchant Access Token setting" {
        variables.merchantaccesstoken = arguments.merchantaccesstoken;
    }


    public string function getMerchantAccessToken() hint="Get current Merchant Access Token setting" {
        return variables.merchantaccesstoken;
    }


    public void function setApiUrl(required string apiurl) hint="Set current API URL setting" {
        variables.apiurl = arguments.apiurl;
    }


    public string function getApiUrl() hint="Get current API URL setting" {
        return variables.apiurl;
    }


    /*
     * @environment working environment: sandbox or live
     */
    public void function setEnvironment(required string environment) hint="Set current environment setting" {
        
    	var local = {};
    	local.accept = "sandbox,live";

    	if(ListFind(local.accept, arguments.environment)) {

    		if(Compare(arguments.environment, "live") EQ 0) {
    			setApiUrl("https://gocardless.com");
    		}
    		else {
    			setApiUrl("https://sandbox.gocardless.com");
    		}

    		variables.environment = arguments.environment;

    	}
    	else {

    		setApiUrl("https://sandbox.gocardless.com");
    		variables.environment = "sandbox";

    	}
        
    }


    public string function getEnvironment() hint="Get current environment setting" {
        return variables.environment;
    }


    public void function setUserAgent(required string useragent) hint="Set current useragent setting" {
        variables.useragent = arguments.useragent;
    }


    public string function getUserAgent() hint="Get current useragent setting" {
        return variables.useragent;
    }


    public void function setVerbose(required boolean verbose) hint="Set current verbose setting" {
        variables.verbose = arguments.verbose;
    }


    public boolean function getVerbose() hint="Get current verbose setting" {
        return variables.verbose;
    }


    


    /*
     * UTILS
     */



    /*
     * @src source string to encode
     * @key key for generate digest
     */
    private string function hmacSHA256(required string src, required string key) 
    hint="Generate digest using HMAC-SHA256 algorithm" {

        var local = {};
     
        local.secret = createObject('java', 'javax.crypto.spec.SecretKeySpec' ).Init(arguments.key.GetBytes(), 'HmacSHA256');
        local.mac = createObject('java', "javax.crypto.Mac");
        local.mac = local.mac.getInstance("HmacSHA256");
        mac.init(local.secret);
        local.resultArray = mac.doFinal(arguments.src.GetBytes());
        local.result = ""

        // convert to hex
        local.result = Lcase(BinaryEncode(local.resultArray, "hex"));


        return local.result;

    }


    /*
     * @params source structure with keys for search
     * @methodName method name which caused it
     * @requiredParams list of required keys
     */
    private void function validateRequiredParams(required struct params, required string methodName, required string requiredParams) 
    hint="Searching required parameters in @params and throws error if not exist" {

        var local = {};

        for(local.i = 1; local.i <= ListLen(arguments.requiredParams); local.i++) {

            if(NOT StructKeyExists(arguments.params, listGetAt(arguments.requiredParams, local.i))) {
                throw(message="Argument '#listGetAt(arguments.requiredParams, local.i)#' is required for '#arguments.methodName#' method");
            }

        }

    }



    private string function generateNonce()
    hint="Generate random string using SHA-256 algorithm" {
        return Hash(CreateUUID(), "SHA-256");
    }



    /*
     * @params the specific parameters for payment
     * @pairs pairs of key - value
     * @namespace the namespace
     *
    */
    private any function generateQueryString(required any params, array pairs = array(), string namespace = "") 
    hint="Normalizing params, sorting, and converting to string to fit API requirements" {

        var local = {};


        if(NOT IsSimpleValue(arguments.params)) {

            for (local.key in arguments.params) {

                if(NOT IsSimpleValue(local.key)) {
                    arguments.pairs = generateQueryString(local.key, arguments.pairs, arguments.namespace & "[]");
                }
                else {
                    arguments.pairs = generateQueryString(arguments.params[local.key], arguments.pairs, arguments.namespace NEQ "" ? arguments.namespace & "[#local.key#]" : local.key);
                }

            }

            if(arguments.namespace NEQ "") {
                return arguments.pairs;
            }
            

            if(ArrayIsEmpty(arguments.pairs)) {
                return "";
            }


            for (local.i = 1; local.i <= ArrayLen(arguments.pairs); local.i++) {
                arguments.pairs[local.i] = ArrayToList(arguments.pairs[local.i], "=");
            }

            ArraySort(arguments.pairs, "text");
            local.result = ArrayToList(arguments.pairs, "&");

            // destroying variable
            arguments.pairs = JavaCast( "null", 0 );

            return local.result;

        }
        else {

            // Adding new pair and encoding it to RFC 3986 format
            ArrayAppend(arguments.pairs, array(
                                        ReplaceList(urlEncodedFormat(arguments.namespace), "%2D,%2E,%5F,%7E", "-,.,_,~"), 
                                        ReplaceList(urlEncodedFormat(arguments.params), "%2D,%2E,%5F,%7E", "-,.,_,~")
                                )
            );

            return arguments.pairs;

        }

    }



    /*
     * @params source structure to generate signature
     * @key string variable which uses ak key to generate signature
     */
    private string function generateSignature(required struct params, required string key)
    hint="Generage signature for URL" {
        return hmacSHA256(generateQueryString(arguments.params), arguments.key);    
    }



    /*
     * @src source information that uses for generate signature and then compare it with existing
     */
    private boolean function validateSignature(required struct src)
    hint="Confirm whether a signature is valid" {
        return (Compare(generateSignature(arguments.src.data, arguments.src.key), arguments.src.signature) EQ 0 ? true : false);
    }



    /*
     * @filters values that uses for filter results
     * @allowed allowed values fot particular method
     */
    private string function generateFilterString(required struct filters, required string allowed)
    hint="Generate query string for filter results that depends on allowed values" {

        var local = {};
        local.result = "";

        for (local.key in arguments.filters) {

            if(find(local.key, arguments.allowed)) {
                local.result &= "#local.key#=#arguments.filters[local.key]#";
            }

        }

        if(local.result NEQ "") {
            local.result = "?" & local.result;
        }

        return local.result;

    }





    /*
     * INTERACTION WITH API
     */



    /*
     * @type URL type: bill, subscription or pre_authorization
     * @data the required specific parameters for new url
     * @optionalData optional parameters for new url
     */
    private string function getConnectURL(required string type, required struct data, struct optionalData = {})
     hint="Generates new payment URL for connects" {

        var local = {};

        local.acceptType = "bill,subscription,pre_authorization";
        local.accectOptionalData = "redirect_uri,cancel_uri,state";


        if(NOT listFind(local.acceptType, arguments.type)) {
            throw(message="Unsupported URL type");
        }

        local.endpoint = "/connect/#arguments.type#s/new?";

        // generate timestamp for new URL
        local.timestamp = DateFormat(Now(), "yyyy-mm-dd") & "T" & TimeFormat(Now(), "HH:mm:ss") & "Z";

        // prepare the request params

        local.body = {
            "connect" = {
                "merchant_id" = "#getMerchantId()#"
            },
            "client_id" = "#getAppId()#",
            "nonce" = "#generateNonce()#",
            "timestamp" = "#local.timestamp#"
        }

        // copy main data into body
        for (local.key in arguments.data) {

            if(isStruct(arguments.data[local.key]) AND local.key EQ "user") {
                local.body.connect[local.key] = StructCopy(arguments.data[local.key]);
            }
            else {
                local.body.connect[local.key] = arguments.data[local.key];
            }

        }

        // copy additiona data into body
        for (local.key in arguments.optionalData) {

            if(ListFind(local.accectOptionalData, local.key)) {
                local.body[local.key] = arguments.optionalData[local.key];
            }

        }

        // rename key 'connect' to fit API requirements
        local.body[arguments.type] = StructCopy(local.body.connect);
        StructDelete(local.body, "connect");

        // generate signature
        StructInsert(local.body, "signature", generateSignature(local.body, getAppSecret()));

   
        // generate URL
        local.result = "";
        local.result &= getApiUrl();
        local.result &= local.endpoint;
        local.result &= "#generateQueryString(local.body)#";

        return local.result; 

     }


    /*
     * @method request method: get, post or put
     * @accesspoint the access point to specified method
     * @data the required specific parameters to access specified method
     */
    private struct function requestAPI(required string method, required string accesspoint, required struct data)
     hint="Perform request to the API: invoke remote method and handle response" {


        var local = {};

        local.authorization = {};
        local.authorization.username = "";
        local.authorization.password = "";
        local.authorization.basic = "";

        local.output = {};


        if(StructKeyExists(arguments.data, "http_authorization")) {

            local.authorization.username = ListFirst(arguments.data.http_authorization, ":");
            local.authorization.password = ListLast(arguments.data.http_authorization, ":");
            StructDelete(arguments.data, "http_authorization");

        }
        else if(StructKeyExists(arguments.data, "http_bearer"))
        {

            local.authorization.basic = "Authorization: Bearer " & arguments.data.http_bearer;
            StructDelete(arguments.data, "http_bearer");

        }
        else {
            throw(message="Authorization information are required");
        }


        try {


            // communicate with API            

            http url="#getApiUrl()##arguments.accesspoint#" method="#arguments.method#"
                 username="#local.authorization.username#" password="#local.authorization.password#"
                 useragent=getUserAgent() result="local.result" {

                httpparam type="header" name="Accept" value="application/json";

                if(local.authorization.basic NEQ "") {
                    httpparam type="header" name="Authorization" value="#local.authorization.basic#";
                }

                if(NOT StructIsEmpty(arguments.data)) {

                    if(arguments.method eq "post") {

                        local.postParams = urlDecode(generateQueryString(arguments.data));
                        local.postParams = listToArray(local.postParams, "&");
                                
                        for(local.i = 1; local.i <= ArrayLen(local.postParams); local.i++) {
                            httpparam type="formField" name="#ListFirst(local.postParams[local.i], "=")#" value="#ListLast(local.postParams[local.i], "=")#";
                        }                         

                    }
                    else if(arguments.method eq "get") {
                        httpparam type="body" value=SerializeJSON(arguments.data);
                    }

                }


            }


            if (getVerbose()) {
                local.output.result = local.result;
            }


            // parse response and return data depending on results

            if (StructKeyExists(local.result, "filecontent") AND isJSON(local.result.filecontent)) {

                local.parsedResult = DeserializeJSON(local.result.filecontent);

                if (isStruct(local.parsedResult) AND StructKeyExists(local.parsedResult, "error")) {                    
                    throw(message=SerializeJSON(local.parsedResult.error));
                }
                else {
                    local.output.fault = false;
                    local.output.data = local.parsedResult;
                }

            }
            else if (StructKeyExists(local.result, "errordetail")) {
                throw(message="API communication failure. #local.result.errordetail#");
            }
            else {
                throw(message="API communication failure, or invalid response returned");
            }



        }
        catch (any local.exception) {

            local.output.fault = true;
            local.output.data = local.exception.Message;

            if (getVerbose()) {
                local.output.exception = local.exception;
            }

        }


        return local.output;

     }





    /*
     * API METHODS: CONNECT
     */



    /*
     * @data The parameters to generate URL
     * @optionalData The optional parameters to generate URL
     */     
    public string function getBillURL(required struct data, struct optionalData = {})
    hint="Generates new URL for one-off bills" {

        validateRequiredParams(arguments.data, "getBillURL", "amount");

        return getConnectURL("bill", arguments.data, arguments.optionalData);

    }



    /*
     * @data The parameters to generate URL
     * @optionalData The optional parameters to generate URL
     */
    public string function getSubscriptionURL(required struct data, struct optionalData = {})
    hint="Generates new URL for subscriptions" {

        validateRequiredParams(arguments.data, "getSubscriptionURL", "amount,interval_length,interval_unit");

        return getConnectURL("subscription", arguments.data, arguments.optionalData);

    }



    /*
     * @data The parameters to generate URL
     * @optionalData The optional parameters to generate URL
     */
    public string function getPreAuthorizationURL(required struct data, struct optionalData = {})
    hint="Generates new URL for Pre-authorizations" {

        validateRequiredParams(arguments.data, "getPreAuthorizationURL", "max_amount,interval_length,interval_unit");

        return getConnectURL("pre_authorization", arguments.data, arguments.optionalData);

    }



    /*
     * @data information from GoCardless to confirm new resource
     */ 
    public boolean function confirmResource(required struct data) 
    hint="Confirm resource and send a HTTP request to confirm the creation of a new payment resource" {

        var local = {};

        validateRequiredParams(arguments.data, "confirmResource", "resource_id,resource_type,signature");

        local.endpoint = "/api/v1/confirm";

        
        // Validate resource

        local.signature = arguments.data.signature;
        StructDelete(arguments.data, "signature");

        if( validateSignature({
                                    "data"      : "#arguments.data#",
                                    "key"       : "#getAppSecret()#",
                                    "signature" : "#local.signature#"
                               })  EQ false) {
            return false;
        }


        // Confirm resource

        local.confirmParams = {
            "resource_id" : "#arguments.data.resource_id#",
            "resource_type" : "#arguments.data.resource_type#",
            "http_authorization" : "#getAppId()#:#getAppSecret()#"
        }

        local.responce = requestAPI("post", local.endpoint, local.confirmParams);

        if(local.responce.fault EQ true) {            
            return false;
        }


        return true;

    }



    /*
     * @data information from GoCardless to validate new updates
     */
    public boolean function validateWebhook(required struct data) 
    hint="Validate the payload of a webhook" {

        var local = {};

        if(NOT StructKeyExists(arguments.data, "signature"))
            return false;

        local.signature = arguments.data.signature;
        StructDelete(arguments.data, "signature");

        return  validateSignature({
                                    "data"      : "#arguments.data#",
                                    "key"       : "#getAppSecret()#",
                                    "signature" : "#local.signature#"
                });


    }



    /*
     * @id MerchantID by which information is requested
     */
    public struct function getMerchant(required string id) 
    hint="Get merchant information by id" {

        return requestAPI(  "get", 
                            "/api/v1/merchants/#arguments.id#", 
                            { "http_bearer" : "#getMerchantAccessToken()#" }
                         );

    }


    /*
     * @id MerchantID by which information is requested
     */
    public struct function getMerchantUsers(required string id) 
    hint="Get users related to merchant by id" {

        return requestAPI(  "get", 
                            "/api/v1/merchants/#arguments.id#/users", 
                            { "http_bearer" : "#getMerchantAccessToken()#" }
                         );

    }


    /*
     * @id MerchantID by which information is requested
     * @filters specified parameters, used to cut down the number of objects
     */
    public struct function getMerchantSubscriptions(required string id, struct filters = {}) 
    hint="Get subscriptions related to merchant" {

        var local = {};
        local.filters = generateFilterString(arguments.filters, "user_id,before,after");
        local.accesspoint = "/api/v1/merchants/#arguments.id#/subscriptions#local.filters#";

        return requestAPI(  "get", 
                            local.accesspoint, 
                            { "http_bearer" : "#getMerchantAccessToken()#" }
                         );

    }


    /*
     * @id MerchantID by which information is requested
     * @filters specified parameters, used to cut down the number of objects
     */
    public struct function getMerchantPreAuthorizations(required string id, struct filters = {}) 
    hint="Get pre_authorizations related to merchant" {

        var local = {};
        local.filters = generateFilterString(arguments.filters, "user_id,before,after");
        local.accesspoint = "/api/v1/merchants/#arguments.id#/pre_authorizations#local.filters#";

        return requestAPI(  "get", 
                            local.accesspoint, 
                            { "http_bearer" : "#getMerchantAccessToken()#" }
                         );

    }


    /*
     * @id MerchantID by which information is requested
     * @filters specified parameters, used to cut down the number of objects
     */
    public struct function getMerchantBills(required string id, struct filters = {}) 
    hint="Get bills related to merchant" {

        var local = {};
        local.filters = generateFilterString(arguments.filters, "source_id,subscription_id,pre_authorization_id,user_id,before,after,paid");
        local.accesspoint = "/api/v1/merchants/#arguments.id#/bills#local.filters#";

        return requestAPI(  "get", 
                            local.accesspoint, 
                            { "http_bearer" : "#getMerchantAccessToken()#" }
                         );

    }


    /*
     * @id SubscriptionID by which information is requested
     */
    public struct function getSubscription(required string id) 
    hint="Get subscription information by id" {

        return requestAPI(  "get", 
                            "/api/v1/subscriptions/#arguments.id#", 
                            { "http_bearer" : "#getMerchantAccessToken()#" }
                         );

    }


    /*
     * @id SubscriptionID that need to be canceled
     */
    public struct function cancelSubscription(required string id) 
    hint="Cancel existing subscription" {

        return requestAPI(  "put", 
                            "/api/v1/subscriptions/#arguments.id#/cancel", 
                            { "http_bearer" : "#getMerchantAccessToken()#" }
                         );

    }



    /*
     * @id PreAuthorizationID by which information is requested
     */
    public struct function getPreAuthorization(required string id) 
    hint="Get pre_authorizations information by id" {

        return requestAPI(  "get", 
                            "/api/v1/pre_authorizations/#arguments.id#", 
                            { "http_bearer" : "#getMerchantAccessToken()#" }
                         );

    }



    /*
     * @id PreAuthorizationID that need to be canceled
     */
    public struct function cancelPreAuthorization(required string id) 
    hint="Cancel pre_authorizations subscription" {

        return requestAPI(  "put", 
                            "/api/v1/pre_authorizations/#arguments.id#/cancel", 
                            { "http_bearer" : "#getMerchantAccessToken()#" }
                         );

    }



    /*
     * @id BillID by which information is requested
     */
    public struct function getBill(required string id) 
    hint="Get bill information by id" {

        return requestAPI(  "get", 
                            "/api/v1/bills/#arguments.id#", 
                            { "http_bearer" : "#getMerchantAccessToken()#" }
                         );

    }



    /*
     * @data required information to create new bill under an existing pre-authorization
     */
    public struct function newBill(required struct data) 
    hint="Create bill via the API (under an existing pre-authorization)" {

        validateRequiredParams(arguments.data, "getPreAuthorizationURL", "amount,pre_authorization_id");

        return requestAPI(  "post", 
                            "/api/v1/bills", 
                            {
                                "bill" : StructCopy(arguments.data),
                                "http_bearer" : "#getMerchantAccessToken()#"
                            }
                         );

    }



}