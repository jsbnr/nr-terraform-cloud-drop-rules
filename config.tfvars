#  minimum - drop INFO and DEBUG, ERROR - CRITICAL is kept. This is the standard level.
#  medium - drop INFO and DEBUG only, ERROR and CRITCAL allowed
#  high - drop INFO only, DEBUG, ERROR and CRITICAL allowed
#  maximum - drop nothing, all states allowed


dropRules = {
    high = [

            # Hard coded nrql example
            {
                account_id   = 6884052
                name        = "Drop INFO logs"
                description = "Drop INFO logs"
                action      = "drop_data"
                nrql        = "SELECT * FROM Log WHERE debugLevel ='INFO'" #legacy
                nrqlCloud    = "DELETE FROM Log WHERE debugLevel ='INFO'" #cloud
            },
            {
                account_id   = 6884052
                name        = "Drop INFO ATTR logs"
                description = "Drop INFO ATTR logs"
                action      = "drop_attributes"
                nrql        = "SELECT pointless, notrequired, duplicate FROM Log WHERE debugLevel ='INFOATTR'" #legacy
                nrqlCloud    = "DELETE pointless, notrequired, duplicate  FROM Log WHERE debugLevel ='INFOATTR'" #cloud
            },


            # Abstracted NRQL example
            {
                account_id   = 6884052
                name        = "Drop INFO logs"
                description = "Drop INFO logs"
              
                event_type = "Log" 
                filter = "debugLevel ='INFO'"
                attributes = [] # leave empty for whole record 
            },
            {
                account_id   = 6884052
                name        = "Drop INFO ATTR logs (constructed)"
                description = "Drop INFO ATTR logs (constructed)"
                
                event_type = "Log" 
                filter = "debugLevel ='INFO'"
                attributes = ["pointless", "notrequired", "duplicate"] #just these attributes
            }
    ],
    medium =  [
            {
                account_id   = 6884052
                name        = "Drop DEBUG logs"
                description = "Drop DEBUG logs"
                action      = "drop_data"
                nrql        = "SELECT * FROM Log WHERE debugLevel ='DEBUG'"
                nrqlCloud    = "DELETE FROM Log WHERE debugLevel ='DEBUG'"
            }
    ],
    minimum = [
            {
                account_id   = 6884052
                name        = "Drop ERROR logs"
                description = "Drop ERROR logs"
                action      = "drop_data"
                nrql        = "SELECT * FROM Log WHERE debugLevel ='ERROR'"
                nrqlCloud    = "DELETE FROM Log WHERE debugLevel ='ERROR'"
            }
    ]
}
