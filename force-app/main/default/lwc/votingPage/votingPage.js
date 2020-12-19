import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { LightningElement, wire } from 'lwc';
import getCampaignList from '@salesforce/apex/VotingController.getCampaignList';
import getNominationList from '@salesforce/apex/VotingController.getNominationList';
import createVote from '@salesforce/apex/VotingController.createVote';
import getContactList from '@salesforce/apex/VotingController.getContactList';
// import getVoter from '@salesforce/apex/VotingController.getVoter';

export default class VotingPage extends LightningElement {
    queryTerm; 
    contacts;
    nominations;
    campaigns;
    voterEmail;
    selectedNomination;
    selectedCampaign;
    selectedContact;
    @wire(getContactList, {queryTerm:'$queryTerm', nominationId: '$selectedNomination'})
    wiredContacts(response){
        this.contacts = response.data;
    }
    @wire(getNominationList, {campaign: '$selectedCampaign'})
    wiredNominations(response){
        this.nominations = response.data;        
    }
    @wire(getCampaignList)
    wiredCampaigns(response){
        this.campaigns = response.data;
    }
    handleEmailChange(evt){
        this.voterEmail = evt.target.value;
    }
    
    handleSearchChange(evt) {
        this.queryTerm = evt.target.value;
    }

    handleNominationChange(event) {
        this.selectedNomination = event.detail.value;
    }
    
    handleCampaignChange(event) {
        this.selectedCampaign = event.detail.value;
    }

    handleClickButton() {
        if(!this.voterEmail){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Fill all required fields!',
                    variant: 'error',
                })
            );
        }else{
        // let voterContactId = getVoter({email: this.voterEmail});
        // console.log('voterContact ' + voterContactId);
        console.log('selectedNomination ' + this.selectedNomination);
        console.log('selectedContact ' + this.selectedContact);
        console.log('this.voterEmail ' + this.voterEmail);
        createVote({nominationId: this.selectedNomination, contactId: this.selectedContact, email: this.voterEmail})
        .then( () => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Your vote has been submited',
                    variant: 'success',
                })
            );
        })
        .catch(error =>{ 
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                })
            );
        });
        }
    }

    handleClickViewForm(evt) {
        this.selectedContact = evt.currentTarget.dataset.id;
        console.log('this.selectedContact ' + this.selectedContact);
    }

    get nominationOptions() {
        let listOfOptions = [];
        this.nominations.forEach(nom => {
            listOfOptions.push({ label: nom.Name, value: nom.Id });
        });
        return listOfOptions;
    }

    get campaignOptions() {
        let listOfOptions = [];
        this.campaigns.forEach(cam => {
            listOfOptions.push({ label: cam.Name, value: cam.Id });
        });
        return listOfOptions;
    }
}