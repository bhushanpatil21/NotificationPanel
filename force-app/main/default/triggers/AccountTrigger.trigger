trigger AccountTrigger on Account (before insert) {
    for(Account acc : Trigger.new){
        acc.TSYS_Account_Name_PN__c = TSYS_PsudeonymizationUtil.generate(acc.Name);
    }
}