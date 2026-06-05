import { LightningElement, track } from 'lwc';
import getCaseArchivalRecords from '@salesforce/apex/CaseArchivalProcess.getCaseArchivalRecords';
import getCaseArchivalRecordsFiltered from '@salesforce/apex/CaseArchivalProcess.getCaseArchivalRecordsFiltered';
import getAccountDetailsByBMID from '@salesforce/apex/CaseArchivalProcess.getAccountDetailsByBMID';



export default class CaseArchivalBackupComponent extends LightningElement {
    @track caseArchivalRecords = [];
    @track filters = { bmidType: '',caseType:''};
    documentSearchTerm;
    filteredData = [];
    showAccountDetail = false;
    accountInfo;
    selectedBmid;
    hasSearched = false;


    connectedCallback() {
       /* getCaseArchivalRecords().then(result => {
            this.caseArchivalRecords = result;

            this.filteredData = this.caseArchivalRecords;

        });*/
    }

    // get caseArchivalLength() {
    //     if(this.caseArchivalRecords.length > 0) {
    //         return true;
    //     }
    //     return false;
    // }

    handleChange(event){
        const filterType = event.target.dataset.filter;
        const filterValue = event.target.value;
        
        this.filters = { ...this.filters, [filterType]: filterValue };
    }

    handleSearch(event) {
        console.log(this.filters.bmidType);
        console.log(this.filters.caseType)
        debugger;
    
        this.documentSearchTerm = event.target.value;

        getCaseArchivalRecordsFiltered({ bmid: this.filters.bmidType, caseNumber :  this.filters.caseType} ).then(result => {
            console.log(result);
            this.caseArchivalRecords = result;

            this.filteredData = this.caseArchivalRecords;
            this.hasSearched = true;

        }).catch(error => {
           console.log(error);
           this.filteredData = [];
           this.hasSearched = true;
        });

        /*this.filteredData = this.caseArchivalRecords.filter(item => {
            return (
                (this.filters.bmidType ? item.bmid?.includes(this.filters.bmidType) : true) &&
                (this.filters.caseType ? item.name?.includes(this.filters.caseType) : true)
                // (this.filters.priority ? item.Priority === this.filters.priority : true) 
                // (this.filters.dateTime ? item.CreatedDate === this.filters.dateTime : true) 
            );
        });*/
        
        //  // Filter by search term
        //  if (this.documentSearchTerm) {
    
        //     // if(this.filters.documentType == 'All Types'){
        //     //   this.resetFilters();
        //     // }
    
        //     const searchTerm = this.documentSearchTerm.toLowerCase();
        //     this.filteredData = this.caseArchivalRecords.filter(item => {
        //         return (
        //              item.productName.toLowerCase().includes(searchTerm) &&
        //              item.documentType.includes(this.filters.documentType)
        //         );
        //     });
    
            
        // }else{
        //   // this.filteredData = this.documentData;
        //   this.filteredData = this.caseArchivalRecords.filter(item => {
        //     return (
        //          item.documentType.includes(this.filters.documentType)
        //     );
        //   });
        // }
        
    }

    get hasResults() {
        return this.hasSearched && Array.isArray(this.filteredData) && this.filteredData.length > 0;
    }

    get showNoRecords() {
        return this.hasSearched && (!Array.isArray(this.filteredData) || this.filteredData.length === 0);
    }

    handleBmidClick(event) {
        const bmid = event.currentTarget.dataset.bmid;
        if (!bmid) {
            return;
        }
        this.selectedBmid = bmid;
        getAccountDetailsByBMID({ bmid })
            .then((result) => {
                this.accountInfo = result;
                this.showAccountDetail = true;
            })
            .catch((error) => {
                // eslint-disable-next-line no-console
                console.error(error);
            });
    }

    handleBackToSearch() {
        this.showAccountDetail = false;
        this.accountInfo = undefined;
    }
}