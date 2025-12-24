import { LightningElement } from 'lwc';

export default class FeetToInches extends LightningElement {
    
    feet = 0;
    inches = 0; 
    handleFeetChange(event){
        this.feet = event.target.value;
        this.inches = this.feet * 12;
    }

}