public with sharing class NominationCreationController {
    public NominationCreationController() {
    }

    @AuraEnabled(cacheable=true)
    public static List<Campaign> getCampaignList(){
        return [SELECT Id, Name FROM Campaign];
    }

    private static Boolean isNominationAlreadyExist(Campaign campaign, String nominationName){
        List<Nomination__c> allNominationInCampaign = [SELECT Name FROM Nomination__c WHERE CampaignId__c = :campaign.Id ];
        for(Nomination__c nominationItem : allNominationInCampaign){
            if(nominationItem.Name.equals(nominationName)){
                System.debug('If worked!');
                return true;
            }
        }
        System.debug('If not worked!');
        return false;
    }

    @AuraEnabled
    public static void createNomination (Id campaignId, String nominationName){
        // Boolean flag ;
        // List<Nomination__c> allNominationInCampaign = [SELECT Name FROM Nomination__c WHERE CampaignId__c = :campaign.Id ];
        // for(Nomination__c nominationItem : allNominationInCampaign){
        //     if(nominationItem.Name.equals(nominationName)){
        //         System.debug('If worked!');
        //         flag = true;
        //     }
        // }
        

        System.debug(campaignId + '\n'+ nominationName);
        // if(!isNominationAlreadyExist(campaign,nominationName)){
        //     Nomination__c newNomination = new Nomination__c(Name = nominationName, CampaignId__c = campaign.Id);
        //     insert newNomination;
        // }
        // else {
        //     //throw new CalloutException('Nomination already exists!');
        // }

        Nomination__c newNomination = new Nomination__c();
        newNomination.Name = nominationName;
        newNomination.CampaignId__c = campaignId;
        insert newNomination;
    }
}
