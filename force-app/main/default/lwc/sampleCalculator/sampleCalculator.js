import { LightningElement } from 'lwc';

export default class SampleCalculator extends LightningElement {
    x = 0;
    y = 0;
    Result = 0;

    handleAmountChange(event) {
        this.x = parseFloat(event.target.value);
    }

    handleFromCurrencyChange(event) {
        this.y = parseFloat(event.target.value);
    }

    performOperation(event) {
        let tempResult = 0;
        const operation = event.target.label;

        switch (operation) {
            case 'Add':
                tempResult = this.x + this.y;
                break;
            case 'Subtract':
                tempResult = this.x - this.y;
                break;
            case 'Multiply':
                tempResult = this.x * this.y;
                break;
            case 'Divide':
                tempResult = this.y !== 0 ? this.x / this.y : 'Error: Division by zero';
                break;
        }

        this.Result = tempResult;
    }



    /*add() {
        const result = parseFloat(this.x) + parseFloat(this.y);
        alert('Result: ' + result);
    }

    subtract() {
        const result = parseFloat(this.x) - parseFloat(this.y);
        alert('Result: ' + result);
    }

    multiply() {
        const result = parseFloat(this.x) * parseFloat(this.y);
        alert('Result: ' + result);
    }

    divide() {
        const result = parseFloat(this.x) / parseFloat(this.y);
        alert('Result: ' + result);
    }*/
    
}