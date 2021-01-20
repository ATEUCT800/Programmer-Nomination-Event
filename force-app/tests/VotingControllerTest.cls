@isTest
public with sharing class VotingControllerTest {

    @TestSetup
    static void makeData(){
        Campaign campaign = ModelUtils.buildCampaign();
        insert campaign;
        System.debug('campaign = ' + campaign);
        Nomination__c nomination = ModelUtils.buildNomination(campaign);
        insert nomination;
        System.debug('nomination = ' + nomination);
        Contact contact = ModelUtils.buildContact();
        insert contact;
        System.debug('contact = ' + contact);
        Contact voter = ModelUtils.buildContactWithEmail();
        insert voter;
        System.debug('voter = ' + voter);
        CandidateNomination__c nominee = ModelUtils.buildCandidateNomination(nomination, contact);
        insert nominee;
        System.debug('nominee = ' + nominee);
        User standartUser = ModelUtils.buildStandartUser();
        insert standartUser;
        System.debug('standartUser = ' + standartUser);
        User basicPStUser = ModelUtils.buildStandartUserWithBasicPS();
        insert basicPStUser;
        System.debug('basicPStUser = ' + basicPStUser);
    }
    // private static Campaign campaign = ModelUtils.getCampaign();
    // // private static Nomination__c nomination = ModelUtils.getNomination();
    // private static Contact contact = ModelUtils.getContact();
    // private static Contact voter = ModelUtils.getVoterContact();
    // private static CandidateNomination__c nominee = ModelUtils.getNominee();

    // @isTest static void testGetNominations() {
    //     Campaign newCampaign1 = new Campaign(Name='Test Campaign 1', IsActive=true, Type='Voting');
    //     insert newCampaign1;
    //     Campaign newCampaign2 = new Campaign(Name='Test Campaign 2', IsActive=true, Type='Voting');
    //     insert newCampaign2;
    //     List<Nomination__c> nominations = new List<Nomination__c>();
    //     for(Integer i = 0; i < 5; i++){
    //         nominations.add(new Nomination__c(Name=('Test Nomination ' + (i + 1)), CampaignId__c=newCampaign1.Id));
    //     }
    //     nominations.add(new Nomination__c(Name='Test Nomination Bad', CampaignId__c=newCampaign2.Id));
    //     System.debug(nominations);
    //     insert nominations;

    //     Test.startTest();
    //     Nomination__c[] resultNominations = VotingController.getNominationList(newCampaign1.Id);
    //     Test.stopTest();
    //     System.assertEquals(5, resultNominations.size());
    // } 

    // //getCampaignList() returns one Campaign, not a list
    // @isTest static void getCampaignListTest(){
    //     Test.startTest();
    //     insert campaign;
    //     Id expected = campaign.Id;
    //     Id actual = VotingController.getCampaignList().Id;
    //     Test.stopTest();
    //     System.assertEquals(expected, actual, 'Campaign.Id stored in DB not equals to Campaign.Id received by method.');
    // }

    // @isTest static void createOneVoteTest(){
    //     insert campaign;
    //     Nomination__c nomination = ModelUtils.getNomination();
    //     // nomination.CampaignId__c = campaign.Id;
    //     insert nomination;
    //     insert contact;
    //     //Nominee can get Nomination.Id and Contact.Id after their insert to DB
    //     nominee.NominationId__c = nomination.Id;
    //     nominee.Nominees__c = contact.Id;
    //     insert nominee;
    //     insert voter;

    //     Map<Id,Id> votes = new Map<Id,Id>();
    //     votes.put(nomination.Id, nominee.Nominees__c);

    //     Test.startTest();
    //     VotingController.createVote(votes, voter.Email);
    //     Test.stopTest();
    //     List<Vote__c> votesInDB = [SELECT Id, VoterId__c, CandidateNominationId__c FROM Vote__c 
    //                             WHERE CandidateNominationId__c =:nominee.Id AND VoterId__c =: voter.Id];
    //     System.assertEquals(1, votesInDB.size(), 'Vote was not inserted.');
    // }

    // @isTest static void createSomeVotesTest(){
    //     insert campaign;
    //     insert contact;
    //     insert voter;

    //     Nomination__c nomination1 = ModelUtils.getNomination();
    //     Nomination__c nomination2 = ModelUtils.getNomination();
    //     Nomination__c nomination3 = ModelUtils.getNomination();
    //     nomination1.CampaignId__c = campaign.Id;
    //     nomination2.CampaignId__c = campaign.Id;
    //     nomination3.CampaignId__c = campaign.Id;
    //     insert new Nomination__c[]{nomination1, nomination2, nomination3};
        
    //     CandidateNomination__c nominee1 = ModelUtils.getNominee();
    //     nominee1.NominationId__c = nomination1.Id;
    //     nominee1.Nominees__c = contact.Id;
    //     nominee1.Type__c = 'Master';
    //     CandidateNomination__c nominee2 = ModelUtils.getNominee();
    //     nominee2.NominationId__c = nomination2.Id;
    //     nominee2.Nominees__c = contact.Id;
    //     nominee2.Type__c = 'Master';
    //     CandidateNomination__c nominee3 = ModelUtils.getNominee();
    //     nominee3.NominationId__c = nomination3.Id;
    //     nominee3.Nominees__c = contact.Id;
    //     nominee3.Type__c = 'Master';
    //     insert new CandidateNomination__c[]{nominee1, nominee2, nominee3};

    //     Id[] nomineesId = new Id[]{nominee1.Id, nominee2.Id, nominee3.Id};
        
    //     Map<Id,Id> votes = new Map<Id,Id>();
    //     votes.put(nomination1.Id, nominee1.Nominees__c);
    //     votes.put(nomination2.Id, nominee2.Nominees__c);
    //     votes.put(nomination3.Id, nominee3.Nominees__c);
        
    //     Test.startTest();
    //     VotingController.createVote(votes, voter.Email);
    //     List<Vote__c> votesInDB = [SELECT Id FROM Vote__c  WHERE VoterId__c =: voter.Id];
    //     Test.stopTest();
    //     System.assertNotEquals(0, votesInDB.size(), 'Votes was not inserted.');                        
    // }

    // // @isTest static void createVoteWitoutEmailTest(){
    // //     insert campaign;
    // //     nomination.CampaignId__c = campaign.Id;
    // //     insert nomination;
    // //     insert contact;
    // //     //Nominee can get Nomination.Id and Contact.Id after their insert to DB
    // //     nominee.NominationId__c = nomination.Id;
    // //     nominee.Nominees__c = contact.Id;
    // //     insert nominee;
    // //     //creating voter without email
    // //     Contact voter = new Contact(LastName = 'Test VoterLastName');
    // //     insert voter;

    // //     Map<Id,Id> votes = new Map<Id,Id>();
    // //     votes.put(nomination.Id, nominee.Nominees__c);

    // //     Test.startTest();
    // //     VotingController.createVote(votes, voter.Email);
    // //     List<Vote__c> votesInDB = [SELECT Id FROM Vote__c  WHERE VoterId__c =: voter.Id];
    // //     Test.stopTest();

    // //     System.assertEquals(0, votesInDB.size());  
    // // }

    // @isTest static void createVoteWithInvalidEmailTest(){
    //     // insert campaign;
    //     // nomination.CampaignId__c = campaign.Id;
    //     Nomination__c nomination = ModelUtils.getNomination();
    //     insert nomination;
    //     insert contact;
    //     //Nominee can get Nomination.Id and Contact.Id after their insert to DB
    //     nominee.NominationId__c = nomination.Id;
    //     nominee.Nominees__c = contact.Id;
    //     insert nominee;
    //     insert voter;

    //     Map<Id,Id> votes = new Map<Id,Id>();
    //     votes.put(nomination.Id, nominee.Nominees__c);

    //     String invalidEmail = 'invalid.email@gmail.com';
    //     Boolean wasException = false;
    //     Test.startTest();
    //     try{
    //         VotingController.createVote(votes, invalidEmail);
    //     } catch (AuraHandledException ahe){
    //         wasException = true;
    //     }
    //     List<Vote__c> votesInDB = [SELECT Id FROM Vote__c WHERE VoterId__c =: voter.Id];   
    //     Test.stopTest();

    //     System.assertEquals(0, votesInDB.size());  
    //     System.assert(wasException);
    // }

    // //Bug on VotingPage
    // @isTest static void createVoteWithoutChoosenNomineeTest(){
    //     // insert campaign;
    //     Nomination__c nomination = ModelUtils.getNomination();
    //     // nomination.CampaignId__c = campaign.Id;
    //     insert nomination;
    //     insert contact;
    //     //Nominee can get Nomination.Id and Contact.Id after their insert to DB
    //     nominee.NominationId__c = nomination.Id;
    //     nominee.Nominees__c = contact.Id;
    //     insert nominee;
    //     insert voter;

    //     Map<Id,Id> votes = new Map<Id,Id>();
    //     Boolean wasException = false;
    //     Test.startTest();
    //     try{
    //         VotingController.createVote(votes, voter.Email);
    //     } catch (AuraHandledException ahe){
    //         wasException = true;
    //     }
    //     Test.stopTest();
    //     System.assert(wasException);  

    // }

    // @isTest static void createTheSameTwoVoteTest(){
    //     // insert campaign;
    //     // nomination.CampaignId__c = campaign.Id;
    //     Nomination__c nomination = ModelUtils.getNomination();
    //     insert nomination;
    //     insert contact;
    //     //Nominee can get Nomination.Id and Contact.Id after their insert to DB
    //     nominee.NominationId__c = nomination.Id;
    //     nominee.Nominees__c = contact.Id;
    //     insert nominee;
    //     insert voter;

    //     Map<Id,Id> votes = new Map<Id,Id>();
    //     votes.put(nomination.Id, nominee.Nominees__c);

    //     Test.startTest();
    //     Boolean wasException = false;
    //     try{
    //         VotingController.createVote(votes, voter.Email);
    //         VotingController.createVote(votes, voter.Email);
    //     } catch (AuraHandledException ahe){
    //         wasException = true;
    //     }
                
    //     List<Vote__c> votesInDB = [SELECT Id FROM Vote__c WHERE VoterId__c =: voter.Id];   
    //     Test.stopTest();

    //     System.assertEquals(1, votesInDB.size());      //First should insert, second no
    //     System.assert(wasException);
    // }

    // @isTest
    // static void testGetDescription() {
    //     // insert campaign;
    //     // nomination.CampaignId__c = campaign.Id;
    //     insert contact;
    //     Nomination__c nomination = ModelUtils.getNomination();
    //     insert nomination;
    //     //Nominee can get Nomination.Id and Contact.Id after their insert to DB
    //     nominee.NominationId__c = nomination.Id;
    //     nominee.Nominees__c = contact.Id;
    //     insert nominee;

    //     Test.startTest();
    //     String result = VotingController.getDescription(contact.Id, nomination.Id);
    //     Test.stopTest();
    //     System.assertEquals('Test Discription', result);
    // }

    // @isTest
    // public static void testgetContactList(){
    //     // insert campaign;
    //     // nomination.CampaignId__c = campaign.Id;
    //     Nomination__c nomination = ModelUtils.getNomination();
    //     insert nomination;
    //     insert contact;
    //     //Nominee can get Nomination.Id and Contact.Id after their insert to DB
    //     nominee.NominationId__c = nomination.Id;
    //     nominee.Nominees__c = contact.Id;
    //     insert nominee;

    //     List<Nomination__c> nominations = new List<Nomination__c>();
    //     nominations.add(nomination);

    //     Test.startTest();
    //     Map<Id, List<Contact>> result = VotingController.getContactList(nominations);
    //     Test.stopTest();
    //     System.assertEquals(1 , result.size() );   
    // }



    //If cange getCampaignList() return type to List<Campaign>
    // @isTest
    // public static void getEmptyCampaignListTest(){
    //     insert campaign;
    //     Test.startTest();
    //     Campaign[] actual = VotingController.getCampaignList();
    //     Test.stopTest();
    //     System.assertEquals(0, actual.size(), 'CampaignListTest is not empty.');
    // }
}