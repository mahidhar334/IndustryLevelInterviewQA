import { LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/DataTableLWCAccountHandler.getContacts';
import deleteContacts from '@salesforce/apex/DataTableLWCAccountHandler.deleteContacts';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class WireMethod extends LightningElement {
    disabled = true;
    selectedRows = [];
    dataList = [];
    errorList;
    refreshWire;
    showCreateForm = false;
    selectedAccountId;

    columnsList = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        { label: 'Account Name', fieldName: 'AccountName' }
    ];

    @wire(getContacts)
    contacts(result) {
        this.refreshWire = result;
        const { data, error } = result;
        if (data) {
            let copyData = JSON.parse(JSON.stringify(data));
            copyData.forEach(currentItem => {
                currentItem.AccountName = currentItem.Account ? currentItem.Account.Name : '';
            });
            this.dataList = copyData;
        } else {
            this.errorList = error;
        }
    }

    handleSelectedRows(event) {
        this.selectedRows = event.detail.selectedRows;
        //this.disabled = this.selectedRows.length < 1;
        if (this.selectedRows.length > 0) {
            this.disabled = false;
        }else{
            this.disabled = true;
        }
    }

    handleRefresh() {
        this.selectedRows = [];
        this.disabled = true;
        refreshApex(this.refreshWire);
    }

    handleDelete() {
        const idsToDelete = this.selectedRows.map(row => row.Id);
        deleteContacts({ contactIds: idsToDelete })
            .then(() => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: `${idsToDelete.length} records deleted successfully`,
                    variant: 'success'
                }));
                this.handleRefresh();
            })
            .catch(error => {
                this.errorList = error;
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: error.body ? error.body.message : 'Unknown error',
                    variant: 'error'
                }));
            });

    }

    // 🚀 Create button now toggles the custom component
    handleCreate() {
        this.showCreateForm = true;
    }

    // When child component dispatches "refresh" event
    handleFormClose() {
        this.showCreateForm = false;
        this.handleRefresh();
    }
}