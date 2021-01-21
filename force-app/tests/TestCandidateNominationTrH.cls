@isTest
public class TestCandidateNominationTrH {

    @testSetup
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
        // User standartUser = ModelUtils.buildStandartUser();
        // insert standartUser;
        // System.debug('standartUser = ' + standartUser);

        // System.debug('basicPStUser = ' + basicPSUser);
        // User adminUser = ModelUtils.buildSystemAdministrator();
        // insert adminUser;
        // PermissionSet basicPS = [SELECT Id FROM PermissionSet WHERE Name = 'Basic'];
        // PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = basicPS.Id, AssigneeId = basicPSUser.Id);
        // System.runAs ( adminUser ){
        //     insert psa;
        // }
        // PermissionSetAssignment perm = [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :basicPSUser.Id LIMIT 1];
        // System.debug('permission set' + perm.PermissionSet.Name);
}
//     @isTest
//     static void testOneMasterInsert() {
//         List<CandidateNomination__c> candidates = ModelUtils.createCandidateNomination(1);
//         Test.startTest();
//         Database.SaveResult result = Database.insert(candidates.get(0), false);
//         Test.stopTest();
//         CandidateNomination__c candidate = [SELECT Nominees__c, NominationId__c, Description__c, Type__c, MasterRecordID__c FROM CandidateNomination__c WHERE Id = :candidates.get(0).Id];     
//         System.assert(result.isSuccess());
//         System.assertEquals('Master', candidate.Type__c);
//         System.assertEquals(null, candidate.MasterRecordID__c);
// }
    @isTest
    static void testOneMasterAndChildInsert() {
        // List<CandidateNomination__c> candidates = ModelUtils.createCandidateNomination(2);
        // System.debug(candidates);
        // User basicPStUser = [SELECT isActive FROM User WHERE Email='basicPSuser@testorg.com'];
        User basicPSUser = ModelUtils.buildStandartUserWithBasicPS();
        basicPSUser.Email = 'basicPSuser@testorg.com';
        insert basicPSUser;
        PermissionSetAssignment basicPSA = ModelUtils.buildBasicPermissionSetToUser(basicPSUser);
        insert basicPSA;
        // PermissionSetAssignment perm = [SELECT PermissionSet.Name, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :basicPStUser.Id LIMIT 1];
        System.debug('basicPStUser' + basicPSUser.Id);
        // System.debug('permission set' + perm.PermissionSet.Name);
        // System.debug('AssigneeId' + perm.AssigneeId);
        CandidateNomination__c master = [SELECT Nominees__c, NominationId__c, Description__c, Type__c, MasterRecordID__c FROM CandidateNomination__c LIMIT 1];
        CandidateNomination__c child = new CandidateNomination__c(NominationId__c = master.NominationId__c, Nominees__c = master.Nominees__c, Description__c = 'Test Discription');
        Test.startTest();
        Database.SaveResult resultChild;
        System.runAs(basicPSUser) {
            
            resultChild = Database.insert(child, false);
        }
        Test.stopTest();
        Database.Error[] errors =  resultChild.getErrors();
        for(Database.Error error : errors){
            System.debug('error = ' + error);
        }
        CandidateNomination__c newChildCN = [SELECT Nominees__c, NominationId__c, Description__c, Type__c, MasterRecordID__c FROM CandidateNomination__c WHERE Id = :child.Id];

        System.assert(resultChild.isSuccess());
        System.assertEquals('Child', child.Type__c);
        System.assertEquals(master.Id, child.MasterRecordID__c);
    } 
//     @isTest static void testMasterDeletion() {
//         List<CandidateNomination__c> candidates = ModelUtils.createCandidateNomination(3);
//         insert candidates.get(0);
//         System.runAs(ModelUtils.userCreation()) {
//         insert candidates.get(1);  
//         }
//         System.runAs(ModelUtils.userCreation()) {
//             insert candidates.get(2);  
//         }
//         Test.startTest();
//         Database.DeleteResult result = Database.delete(candidates.get(0), false);
//         Test.stopTest();
//         CandidateNomination__c newFirstChildCN = [SELECT Nominees__c, NominationId__c, Description__c, Type__c, MasterRecordID__c FROM CandidateNomination__c WHERE Id = :candidates.get(1).Id LIMIT 1];
//         CandidateNomination__c newSecondChildCN = [SELECT Nominees__c, NominationId__c, Description__c, Type__c, MasterRecordID__c FROM CandidateNomination__c WHERE Id = :candidates.get(2).Id LIMIT 1];
    
//         System.assert(result.isSuccess());
//         System.assertEquals('Master', newFirstChildCN.Type__c);
//         System.assertEquals(null, newFirstChildCN.MasterRecordID__c);
//         System.assertEquals(newFirstChildCN.Id, newSecondChildCN.MasterRecordID__c);
//     }
//     @IsTest
//     static void testDuplicateInsert() {
//         List<CandidateNomination__c> candidates = ModelUtils.createCandidateNomination(2);
//         Test.startTest();
//         //Database.SaveResult[] results = Database.insert(candidates, false);
//         Database.SaveResult result = Database.insert(candidates.get(0), false);
//         Database.SaveResult resultForDuplicate = Database.insert(candidates.get(1), false);
//         Test.stopTest();
        
//         // System.assert(results[0].isSuccess());  //Failed
//         // System.assert(!results[1].isSuccess());

//         System.assert(result.isSuccess());
//         System.assert(!resultForDuplicate.isSuccess());
//         System.assert(resultForDuplicate.getErrors().size() > 0);
//         System.assertEquals('You have already nominated this person in this category!',
//                 resultForDuplicate.getErrors()[0].getMessage());
//     }

//     @isTest static void testUndeleteCN() {
//     CandidateNomination__c newCN = ModelUtils.createCandidateNomination(1)[0];
//     insert newCN;
//     Database.delete(newCN, false);
//     Database.UndeleteResult result = Database.Undelete(newCN, false);
//     System.assert(result.isSuccess());
    
//     }
}

