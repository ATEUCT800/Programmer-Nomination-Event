public with sharing class ContentDocumentLinkTriggerTrH extends ITriggerHandler {
    // public void BeforeInsert(List<SObject> newItems){}
    public override void AfterInsert(Map<Id, SObject> newItems){
        List<ContentDocumentLink> contDocListAll = [SELECT ContentDocument.title, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE Id IN :newItems.keySet()];
        List<ContentDocumentLink> contDocList = new List<ContentDocumentLink>();
        Set<Id> contDocIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        for(ContentDocumentLink contDocItem : contDocListAll){
            if(String.valueOf(contDocItem.LinkedEntityId).startsWith('003') && contDocItem.ContentDocument.title.containsIgnoreCase('avatar')){
                contDocList.add(contDocItem);
                contactIds.add(contDocItem.LinkedEntityId);
                contDocIds.add(contDocItem.ContentDocumentId);
            }
        }
        if(!contDocList.isEmpty()){
            Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, FirstName, LastName, Department, Avatar__c FROM Contact WHERE Id IN :contactIds]);
            List<ContentVersion> contVerList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :contDocIds];//
            for(ContentDocumentLink contDocItem : contDocList){
                for(ContentVersion contVerItem : contVerList){
                    if(contVerItem.ContentDocumentId == contDocItem.ContentDocumentId && contactMap.containsKey(contDocItem.LinkedEntityId)){
                        Contact tempContact = contactMap.get(contDocItem.LinkedEntityId);
                        tempContact.Avatar__c = '/sfc/servlet.shepherd/version/download/' + contVerItem.Id;
                    }
                }
            }
            try{
                update contactMap.values();
                //add toastevent success
            } catch (DmlException de){
                throw new AuraHandledException(de.getDmlMessage(0));
            }
        }
    }
}
