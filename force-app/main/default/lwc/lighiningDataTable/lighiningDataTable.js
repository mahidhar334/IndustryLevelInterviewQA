import { LightningElement,wire } from 'lwc';
import getAccountList from '@salesforce/apex/DataTableLWCAccountHandler.getAccountList';
import delAccountList from '@salesforce/apex/DataTableLWCAccountHandler.delAccountList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex'
//import Account_Object from '@salesforce/schema/object/Account';
//import Industry_Field from '@salesforce/schema/object/Account.Industry';

export default class LighiningDataTable extends LightningElement {
    dataList= [];
    selectedRows =[];
    isDisable = true;
    //@api industryFilter;
    // fetech real picklist values from salesforce
    //options = this.Industry_Field;  
    // get isDeleteDisabled() {
    //     return this.selectedRows.length === 0;
    // }

    columnsList = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Phone', fieldName: 'Phone', type: 'text' },
        { label: 'Rating', fieldName: 'Rating', type: 'text' },
        { label: 'Industry', fieldName: 'Industry', type: 'text'},
    ];
    
     @wire(getAccountList )
     wiredAccounts(result){
        this.wiredAccountsResult = result;
         const { data, error } = result;

        if(data){
         this.dataList = data;
         } else if(error){
             console.log('wired error'+ error);
         }
     }


    connectedCallback() {
        //code

        // wire method is reactive property data will load after rendering 
        // imperative method using APEX

       //this.getAccounts();
    }

    getAccounts(){

        getAccountList()
            .then((result) => {
                console.log('result-->', result);
                this.dataList = result;
                console.log('length-->', this.dataList.length);
            }).catch((error) =>{
                console.log('error--->', error)
            })
            }


            handleRowsSelection(event){
                this.selectedRows = event.detail.selectedRows;
                if(this.selectedRows.length >=1){
                    this.isDisable = false;
                    }else{
                        this.isDisable = true;
                    }
                
                console.log('selected rows-->' + JSON.stringify(this.selectedRows));
            }
            // handleDelete() {
            //         delAccountList({ accList: this.selectedRows })
            //             .then((result) => {
            //                 console.log(result)
            //                 if(result === 'success'){
            //                 this.dispatchEvent(
            //                     new ShowToastEvent({
            //                         title: 'Success',
            //                         message: `${this.selectedRows.length} accounts deleted successfully`,
            //                         variant: 'success',
            //                     })
            //                 );
            //                 // setTimeout(() => {
            //                 //     location.reload();
            //                 // },3000)
            //             this.selectedRows = [];
            //      setTimeout(() => {
            //         refreshApex(this.wiredAccountsResult);
            //         //location.reload();
            //     }, 3000);
                       
            // }else {
            //     this.dispatchEvent(
            //         new ShowToastEvent({
            //             title: 'Delete Failed',
            //             message: result, // will show "Error: Case is associated..."
            //             variant: 'error',
            //         })
                    
            //     );
            //      this.selectedRows = [];
            //      setTimeout(() => {
            //         refreshApex(this.wiredAccountsResult);
            //         //location.reload();
            //     }, 3000);
            // }
            //  })
            //             .catch((error) => {
            //                 this.dispatchEvent(
            //                     new ShowToastEvent({
            //                         title: 'Error deleting records',
            //                         message: error.body.message,
            //                         variant: 'error',
            //                     })
            //                 );
            //             });
            //             this.selectedRows = [];

            //     // Wait a couple of seconds for the toast to disappear, then refresh
            //     setTimeout(() => {
            //         refreshApex(this.wiredAccountsResult);
            //         //location.reload();
            //     }, 3000);
                        
            //     }

            handleDelete() {
    const idsToDelete = this.selectedRows.map(row => row.Id);

    delAccountList({ accList: this.selectedRows })
        .then((result) => {
            if (result === 'success') {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: `${idsToDelete.length} accounts deleted successfully`,
                        variant: 'success',
                    })
                );
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Delete Failed',
                        message: result,
                        variant: 'error',
                    })
                );
            }
            this.selectedRows = [];
            refreshApex(this.wiredAccountsResult);
        })
        .catch((error) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error deleting records',
                    message: error.body ? error.body.message : error.message,
                    variant: 'error',
                })
            );
        });
}


            

        
    }