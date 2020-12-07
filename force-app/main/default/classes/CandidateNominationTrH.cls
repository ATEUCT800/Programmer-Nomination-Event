public with sharing class CandidateNominationTrH {

    public void insertCandidateNomination (List<CandidateNomination__c> newRecord) {

        List<CandidateNomination__c> master_candidates = [SELECT ID, NominationId__c, Nominees__c, Description__c
                                                        FROM CandidateNomination__c WHERE Type__c = 'Master'];

        for (CandidateNomination__c cc : newRecord) {
            cc.Type__c='Master';
            for (CandidateNomination__c  ccmaster : master_candidates) {
                if(cc.NominationId__c == ccmaster.NominationId__c && cc.Nominees__c == ccmaster.Nominees__c){
                        cc.Type__c = 'Child';
                        cc.MasterRecordID__c = ccmaster.Id;
                }
            }
        }
    }

    public void deleteCandidateNomination (List<CandidateNomination__c> delRecord) {

        Set<String> deleted_cc_id = new Set<String>();

        for(CandidateNomination__c cc : delRecord)
        {
            deleted_cc_id.add(cc.id);
        }

        List<CandidateNomination__c> masterList =  [SELECT ID, 
                                                (SELECT ID, NominationId__c, Nominees__c, Description__c FROM ChildRecordIDs__r)
                                                FROM CandidateNomination__c where ID IN :deleted_cc_id AND Type__c = 'Master'];

        List<CandidateNomination__c> childsForChangesList = new List<CandidateNomination__c>();


        for (CandidateNomination__c ccmaster :masterList) {

            List<CandidateNomination__c> childList = ccmaster.ChildRecordIDs__r;

            if(!childList.isEmpty()){

                childList[0].Type__c = 'Master';
                childList[0].MasterRecordID__c = NULL;

                for(Integer i = 1;i < childList.size(); i++){
                    childList[i].MasterRecordID__c = childList[0].ID;

                }

                childsForChangesList.addAll(childList);
            } 
        }

        update childsForChangesList;
    }

}
