import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { LightningElement, wire, track} from 'lwc';
import getCurrentCampaign from '@salesforce/apex/VotingController.getCurrentCampaign';
import getNominationList from '@salesforce/apex/VotingController.getNominationList';
import createVote from '@salesforce/apex/VotingController.createVote';
import getContactList from '@salesforce/apex/VotingController.getContactList';
import getDescription from '@salesforce/apex/VotingController.getDescription';
import getFullInfo from '@salesforce/apex/VotingController.getFullInfo';
import { CurrentPageReference } from 'lightning/navigation';

export default class VotingPage extends LightningElement {
    queryTerm; 
    contacts;
    @track contactsInNominations;
    @track nominations;
    campaign;
    selectedNomination;
    selectedCampaign;
    posibleVotes = {};
    voterUUID = '';
    currentPageReference = null; 
    urlStateParameters = null;
    lastTargets = {};
    votingDataModel;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
           this.urlStateParameters = currentPageReference.state;
           this.setParametersBasedOnUrl();
        }
    }

    setParametersBasedOnUrl() {
        this.voterUUID = this.urlStateParameters.voteruuid || null;
    }

    connectedCallback(){
        getFullInfo({voterUUID : this.voterUUID}).then(result => {
            this.votingDataModel = result;
            this.campaign = this.votingDataModel.currentCampaign;
            this.nominations = Object.values(this.votingDataModel.nominationList);
            if(this.nominations.length == 0){
                this.nominations = null;
            } else {
                this.contactsInNominations = this.votingDataModel.nomineesInNomination;
                this.nominations.forEach(nominationItem => {
                    this.contactsInNominations[nominationItem.Id].forEach(contactItem => {
                            contactItem.description =  this.votingDataModel.nomineesWithDescription[contactItem.Id];
                        });            
                    nominationItem.contacts = this.contactsInNominations[nominationItem.Id];
                });
            }
        });
    }   

    handleClickButton(evt) {        
        if(!this.voterUUID){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'You must enter this section via link in invitation email only!',
                    variant: 'error',
                })
            );
        }else{
            createVote({finalVotes : this.posibleVotes, UUID: this.voterUUID})
            .then( () => {
                this.hasVoted = true;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Your vote has been submited',
                        variant: 'success',
                    })
                );
            })
            .catch(error =>{ 
                console.log('error.body.message', error.body.message);
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
        evt.currentTarget.className += ' selected-record';
        let selectedContact = evt.currentTarget.dataset.id1;
        let nomination = evt.currentTarget.dataset.id2;
        this.posibleVotes[nomination] = selectedContact;
        if(this.lastTargets[nomination]){
            this.lastTargets[nomination].className = this.lastTargets[nomination].className.replace(' selected-record', '');
        }
        this.lastTargets[nomination] = evt.currentTarget;
    }
}