import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ShowToastEventLwc extends LightningElement {

    handleClick(event) {
        const label = event.target.label; // assuming the button has a label attribute
        let toastConfig;

        if (label === 'success') {
            toastConfig = {
                title: 'Success notification',
                message: 'Sample message for success toast',
                variant: 'success',
                //mode: 'sticky'
            };
        } else if (label === 'error') {
            toastConfig = {
                title: 'Error notification',
                message: 'Sample message for error toast',
                variant: 'error'
               // mode
            };
        } else if (label === 'info') {
            toastConfig = {
                title: 'info notification',
                message: 'Sample message for info toast',
                variant: 'info'
               // mode
            };
        }else if (label === 'warning') {
            toastConfig = {
                title: 'warning notification',
                message: 'Sample message for warning toast',
                variant: 'warning'
               // mode
            };
        }

        if (toastConfig) {
            this.dispatchEvent(new ShowToastEvent(toastConfig));
        }
    }
}