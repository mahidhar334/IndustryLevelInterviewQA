import { LightningElement,api } from 'lwc';
export default class ChildCompRecordApi extends LightningElement {
    @api message ='hello from child js';

}