import { api, LightningElement } from 'lwc';

export default class NotificationTile extends LightningElement {
    @api item;
    @api index;
    @api type;
    clear(){
        console.log(this.index);
        const selectedEvent = new CustomEvent('cleared', { detail: {type : this.type, index: this.index} });
        this.dispatchEvent(selectedEvent);
    }
}