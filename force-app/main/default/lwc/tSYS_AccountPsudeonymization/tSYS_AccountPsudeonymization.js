import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
//2. Import the named import updateRecord
import { updateRecord } from "lightning/uiRecordApi";

const FIELDS = [
    'Account.TSYS_Account_Name_PN__c',
    'Account.Name'
];

export default class TSYS_AccountPsudeonymization extends LightningElement {
    @api recordId;
    unsaved = false;
    accountName;
    accountName_pn;

    @wire(getRecord, {
        recordId: "$recordId",
        fields: FIELDS
    }) wireaccount({error, data}) {
        if (error) {
           this.error = error ; 
        } else if (data) {
            console.log(data);
            this.accountName = data.fields.TSYS_Account_Name_PN__c.value;
            if(this.accountName == null){
                this.accountName = data.fields.Name.value;
            }
            this.accountName_pn = this.accountName;
        }
    }

    generateNew(event){
        this.unsaved = true;
        this.accountName_pn = this.generate(this.accountName_pn);
    }
    
    handleSave(event){

        const fields = {};
        fields['Id'] = this.recordId;
        fields['TSYS_Account_Name_PN__c'] = this.accountName_pn;
        const recordInput = {
            fields: fields
        };

        updateRecord(recordInput).then((record) => {
            console.log(record);
            this.unsaved = false;
        });
        
    }
    handleCancel(event){
        this.accountName_pn = this.accountName;
        this.unsaved = false;
    }
    generate(inputString) {
        let output = '';
       for( let word of inputString.split(' ')){
            output += this.convert(word)+' ';
       }
       output = output.trim();
       return output;
    }

    convert(inputString){
        let numbersArray = inputString.split('');
        let output = [numbersArray[0]];
        while(numbersArray.length > 2 ){
            let randomIndex = this.getRandomNumber(1, numbersArray.length - 2);
            output.push(numbersArray[randomIndex]);
            numbersArray.splice(randomIndex, 1);
        }
        output.push(numbersArray[numbersArray.length-1]);
        return output.join('');
    }
    getRandomNumber(min, max) {
        let totalEle = max - min + 1;
        let result = Math.floor(Math.random() * totalEle) + min;
        return result;
    }

}