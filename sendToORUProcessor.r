# Call with
#
# irule -F sendToORUProcessor.r "*mirthURL='http://fhml-srv024.unimaas.nl:6667',*token='fragile-field',*project='P000000001',*collection='C00000001'"
#


sendToORUProcessor(*mirthURL,*token,*project,*collection) {
    *srcColl = /nlmumc/ingest/zones/*token;
    *delete = 0;
    
    # Determine REPEAT count
    # *ORURepCounter = "0";
    # foreach (*av in SELECT META_COLL_ATTR_NAME, META_COLL_ATTR_VALUE WHERE COLL_NAME == "*srcColl") {
    #     if ( *av.META_COLL_ATTR_NAME == "ORURepCounter" ) {
    #         *ORURepCounter = *av.META_COLL_ATTR_VALUE;
    #         if (int(*ORURepCounter) >= 10) {
    #             # This must be a legacy counter from a previous ingest attempt.
    #             msiAddKeyVal(*delKV, *av.META_COLL_ATTR_NAME, *av.META_COLL_ATTR_VALUE);
    #             msiRemoveKeyValuePairsFromObj(*delKV,*srcColl, "-C");
    #             *ORURepCounter = "0";
    #             msiWriteRodsLog("Removed legacy ORURepCounter that originated from previous ingest attempt.", 0);
    #         }
    #     }
    # }

    # Determine if AVU's that are going to be set via REST-operation need to be deleted first
    # This does not apply to AVU's that are being set by msiSetKeyValuePairsToObj, since the msi can also perform a 'modify'
    #foreach (*av in SELECT META_COLL_ATTR_NAME, META_COLL_ATTR_VALUE WHERE COLL_NAME == "*srcColl") {
        # if ( *av.META_COLL_ATTR_NAME == "oruState" ) {
        #     msiAddKeyVal(*delKV, *av.META_COLL_ATTR_NAME, *av.META_COLL_ATTR_VALUE);
        #     *delete = *delete + 1;
        # }
        # if ( *av.META_COLL_ATTR_NAME == "oruWarningMsg" ) {
        #     msiAddKeyVal(*delKV, *av.META_COLL_ATTR_NAME, *av.META_COLL_ATTR_VALUE);
        #     *delete = *delete + 1;
        # }
    #}

    # if (*delete > 0){
    #    msiRemoveKeyValuePairsFromObj(*delKV,*srcColl, "-C");
    #    msiWriteRodsLog("Removed existing AVU from *srcColl", 0);
    # }
    
    msiWriteRodsLog("Request ORU-retrieval at *mirthURL", 0);
    *error = errorcode(msi_http_send_file("*mirthURL/?token=*token&project=*project&collection=*collection", "/nlmumc/ingest/zones/*token/a_virtualslides.csv"));

    # if ( *error < 0 ) {
    #     *newCounter = int(*ORURepCounter) + 1;
    #     msiAddKeyVal(*metaKV, "ORURepCounter", str(*newCounter));
    #     msiSetKeyValuePairsToObj(*metaKV, *srcColl, "-C");
    #     failmsg(-1, "Error with ORU processor channel")
    # }else{
    #     foreach (*av in SELECT META_COLL_ATTR_NAME, META_COLL_ATTR_VALUE WHERE COLL_NAME == "*srcColl") {
    #         # Determine if there is a RepCounter and delete it, in order to let ingestNestedDelay1-rule know that it may continue
    #         if ( *av.META_COLL_ATTR_NAME == "ORURepCounter" ) {
    #             msiAddKeyVal(*delKV, *av.META_COLL_ATTR_NAME, *av.META_COLL_ATTR_VALUE);
    #             msiRemoveKeyValuePairsFromObj(*delKV,*srcColl, "-C");
    #             msiWriteRodsLog("Validation channel has been reached before attempt 10. Deleting ORURepCounter AVU...", 0);
    #         }
    #     }
    # }
}

INPUT *mirthURL='',*token='',*project='',*collection=''
OUTPUT ruleExecOut
