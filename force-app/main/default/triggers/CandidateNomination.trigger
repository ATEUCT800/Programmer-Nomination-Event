trigger CandidateNomination on CandidateNomination__c (before insert, before delete) {

    CandidateNominationTrH CNHandler = new CandidateNominationTrH();

    if(trigger.isInsert){
        CNHandler.insertCandidateNomination(Trigger.new);
    }

    if(trigger.isDelete){
        CNHandler.deleteCandidateNomination(Trigger.old);
    }
}