public with sharing class NotificationCreatorBatch{
    public NotificationCreatorBatch() {

    }
    public static void execute(){
        Notification__c[] notifs = new List<Notification__c>();
        for(Notification_Config__c config : [SELECT Id, Title__c, Description__c, Criteria__c, Source_Object__c,
                                            Duration_In_Days__c, Type__c, Delivered_To__c 
                                            FROM Notification_Config__c]){
            
            String query = 'SELECT Id FROM '+config.Source_Object__c+' WHERE '+config.Criteria__c;
            List<Contact> records = Database.query(query);
            
            for(Contact contact : records){
                Notification__c item = new Notification__c();
                item.Type__c        = config.Type__c;
                item.Name           = config.Title__c;
                item.Description__c = convertDesc(config.Description__c, contact);
                item.Delivered_To__c = config.Delivered_To__c;
                item.Expiration_Date__c = System.today().addDays((Integer)config.Duration_In_Days__c);
                notifs.add(item);
            }
        }

        INSERT notifs;
    }

    private static String convertDesc(String inputString, Contact record){
        String convertOutput;
        Pattern p = Pattern.compile('(\\{\\{.*?}})');      
        Matcher m = p.matcher(inputString);
            while (m.find() == true) {   
                System.debug('found :: '+m.group(0));
                System.debug('found :: '+m.group(1));

                convertOutput = m.replaceFirst('#' + 'AAA' + '#');
                inputString = convertOutput;
            } 
        return convertOutput;
    }
}
