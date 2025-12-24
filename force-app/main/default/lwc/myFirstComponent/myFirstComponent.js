import { LightningElement } from 'lwc';

export default class MyFirstComponent extends LightningElement {

    message ='Mahidhar';
    greeting ='Hello world today is december 6th 2025'
    changeHandler(event){
      if(event.target.label ==='Name'){
        this.message = event.target.value;
        //this.message = this.template.querySelector("lightning-input").value;
      } else {
         this.greeting = event.target.value;
      }
       
    }
    showButton = false;
    toggleText = false;
    clickHandler(event){
       // alert('Button Clicked');
        this.greeting = 'Button Clicked on december 7th 2025';
        this.message ='learning LWC'
        this.showButton =true;
    }
    clickHandlerHide(event){
        this.showButton =false;
    }
    clickHandleToggle(event){
        this.toggleText =!this.toggleText;
    }
    get handleToggleLable(){
        return this.toggleText ? 'Turn OFF' : 'Turn ON';
    }
   }