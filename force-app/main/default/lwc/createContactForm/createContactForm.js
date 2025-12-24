import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import createContact from '@salesforce/apex/DataTableLWCAccountHandler.createContact';

export default class NewContactForm extends NavigationMixin(LightningElement) {
    @track contactRecord = {
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        accountId: ''
    };

    handleChange(event) {
        const field = event.target.name;
        this.contactRecord[field] = event.target.value;
    }

    handleAccountSelect(event) {
        this.contactRecord.accountId = event.detail.value;
    }

    handleSave() {
        createContact({
            firstName: this.contactRecord.firstName,
            lastName: this.contactRecord.lastName,
            email: this.contactRecord.email,
            phone: this.contactRecord.phone,
            accountId: this.contactRecord.accountId
        })
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contact created successfully',
                    variant: 'success'
                })
            );

            // Navigate to the newly created Contact record page
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: result,
                    objectApiName: 'Contact',
                    actionName: 'view'
                }
            });

            this.resetForm();
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }

    resetForm() {
        this.contactRecord = {
            firstName: '',
            lastName: '',
            email: '',
            phone: '',
            accountId: ''
        };
        this.template.querySelectorAll('lightning-input').forEach(input => {
            input.value = '';
        });
    }
}