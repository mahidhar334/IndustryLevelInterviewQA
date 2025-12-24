import { LightningElement, track } from 'lwc';

export default class MarksComponent extends LightningElement {
    @track sub1 = 0;
    @track sub2 = 0;
    @track sub3 = 0;
    @track result = '';

    handleSub1Change(event) {
        this.sub1 = parseFloat(event.target.value) || 0;
    }

    handleSub2Change(event) {
        this.sub2 = parseFloat(event.target.value) || 0;
    }

    handleSub3Change(event) {
        this.sub3 = parseFloat(event.target.value) || 0;
    }

    calculateTotal() {
        const total = this.sub1 + this.sub2 + this.sub3;
        this.result = `Total Marks: ${total}`;
    }

    calculatePercentage() {
        const total = this.sub1 + this.sub2 + this.sub3;
        const percentage = (total / 300) * 100; // assuming each subject is out of 100
        this.result = `Percentage: ${percentage.toFixed(2)}%`;
    }

    calculateDivision() {
        const total = this.sub1 + this.sub2 + this.sub3;
        const percentage = (total / 300) * 100;

        let division = '';
        if (percentage >= 60) {
            division = 'First Division';
        } else if (percentage >= 45) {
            division = 'Second Division';
        } else if (percentage >= 33) {
            division = 'Third Division';
        } else {
            division = 'Fail';
        }

        this.result = `Division: ${division}`;
    }
}