import { LightningElement } from 'lwc';

export default class Tabset extends LightningElement {

    tabClick(e){
        const tabIndex = e.currentTarget.dataset.index;
        console.log(tabIndex);
        const activeTab = this.template.querySelector('ul>li.slds-is-active');
        activeTab.classList.remove("slds-is-active");
        e.currentTarget.classList.add('slds-is-active');
    }
}