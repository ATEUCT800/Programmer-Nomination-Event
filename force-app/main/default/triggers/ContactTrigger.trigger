trigger ContactTrigger on Contact (before insert) {
    TriggerDispatcher.Run(new ContactTrH());
}