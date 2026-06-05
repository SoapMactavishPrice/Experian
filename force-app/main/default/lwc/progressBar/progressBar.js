import { LightningElement ,api, track} from 'lwc';

export default class ProgressBar extends LightningElement {
    @api percentage = 0; // Default to 0%
    @track strokeValue = "0, 100";
    // Circle radius and circumference calculations
    radius = 15.9155; // radius based on SVG viewBox
    circumference = 2 * Math.PI * this.radius;

    @api
    updateProgress(newPercentage) {
        console.log('newPercentage >> ', newPercentage);
        
        this.percentage = newPercentage;
        let dashArrayLength = (this.percentage / 100) * this.circumference;
        //console.log('dashArrayLength >> ', dashArrayLength);
        this.strokeValue = ''+dashArrayLength+',100';

        console.log('this.strokeValue >> ', this.strokeValue);


    }

}