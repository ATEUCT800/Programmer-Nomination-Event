public with sharing class VotingDataModel {
    @Auraenabled
    public Campaign currentCampaign;
    @Auraenabled
    public Map<Id, Nomination__c> nominationList;
    @Auraenabled
    public Map<Id, List<Contact>> nomineesInNomination;
    @Auraenabled
    public Map<Id, String> nomineesWithDescription;

    public VotingDataModel(Campaign currentCampaign, Map<Id, Nomination__c> nominationList, Map<Id, List<Contact>> nomineesInNomination, Map<Id, String> nomineesWithDescription) {
        this.currentCampaign = currentCampaign;
        this.nominationList = nominationList.clone();
        this.nomineesInNomination = nomineesInNomination.clone();
        this.nomineesWithDescription = nomineesWithDescription.clone();
    }
}