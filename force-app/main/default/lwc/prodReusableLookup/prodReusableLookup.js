import { LightningElement, api, track } from 'lwc';
import fetchRecords from '@salesforce/apex/ProdReusableLookup.fetchRecords';

const DELAY = 300; // Debounce delay in ms

export default class ProdReusableLookup extends LightningElement {
    @api helpText = 'Custom search lookup';
    @api label = '';
    @api required;
    @api selectedIconName = 'standard:account';
    @api objectLabel;
    @api placeholder;

    @api objectApiName;
    @api parentId;
    @api fieldApiName;
    @api otherFieldApiName;
    @api searchString = '';
    @api selectedRecordId = '';
    @api parentRecordId;
    @api parentFieldApiName;

    @track recordsList = [];
    selectedRecordName = '';

    preventClosingOfSerachPanel = false;
    delayTimeout;

    get methodInput() {
        return {
            objectApiName: this.objectApiName,
            fieldApiName: this.fieldApiName,
            otherFieldApiName: this.otherFieldApiName,
            searchString: this.searchString,
            selectedRecordId: this.selectedRecordId,
            parentRecordId: this.parentRecordId,
            parentFieldApiName: this.parentFieldApiName,
            parentId:this.parentId
        };
    }

    get showRecentRecords() {
        return Array.isArray(this.recordsList) && this.recordsList.length > 0;
    }

    get isValueSelected() {
        return !!this.selectedRecordId;
    }

    connectedCallback() {
        if (this.selectedRecordId) {
            this.fetchSobjectRecords(true);
        }
    }

    fetchSobjectRecords(loadEvent) {
        fetchRecords({ inputWrapper: this.methodInput })
            .then(result => {
                if (loadEvent && result?.length) {
                    this.selectedRecordName = result[0].mainField;
                } else {
                    this.recordsList = result || [];
                }
            })
            .catch(error => {
                console.error('Error fetching records:', error);
            });
    }

    handleChange(event) {
        this.searchString = event.target.value;

        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            this.fetchSobjectRecords(false);
        }, DELAY);
    }

    handleBlur() {
        if (!this.preventClosingOfSerachPanel) {
            this.recordsList = [];
        }
        this.preventClosingOfSerachPanel = false;
    }

    handleDivClick() {
        this.preventClosingOfSerachPanel = true;
    }

    handleCommit() {
        this.selectedRecordId = '';
        this.selectedRecordName = '';
        this.recordsList = [];

        // Dispatch null selection
        this.dispatchEvent(new CustomEvent('valueselected', {
            detail: { id: null, mainField: '', subField: '' }
        }));
    }

    handleSelect(event) {
        const selectedRecord = {
            id: event.currentTarget.dataset.id,
            mainField: event.currentTarget.dataset.mainfield,
            subField: event.currentTarget.dataset.subfield
        };

        this.selectedRecordId = selectedRecord.id;
        this.selectedRecordName = selectedRecord.mainField;
        this.recordsList = [];

        this.dispatchEvent(new CustomEvent('valueselected', {
            detail: selectedRecord
        }));
    }

    handleInputBlur() {
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            if (!this.preventClosingOfSerachPanel) {
                this.recordsList = [];
            }
            this.preventClosingOfSerachPanel = false;
        }, DELAY);
    }
}