import { LightningElement } from 'lwc';
import getAccountList from '@salesforce/apex/DataTableLWCAccountHandler.getAccountList';
//import delAccountList from '@salesforce/apex/DataTableLWCAccountHandler.delAccountList';

//import Account_Object from '@salesforce/schema/object/Account';
//import Industry_Field from '@salesforce/schema/object/Account.Industry';

export default class LighiningDataTable extends LightningElement {
    dataList= [];
    selectedRows =[];
    //@api industryFilter;
    // fetech real picklist values from salesforce
    //options = this.Industry_Field;  

    columnsList = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Phone', fieldName: 'Phone', type: 'text' },
        { label: 'Rating', fieldName: 'Rating', type: 'text' },
        { label: 'Industry', fieldName: 'Industry', type: 'text'},
    ];
    
    // @wire(getAccountList )
    // dataLists({data,error}){

    //     if(data){
    //         this.dataList = data;
    //     } else if(error){
    //         console.log('wired error'+ error);
    //     }
    // }


    connectedCallback() {
        //code

        // wire method is reactive property data will load after rendering 
        // imperative method using APEX

       this.getAccounts();
    }

    getAccounts(){

        getAccountList()
            .then((result) => {
                console.log('result-->'+ result);
                this.dataList = result;
                console.log('length-->'+ this.dataList.length);
            }).catch((error) =>{
                console.log('error--->'+ error)
            })
            }


            handleRowsSlection(event){
                this.selectedRows = event.detail.selectedRows;
                console.log('selected rows-->' + JSON.stringify(this.selectedRows));
            }

            

        
    }