import { LightningElement , api} from 'lwc';
export default class HelloWorld extends LightningElement {
        greeting = 'Have a Great Day';
        changeHandler(event) {
        this.greeting = event.target.value;
        }

      @api  firstName = "world";

      lowercaseLastName ='Default value';

      @api
      get lastName() {
        return this.lowercaseLastName.toUpperCase();
      }

      set lastName(value) {
        this.lowercaseLastName = value;
      }
}