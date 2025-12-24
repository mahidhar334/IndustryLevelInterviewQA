import { LightningElement ,api, wire} from 'lwc';
import getAccountWithInput from '@salesforce/apex/DataTableLWCAccountHandler.getAccountWithInput';
export default class WireWithInputParameter extends LightningElement {
    inputString ='';
    accountData=[];

    handleSearch(event){
        this.inputString = event.target.value;
    }
    @wire(getAccountWithInput ,{KeyWord : '$inputString'})
    wiredAccounts({data,error}){
        if(data){
            this.accountData = data;

        }else{
            this.accountData = error;
        }


    }

}