@isTest
public with sharing class ModelUtils {
    public static Campaign getCampaign(){
        Campaign camp = new Campaign();
        camp.Name = 'Test Campaign';
        camp.IsActive = true;
        camp.Type = 'Voting';
        return camp;
    }

    public static Nomination__c getNomination(){
        Nomination__c nom = new Nomination__c();
        Campaign camp =  getCampaign();
        insert camp;
        nom.Name = 'Test Nomination';
        nom.CampaignId__c = camp.Id;
        return nom;
    }

    public static Contact getContact(){
        Contact cont = new Contact();
        cont.LastName = 'Test LastName';
        return cont;
    }

    public static Contact getVoterContact(){
        Contact voter = new Contact();
        voter.LastName = 'Test VoterLastName';
        voter.Email = 'test.voter.email@gmail.com';
        return voter;
    }

    public static CandidateNomination__c getNominee(){
        CandidateNomination__c nominee = new CandidateNomination__c();
        // nominee.NominationId__c = getNomination().Id;
        // nominee.Nominees__c = getContact().Id;
        nominee.Description__c = 'Test Discription';
        nominee.Type__c = 'Master';                   //???
        return nominee;
    }

    public static Vote__c getVote(){
        CandidateNomination__c nominee = createCandidateNomination(1)[0];
        insert nominee;
        Contact voter = getVoterContact();
        insert voter;
        Vote__c vote = new Vote__c(VoterId__c=voter.Id, CandidateNominationId__c=nominee.Id);
        return vote;
    }

    public static List<CandidateNomination__c> createCandidateNomination(Integer numCandidates) {
        // Campaign testCampaign = getCampaign();
        // insert testCampaign;
        Nomination__c testNomination = getNomination();
        insert testNomination;
        Contact testContact = getContact();
        insert testContact;
        List<CandidateNomination__c> candidates = new List<CandidateNomination__c>();
            for (Integer i = 0; i < numCandidates; i++) {
                CandidateNomination__c newCandidate = new CandidateNomination__c(NominationId__c = testNomination.Id,
                        Nominees__c = testContact.Id, Description__c = 'test' + i);
                candidates.add(newCandidate);
            }
        return candidates;
    }

    public static User userCreation() {
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser2@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
            UserName=uniqueUserName);
            return u;
    }

}
