@isTest
public with sharing class TestNomineeSelectionController {
    @isTest
    static void testGetOneContact() {
        List<Contact> contacts = new List<Contact>();
        Contact testContact = new Contact(LastName='TestLastName');
        contacts.add(new Contact(LastName='LolyPop'));
        contacts.add(testContact);
        contacts.add(new Contact(LastName='Maia'));



        Test.startTest();
        insert contacts;
        Contact[] resultContacts = NomineeSelectionController.getContactList('Test');
        Test.stopTest();

        System.assertEquals(1, resultContacts.size());
        System.assertEquals(testContact, resultContacts[0]);
    } 
}
