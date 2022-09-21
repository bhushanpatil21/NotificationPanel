import { LightningElement, wire } from 'lwc';
import getInfoData from '@salesforce/apex/NotificationPanelController.getInfoData';

export default class NotificationPanel extends LightningElement {
    infos;
    error;
    @wire(getInfoData)
    wiredNotifications({ error, data }) {
        if (data) {
            this.infos = data;
            this.error = undefined;

            
            

        } else if (error) {
            this.error = error;
            this.infos = undefined;
            console.log(error);
       }
    }
    
    handleNotificationClear(event){

        var type = event.detail.type;
        var index = event.detail.index;
        var infosTemp = JSON.parse(JSON.stringify(this.infos));
        for(var info of infosTemp){
            if(info.type == type){
                var notifications = info.notifications;
                notifications.splice(index, 1); 
                break;
            }
        } 
        
        this.infos = infosTemp;

        


    }
    
}