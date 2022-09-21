public with sharing class NotificationPanelController {
    @AuraEnabled(cacheable=true)
    public static Info[] getInfoData(){
        User currentUser = [SELECT Id, Name, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        Info[] infos = new List<Info>();
        
        Map<String, List<Notification__c>> notificationMap = new Map<String, List<Notification__c>>();
        for(Notification__c notification : [SELECT Id, Name, Description__c, Type__c, 
                                                (SELECT Id 
                                                FROM Restricted_User__r 
                                                WHERE User__c = :currentUser.Id)
                                            FROM Notification__c
                                            WHERE Expiration_Date__c > TODAY
                                            AND Delivered_To__c INCLUDES (:currentUser.Profile.Name)
                                            ]){
            if(notification.Restricted_User__r.isEmpty()){
                if(notificationMap.containsKey(notification.Type__c)){
                    notificationMap.get(notification.Type__c).add(notification);
                }
                else{
                    notificationMap.put(notification.Type__c, new List<Notification__c>{notification});
                }
            }
            
        }

        for(String type : notificationMap.keySet()){
            Info info = new Info();
            info.type = type;
            info.notifications = new List<Notification>();
            for(Notification__c notif : notificationMap.get(type)){
                Notification notification = new Notification();
                notification.title = notif.Name;
                notification.description = notif.Description__c;
                notification.id = notif.Id;
                notification.url = '/lightning/r/Notification__c/'+notif.Id+'/view';
                info.notifications.add(notification);
            }
            info.count = info.notifications.size();
            infos.add(info);
        }
        return infos;
    }

    public class Info{
        @AuraEnabled
        public String type;
        @AuraEnabled
        public Notification[] notifications;
        @AuraEnabled
        public Integer count;
    }
    public class Notification{
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String description;
        @AuraEnabled 
        public String id;
        @AuraEnabled 
        public String url;
    }
}