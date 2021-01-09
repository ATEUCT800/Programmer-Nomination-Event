@isTest
public with sharing class VoteTrHandlerTest {
    
    @isTest
    static void testOneVoteInsert() {
        Campaign newCampaign = new Campaign(Name='Test Campaign', Type='Voting', IsActive=true);
        insert newCampaign;
        Contact newContact = new Contact(LastName='TestLastName');
        insert newContact;
        Nomination__c newNomination = new Nomination__c(CampaignId__c=newCampaign.Id, Name='Test Nomination');
        insert newNomination;
        CandidateNomination__c newCN = new CandidateNomination__c(Nominees__c=newContact.Id, NominationId__c=newNomination.Id, Description__c='Test Discription');
        insert newCN;
        Contact newVoter = new Contact(LastName='TestVoterLastName');
        insert newVoter;
        Vote__c newVote = new Vote__c(CandidateNominationId__c=newCN.Id, VoterId__c=newVoter.Id);
        Test.startTest();
        Database.SaveResult result = Database.insert(newVote, false);
        Test.stopTest();
        System.assert(result.isSuccess());
    }

    @isTest
    static void testTwoVotesFromOneUserInsert() {
        Campaign newCampaign = new Campaign(Name='Test Campaign', Type='Voting', IsActive=true);
        insert newCampaign;
        Contact newContact1 = new Contact(LastName='TestLastName1');
        insert newContact1;
        Contact newContact2 = new Contact(LastName='TestLastName2');
        insert newContact2;
        Nomination__c newNomination = new Nomination__c(CampaignId__c=newCampaign.Id, Name='Test Nomination');
        insert newNomination;
        CandidateNomination__c newCN1 = new CandidateNomination__c(Nominees__c=newContact1.Id, NominationId__c=newNomination.Id, Description__c='Test Discription1');
        insert newCN1;
        CandidateNomination__c newCN2 = new CandidateNomination__c(Nominees__c=newContact2.Id, NominationId__c=newNomination.Id, Description__c='Test Discription2');
        insert newCN2;
        Contact newVoter = new Contact(LastName='TestVoterLastName');
        insert newVoter;
        Vote__c newVote1 = new Vote__c(CandidateNominationId__c=newCN1.Id, VoterId__c=newVoter.Id);
        Vote__c newVote2 = new Vote__c(CandidateNominationId__c=newCN2.Id, VoterId__c=newVoter.Id);
        Test.startTest();
        Database.SaveResult result1 = Database.insert(newVote1, false);
        Database.SaveResult result2 = Database.insert(newVote2, false);
        Test.stopTest();
        System.assert(result1.isSuccess());
        System.assert(!result2.isSuccess());
    } 

    @isTest
    static void testVoteForChildNominee(){
        // Campaign newCampaign = new Campaign(Name='Test Campaign', Type='Voting', IsActive=true);
        // insert newCampaign;
        // Contact newContact = new Contact(LastName='TestLastName');
        // insert newContact;
        // Nomination__c newNomination = new Nomination__c(CampaignId__c=newCampaign.Id, Name='Test Nomination');
        // insert newNomination;
        // CandidateNomination__c newCN = new CandidateNomination__c(Nominees__c='00309000004izUiAAI', NominationId__c='a00090000038jMSAAY', Description__c='Test Discription');
        // insert newCN;
        // CandidateNomination__c newCN2 = new CandidateNomination__c(Nominees__c=newContact.Id, NominationId__c=newNomination.Id, Description__c='Test Discription2');
        // insert newCN2;
        // String name = 'CN-00097';
        // System.debug('name' + name);
        // CandidateNomination__c andy = [SELECT Id FROM CandidateNomination__c WHERE Name = 'CN-00097' ];
        // Contact newVoter = new Contact(LastName='TestVoterLastName');
        // insert newVoter;
        // Vote__c newVote = new Vote__c(CandidateNominationId__c=andy.Id, VoterId__c=newVoter.Id);
        // System.debug('name' + name);
        // Test.startTest();
        // System.debug(newVote);
        // Database.SaveResult result = Database.insert(newVote, true);
        // Test.stopTest();
        // System.assert(result.isSuccess());
        // List<CandidateNomination__c> candidate = ModelUtils.createCandidateNomination(2);
        Campaign newCampaign = new Campaign(Name='Test Campaign', Type='Voting', IsActive=true);
        insert newCampaign;
        Contact newContact = new Contact(LastName='TestLastName');
        insert newContact;
        Nomination__c newNomination = new Nomination__c(CampaignId__c=newCampaign.Id, Name='Test Nomination');
        insert newNomination;
        Contact newVoter = new Contact(LastName='TestVoterLastName');
        insert newVoter;
        CandidateNomination__c newCN1 = new CandidateNomination__c(Nominees__c=newContact.Id, NominationId__c=newNomination.Id, Description__c='Test Discription1');
        insert newCN1;
        CandidateNomination__c newCN2 = new CandidateNomination__c(Nominees__c=newContact.Id, NominationId__c=newNomination.Id, Description__c='Test Discription2');
        System.runAs(ModelUtils.userCreation()) {
            insert newCN2; 
        }
        Test.startTest();
        Vote__c newVote = new Vote__c(CandidateNominationId__c=newCN2.Id, VoterId__c=newVoter.Id);
        Database.SaveResult result = Database.insert(newVote, false);
        Test.stopTest();
        newVote = [SELECT CandidateNominationId__c, VoterId__c FROM Vote__c WHERE Id = :newVote.Id];
        System.assert(result.isSuccess());
        System.assertEquals(newCN1.Id, newVote.CandidateNominationId__c);
    }


    @isTest
    static void testTwoVotesFromUserForSameNomination() {
        Campaign newCampaign = new Campaign(Name='Test Campaign', Type='Voting', IsActive=true);
        insert newCampaign;
        Contact newContact = new Contact(LastName='TestLastName');
        insert newContact;
        Nomination__c newNomination = new Nomination__c(CampaignId__c=newCampaign.Id, Name='Test Nomination');
        insert newNomination;
        CandidateNomination__c newCN = new CandidateNomination__c(Nominees__c=newContact.Id, NominationId__c=newNomination.Id, Description__c='Test Discription1');
        insert newCN;
        Contact newVoter = new Contact(LastName='TestVoterLastName');
        insert newVoter;
        Vote__c newVote1 = new Vote__c(CandidateNominationId__c=newCN.Id, VoterId__c=newVoter.Id);
        Vote__c newVote2 = new Vote__c(CandidateNominationId__c=newCN.Id, VoterId__c=newVoter.Id);
        Test.startTest();
        Database.SaveResult result1 = Database.insert(newVote1, true);
        Database.SaveResult result2 = Database.insert(newVote2, false);
        Test.stopTest();
        System.assert(result1.isSuccess());
        System.assert(!result2.isSuccess());
        System.assert(result2.getErrors().size() > 0);
        System.assertEquals('You have already voted in this nomination!', 
                               result2.getErrors()[0].getMessage());
    }

    // @isTest
    // static void testEmptyMethods() {
    //     Map<Id, SObject> newItems = new Map<Id, SObject>();
    //     Map<Id, SObject> oldItems = new Map<Id, SObject>();
    //     VoteTrH vTrh = new VoteTrH();
    //     vTrh.AfterInsert(newItems);
    //     vTrh.BeforeUpdate(newItems, oldItems);
    //     vTrh.BeforeDelete(oldItems);
    //     vTrh.AfterUpdate(newItems, oldItems);
    //     vTrh.AfterDelete(oldItems);
    //     vTrh.AfterUndelete(oldItems);
    // }
    @isTest
    static void testDeleteVote() {
        Vote__c newVote = ModelUtils.getVote();
        insert newVote;
        Database.DeleteResult result = Database.Delete(newVote, false);
        System.assert(result.isSuccess());
    }

    @isTest
    static void testUndeleteVote() {
        Vote__c newVote = ModelUtils.getVote();
        insert newVote;
        Database.delete(newVote, false);
        Database.UndeleteResult result = Database.Undelete(newVote, false);
        System.assert(result.isSuccess());
    }

    @isTest
    static void testUpdateVote() {
        Vote__c newVote = ModelUtils.getVote();
        insert newVote;
        Contact newVoter = ModelUtils.getContact();
        insert newVoter;
        newVote.VoterId__c = newVoter.Id;
        update newVote;
        newVote = [SELECT CandidateNominationId__c, VoterId__c FROM Vote__c WHERE Id = :newVote.Id];
        System.assertEquals(newVoter.Id, newVote.VoterId__c);
    }
}
