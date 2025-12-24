import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getAccountList from '@salesforce/apex/DataTableLWCAccountHandler.getAccountList';

const ACCOUNT_FIELDS = ['Account.Name'];

export default class AccountTabs extends LightningElement {
    //@api recordId;   // Salesforce automatically injects this when placed on a record page

    account;
    contacts;
    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Rating', fieldName: 'Rating' },
        { label: 'Phone', fieldName: 'Phone' }
    ];

    // Fetch Account record
    @wire(getAccountList)
    wiredAccount({ error, data }) {
        if (data) {
            this.contacts = data;
        } else if (error) {
            console.error(error);
        }
    }

    // // Handle hyperlink click
    // handleAccountClick() {
    //     getContacts({ accountId: this.recordId })
    //         .then(result => {
    //             this.contacts = result;
    //         })
    //         .catch(error => {
    //             console.error(error);
    //         });
    // }
}