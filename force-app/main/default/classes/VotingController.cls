public with sharing class VotingController {

    @AuraEnabled
    public static VotingDataModel getFullInfo(String voterUUID) {                                                
        Id voterId = getVoter(voterUUID);
        List<Vote__c> alreadyVotedVotes = [SELECT CandidateNominationId__r.NominationId__c FROM Vote__c WHERE VoterId__c = :voterId];
        Set<Id> alreadyVotedNominations = new Set<Id>();
        for(Vote__c voteItem : alreadyVotedVotes){
            alreadyVotedNominations.add(voteItem.CandidateNominationId__r.NominationId__c);
        }
        Campaign currentCampaign = getCurrentCampaign();
        Map<Id, Nomination__c> nominations = new Map<Id, Nomination__c>([SELECT Id, Name, Avatar__c FROM Nomination__c WHERE CampaignId__c = :currentCampaign.Id AND Id NOT IN :alreadyVotedNominations]);
        Map<Id, List<Contact>> nomineesInNomination = getContactList(nominations.values());
        Map<Id, String> nomineesWithDescription = getDescription(nominations.values());
        VotingDataModel votingDataModel = new VotingDataModel(currentCampaign, nominations, nomineesInNomination, nomineesWithDescription);
        return votingDataModel;
    }

    @AuraEnabled
    public static Map<Id, List<Contact>> getContactList(List<Nomination__c> nominations) {                                                
        List<CandidateNomination__c> cnWithCurrentNomination = [SELECT Id, NominationId__c, Nominees__c FROM CandidateNomination__c WHERE NominationId__c in :nominations AND Type__c = 'Master']; 
        Set<Id> nominees = new Set<Id>();
        for(CandidateNomination__c itemCN : cnWithCurrentNomination){
            nominees.add(itemCN.Nominees__c);
        }
        Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, FirstName, LastName, Department, Avatar__c FROM Contact WHERE Id IN :nominees]);
        Map<Id, List<Contact>> nomineesInNomination = new Map<Id, List<Contact>>();
        for(Nomination__c nominationItem : nominations){
            List<Contact> nomineesForNomination = new List<Contact>();
            for(CandidateNomination__c itemCN : cnWithCurrentNomination){
                if(itemCN.NominationId__c == nominationItem.Id){
                    nomineesForNomination.add(contactMap.get(itemCN.Nominees__c));
                }
            }
            nomineesInNomination.put(nominationItem.Id, nomineesForNomination);
        }
        return nomineesInNomination;
    }

    @AuraEnabled
    public static List<Nomination__c> getNominationList(Id campaign){
        List<Nomination__c> nominations = [SELECT Id, Name, Avatar__c FROM Nomination__c WHERE CampaignId__c = :campaign];
        return nominations;
    }

    @AuraEnabled
    public static Campaign getCurrentCampaign(){
        Campaign campaignC =  [SELECT Id, Name FROM Campaign WHERE Type = 'Voting'  AND IsActive = true LIMIT 1];
        return campaignC;
    }


    private static Id getVoter(String UUID){
        try{
            Contact voter = [SELECT Id FROM Contact WHERE UUID__c = :UUID];
            return voter.Id;
        } catch (QueryException qe){
            throw new AuraHandledException('User with such email doesn\'t exist');
        }
        
    }

    @AuraEnabled
    public static void createVote(Map<Id, Id> finalVotes, String UUID) {
        if(finalVotes.isEmpty()){
            throw new AuraHandledException('Please select at least one nominee!');
        }
        Id voterId = getVoter(UUID);
        List<CandidateNomination__c>  nominees  = [SELECT Id, NominationId__c, Nominees__c FROM CandidateNomination__c WHERE NominationId__c in :finalVotes.keySet() AND Nominees__c in :finalVotes.values() AND Type__c = 'Master'];
        List<Vote__c> votes = new List<Vote__c>();
        for(CandidateNomination__c cnItem : nominees){
            if(cnItem.Nominees__c == finalVotes.get(cnItem.NominationId__c)){
                votes.add(new Vote__c(VoterId__c = voterId, CandidateNominationId__c = cnItem.Id));
            }
        }
        try{
            insert votes;
        } catch (DmlException de){
            throw new AuraHandledException(de.getDmlMessage(0));
        }
    }

    @AuraEnabled
    public static Map<Id, String> getDescription(List<Nomination__c> nominationList){
        List<CandidateNomination__c> listCN = [SELECT Id, Description__c, Nominees__c FROM CandidateNomination__c WHERE NominationId__c IN :nominationList AND Type__c = 'Master'];
        Map<Id, String> contactDiscritionMap = new Map<Id, String>();
        for(CandidateNomination__c cnItem : listCN){
            contactDiscritionMap.put(cnItem.Nominees__c, cnItem.Description__c);
        }
        return contactDiscritionMap;     
    }
}