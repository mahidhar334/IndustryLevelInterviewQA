import { LightningElement } from 'lwc';

export default class CopyBillingtoShippingAddress extends LightningElement {
    BillingStreet = '';
    BillingCity = '';
    BillingState = '';
    BillingCountry = '';
    BillingPostalcode = '';

    ShippingStreet = '';
    ShippingCity = '';
    ShippingState = '';
    ShippingCountry = '';
    ShippingPostalcode = '';

    changeHandler(event) {
        const fieldName = event.target.name;
        this[fieldName] = event.target.value;
       // event.target.blur();
    }

    copyBillingToShipping() {
        this.ShippingStreet = this.BillingStreet;
        this.ShippingCity = this.BillingCity;
        this.ShippingState = this.BillingState;
        this.ShippingCountry = this.BillingCountry;
        this.ShippingPostalcode = this.BillingPostalcode;
    }
}