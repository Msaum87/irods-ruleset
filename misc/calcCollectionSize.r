# This rule will calculate the total size of a collection (folder) in iRODS
# WARNING: This can become very compute expensive!
# AVOID this rule whenever possible and use the getCollectionSize rule instead!
# 
# Call with
#
# irule -F calcCollectionSize.r "*collection='/nlmumc/projects/P000000001/'" "*unit='GiB'" "*round='ceiling'"
# 
# Rounding options
# *round='none' returns float with decimals
# *round='ceiling' returns integer rounded up 
# *round='floor' returns integer rounded down 

irule_dummy() {
    IRULE_calcCollectionSize(*collection, *unit, *round, *result);
    writeLine("stdout", *result);
}

IRULE_calcCollectionSize(*collection, *unit, *round, *result) {
    *sizeBytes = "0";

    foreach ( *Row in SELECT SUM(DATA_SIZE) WHERE COLL_NAME like "*collection%" AND DATA_REPL_NUM ="0") {
        *sizeBytes = *Row.DATA_SIZE;

        if ( *unit == "B" ) {
            *size = double(*sizeBytes);
        } else if ( *unit == "KiB" ) {
            *size = double(*sizeBytes)/1024;
        } else if ( *unit == "MiB" ) {
            *size = double(*sizeBytes)/1024/1024;
        } else if ( *unit == "GiB" ) {
            *size = double(*sizeBytes)/1024/1024/1024;
        } else if ( *unit == "TiB" ) {
            *size = double(*sizeBytes)/1024/1024/1024/1024;
        } else {
            failmsg(-1, "Invalid input for 'unit'. Options are: B | KiB | MiB | GiB | TiB");
        }
    }

    # Do the rounding
    if ( *unit == "B" ) {
        *result = str(*sizeBytes);
    } else {
        if ( *round == "none") {
            *size = *size;
        } else if ( *round == "floor") {
            *size = floor(*size);
        } else if ( *round == "ceiling") {
            *size = ceiling(*size);
        } else {
            failmsg(-1, "Invalid input for 'round'. Options are: none | floor | ceiling");
        }
        *result = str(*size);
    }

}

INPUT *collection="",*unit="",*round=""
OUTPUT ruleExecOut