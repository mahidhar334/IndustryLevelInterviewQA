import { LightningElement } from 'lwc';

export default class OnClickComponent extends LightningElement {

    World = 'Mahidhar';
    Tasks =' check the Tasks Assigned'
    onclickHandler(event){
        this.World = "Today is a good day";
        event.target.blur();
    }

    changeHandler(event){
        this.Tasks = event.target.value;
       // event.target.blur();   --> per click or everytime you have click on the input for each aplhabet so not recomended for input only for buttons since we will click on once
    }
}