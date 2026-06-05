import { LightningElement, track } from 'lwc';
import getCaseArchivalRecords from '@salesforce/apex/CaseArchivalProcess.getCaseArchivalRecords';


export default class CaseArchivalListComp extends LightningElement {
    @track caseArchivalRecords = [];
    @track filters = { bmidType: '',caseType:''};
    documentSearchTerm;
    filteredData = [];


    connectedCallback() {
        getCaseArchivalRecords().then(result => {
            this.caseArchivalRecords = result;

            this.filteredData = this.caseArchivalRecords;

        });
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
    
        this.documentSearchTerm = event.target.value;

        this.filteredData = this.caseArchivalRecords.filter(item => {
            return (
                (this.filters.bmidType ? item.bmid?.includes(this.filters.bmidType) : true) &&
                (this.filters.caseType ? item.name?.includes(this.filters.caseType) : true)
                // (this.filters.priority ? item.Priority === this.filters.priority : true) 
                // (this.filters.dateTime ? item.CreatedDate === this.filters.dateTime : true) 
            );
        });
        
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

}