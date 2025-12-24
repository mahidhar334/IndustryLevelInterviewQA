import { LightningElement } from 'lwc';

export default class UsdtoINRConversion extends LightningElement {
    amount = 1;
    fromCurrency = 'USD';
    toCurrency = 'INR';
    convertedAmount = 0;

    get currencyOptions() {
        return [
            { label: 'USD', value: 'USD' },
            { label: 'INR', value: 'INR' },
            { label: 'EUR', value: 'EUR' },
            { label: 'GBP', value: 'GBP' },
            { label: 'CAD', value: 'CAD' },
            { label: 'AUD', value: 'AUD' }
        ];
    }

    handleAmountChange(event) {
        this.amount = parseFloat(event.target.value);
        this.convertAndDisplay();
    }

    handleFromCurrencyChange(event) {
        this.fromCurrency = event.detail.value;
        this.convertAndDisplay();
    }

    handleToCurrencyChange(event) {
        this.toCurrency = event.detail.value;
        this.convertAndDisplay();
    }

    convertAndDisplay() {
        this.convertedAmount = this.convertCurrency(this.amount, this.fromCurrency, this.toCurrency);
    }

    convertCurrency(amount, fromCurrency, toCurrency) {
        const exchangeRates = {
            'USD': 1,
            'EUR': 0.85,
            'GBP': 0.73,
            'CAD': 1.32,
            'AUD': 1.54,
            'INR': 74.99
        };

        if (!exchangeRates[fromCurrency] || !exchangeRates[toCurrency]) {
            return 0;
        }

        const convertedAmount = (amount / exchangeRates[fromCurrency]) * exchangeRates[toCurrency];
        return Math.round(convertedAmount * 100) / 100;
    }
}