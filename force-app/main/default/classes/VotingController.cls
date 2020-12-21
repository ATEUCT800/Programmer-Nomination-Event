public with sharing class VotingController {
    
    @AuraEnabled
    public static List<Contact> getContactList(List<Nomination__c> nominations) {                                                
        List<CandidateNomination__c> cnWithCurrentNomination = [SELECT NominationId__c, Nominees__r.FirstName, Nominees__r.LastName, Nominees__r.Department FROM CandidateNomination__c WHERE NominationId__c in :nominations AND Type__c = 'Master'];

        // Map<Id, List<Id>> cnWithCurrentNomination = [SELECT NominationId__c, Nominees__c FROM CandidateNomination__c WHERE NominationId__c in :nominations AND Type__c = 'Master'];
        for(CandidateNomination__c cnItem : cnWithCurrentNomination){
            System.debug('cnWithCurrentNomination: ' + cnItem.Nominees__c);
        }
        // Set<Id> nominees = new Set<Id>();
        // for(CandidateNomination__c itemCN : cnWithCurrentNomination){
        //     nominees.add(itemCN.Nominees__c);
        // }
        // List<Contact> contacts = [SELECT FirstName, LastName, Department FROM Contact WHERE Id IN :nominees];
        // System.debug('contacts: ' + contacts);
        // return contacts;

        
        Map<Id, List<Contact>> nomineesIdInNomination = new Map<Id, List<Contact>>();
        for(Nomination__c nominationItem : nominations){
            List<Contact> nominees = new List<Contact>();
            for(CandidateNomination__c itemCN : cnWithCurrentNomination){
                if(itemCN.NominationId__c == nominationItem.Id){
                    nominees.add(itemCN.Nominees__c);
                }
            }
            nomineesIdInNomination.put(nominationItem.Id, nominees);
        }
        //(SELECT FirstName, LastName, Department FROM Nominees__r)
        // Map<Id, List<Contact>> nomineesInNomination = [SELECT NominationId__c, Nominees__r.FirstName, Nominees__r.LastName, Nominees__r.Department  FROM CandidateNomination__c WHERE NominationId__c IN :nominations];
        // System.debug('nomineesInNomination: ', nomineesInNomination);
        // Map<Id, List<Contact>> nomineesInNomination = [SELECT Nomination__c.Id, (SELECT FirstName, LastName, Department FROM Contact WHERE Id IN :nomineesIdInNomination.get(Nomination__c.Id)) FROM Nomination__c];
        // Map<Id, List<List<String>>> nomineesIdInNomination = new Map<Id, List<List<String>>>();
        // for(Nomination__c nominationItem : nominations){
        //     List<Contact> nominees = new List<Contact>();
        //     for(CandidateNomination__c itemCN : cnWithCurrentNomination){
        //         if(itemCN.NominationId__c == nominationItem.Id){
        //             nominees.add(itemCN.Nominees__c);
        //         }
        //     }
        //     nomineesIdInNomination.put(nominationItem.Id, nominees);
        // }
        //         contacts.add([cnItem.Nominees__c, cnItem.Nominees__r.FirstName, cnItem.Nominees__r.LastName, cnItem.Nominees__r.Department])
        List<Contact> contacts = [SELECT FirstName, LastName, Department FROM Contact WHERE FirstName = 'Andy'];
        // System.debug('contacts: ' + contacts);
        // return contacts;
        return contacts;
    }

    @AuraEnabled
    public static List<Nomination__c> getNominationList(Id campaign){
        System.debug('campaign: ' + campaign);
        List<Nomination__c> nominations = [SELECT Id, Name FROM Nomination__c WHERE CampaignId__c = :campaign];
        System.debug('nominations: ' + nominations);
        return nominations;
    }

    @AuraEnabled
    public static Campaign getCampaignList(){
        Campaign campaignC =  [SELECT Id, Name FROM Campaign WHERE Type = 'Voting'  AND IsActive = true][0];
        System.debug('campaignC: ' + campaignC);
        return campaignC;
    }


    private static Id getVoter(String email){
        Contact voter = [SELECT Id FROM Contact WHERE Email = :email];
        return voter.Id;
    }

    @AuraEnabled
    public static void createVote(Map<Id, Id> finalVotes, String email) {
        Id voterId = getVoter(email);
        List<CandidateNomination__c>  nominees  = [SELECT Id, NominationId__c, Nominees__c FROM CandidateNomination__c WHERE NominationId__c in :finalVotes.keySet() AND Nominees__c in :finalVotes.values() AND Type__c = 'Master'];
        List<Vote__c> votes = new List<Vote__c>();
        System.debug('nominees: ' + nominees);
        for(CandidateNomination__c cnItem : nominees){
            if(cnItem.Nominees__c == finalVotes.get(cnItem.NominationId__c)){
                votes.add(new Vote__c(VoterId__c = voterId, CandidateNominationId__c = cnItem.Id));
            }
        }
        insert votes;
        System.debug('votes: ' + votes);
    }
}