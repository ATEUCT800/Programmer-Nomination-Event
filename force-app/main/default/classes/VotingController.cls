public with sharing class VotingController {
    
    @AuraEnabled (cacheable = true)
    public static List<Contact> getContactList(String queryTerm, Id nominationId) {
        String queryTermForSOQL = '%' + queryTerm + '%';
        List<CandidateNomination__c> cnWithCurrentNomination = [SELECT Nominees__c FROM CandidateNomination__c WHERE NominationId__c = :nominationId AND Type__c = 'Master'];
        Set<Id> nominees = new Set<Id>();
        for(CandidateNomination__c itemCN : cnWithCurrentNomination){
            nominees.add(itemCN.Nominees__c);
        }
        List<Contact> contacts = [SELECT FirstName, LastName, Department FROM Contact WHERE Id IN :nominees AND (FirstName LIKE :queryTermForSOQL OR LastName LIKE :queryTermForSOQL)];
        return contacts;
    }

    @AuraEnabled(cacheable=true)
    public static List<Nomination__c> getNominationList(Id campaign){
        List<Nomination__c> nominations = [SELECT Id, Name FROM Nomination__c WHERE CampaignId__c = :campaign];
        return nominations;
    }

    @AuraEnabled(cacheable=true)
    public static List<Campaign> getCampaignList(){
        return [SELECT Id, Name FROM Campaign WHERE Type = 'Voting'  AND IsActive = true];
    }


    private static Id getVoter(String email){
        Contact voter = [SELECT Id FROM Contact WHERE Email = :email];
        return voter.Id;
    }

    @AuraEnabled
    public static void createVote(Id nominationId, Id contactId, String email) {
        Id voterId = getVoter(email);
        CandidateNomination__c  nominee  = [SELECT Id FROM CandidateNomination__c WHERE NominationId__c = :nominationId AND Nominees__c = :contactId AND Type__c = 'Master'];
        Vote__c newVote = new Vote__c(VoterId__c = voterId, CandidateNominationId__c = nominee.Id);
        insert newVote;
    }
}