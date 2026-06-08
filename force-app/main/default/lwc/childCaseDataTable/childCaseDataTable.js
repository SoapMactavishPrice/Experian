import { LightningElement, track } from 'lwc';
import getChildCasesByParent from '@salesforce/apex/ChildCaseDataTableController.getChildCasesByParent';
// import expe_Logo from '@salesforce/resourceUrl/experianLogo';

export default class ChildCaseDataTable extends LightningElement {

    // expe_Logo = expe_Logo;
    @track data = [];
    @track error;
    @track isLoading = true;
    @track totalLiableAmount = 0;

    // columns = [
    //     { label: 'Account Name', fieldName: 'Account_Name__c', initialWidth: 350 },
    //     { label: 'Case Number', fieldName: 'Case_Number__c', initialWidth: 220 },
    //     { label: 'Displayed Account Number', fieldName: 'Displayed_Account_number__c', initialWidth: 220 },
    //     { label: 'Sub Type Name', fieldName: 'Sub_Type_Name__c', initialWidth: 220 },
    //     { label: 'Sub Type 1 Name', fieldName: 'Sub_Type_1_Name__c', initialWidth: 220 },
    //     { label: 'Dispute Received Date', fieldName: 'Dispute_Received_Date__c', type: 'date', initialWidth: 220 },
    //     { label: 'Resolve Date', fieldName: 'Resolve_Date__c', type: 'date', initialWidth: 220 },
    //     { label: 'Status', fieldName: 'Status__c', initialWidth: 220 },
    //     { label: 'Delayed No of Days', fieldName: 'Delayed_No_of_Days__c', initialWidth: 220 },
    //     { label: 'Liable Amount(₹)', fieldName: 'Liable_Amount__c', type: 'number', initialWidth: 220 }
    // ];

    columns = [
        { label: 'Consumer Name', fieldName: 'Consumer_Name__c', initialWidth: 350 },
        { label: 'Consumer Email ID', fieldName: 'Consumer_Email_ID__c', initialWidth: 350 },
        { label: 'Case Number', fieldName: 'Case_Number__c', initialWidth: 220 },
        { label: 'Displayed Account Number', fieldName: 'Displayed_Account_number__c', initialWidth: 220 },
        { label: 'Complaint Category', fieldName: 'Sub_Type_Name__c', initialWidth: 220 },
        { label: 'Complaint Sub-Category', fieldName: 'Sub_Type_1_Name__c', initialWidth: 220 },
        { label: 'Liable Party', fieldName: 'Account_Name__c', initialWidth: 350 },
        { label: 'Dispute Received Date', fieldName: 'Dispute_Received_Date__c', type: 'date', initialWidth: 220 },
        { label: 'Dispute Resolution Date', fieldName: 'Resolve_Date__c', type: 'date', initialWidth: 220 },
        { label: 'Status', fieldName: 'Status__c', initialWidth: 220 },
        { label: 'No. of Days Delayed', fieldName: 'Delayed_No_of_Days__c', initialWidth: 220 },
        { label: 'Credit Institution Liability Amt.', fieldName: 'Liable_Amount__c', type: 'number', initialWidth: 250 },
        { label: 'Experian Liability Amt.', fieldName: 'Experian_Liability_Amt__c', type: 'number', initialWidth: 220 }
    ];

    recordId;

    connectedCallback() {
        const urlParams = new URLSearchParams(window.location.search);
        this.recordId = urlParams.get('recordId');

        if (this.recordId) {
            this.fetchCases();
        } else {
            this.error = 'Invalid or missing Case Id in URL';
            this.isLoading = false;
        }
    }

    fetchCases() {
        this.isLoading = true;

        getChildCasesByParent({ parentCaseId: this.recordId })
            .then(result => {
                this.data = result;
                this.error = null;

                // this.totalLiableAmount = result.reduce((sum, row) => {
                //     return sum + (row.Liable_Amount__c || 0);
                // }, 0);
            })
            .catch(error => {
                this.error = error?.body?.message || 'Error fetching case data';
                console.error(error);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }


    get formattedTotal() {
        return new Intl.NumberFormat('en-IN', {
            style: 'currency',
            currency: 'INR',
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(this.totalLiableAmount || 0);
    }
}