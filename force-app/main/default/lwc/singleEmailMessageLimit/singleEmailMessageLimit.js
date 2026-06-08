import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getEmailLimits from '@salesforce/apex/SingleEmailMessageLimitController.getEmailLimits';


export default class SingleEmailMessageLimit extends LightningElement {

    @track showSpinner = true;


    used = 0;
    max = 0;

    get percentage() {
        return this.max > 0 ? Math.round((this.used / this.max) * 100) : 0;
    }

    get remaining() {
        return this.max - this.used;
    }



    @wire(getEmailLimits)
    wiredEmailLimits({ error, data }) {
        if (data) {
            this.used = data.used;
            this.max = data.max;
        }
        else if (error) {
            this.showToast('Error', 'Something went wrong to get the email limits', 'error', error);
        }

        if (data || error) {
            this.showSpinner = false;
        }
    }


    showToast(title, message, variant, error) {
        const msg = error
            ? error.body?.message ?? error.body ?? error.message ?? error
            : message;

        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

}