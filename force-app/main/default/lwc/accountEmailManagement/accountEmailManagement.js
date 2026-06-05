import { LightningElement, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountEmailManagementController.getAccounts';
import updateAccount from '@salesforce/apex/AccountEmailManagementController.updateAccount';
import updateAccountsFromCSV from '@salesforce/apex/AccountEmailManagementController.updateAccountsFromCSV';

export default class AccountEmailManagement extends LightningElement {

    @track records = [];
    @track recordsToDisplay = [];
    @track loading = false;

    // Search
    searchKey = '';

    // Pagination vars 
    @track page = 1;
    @track pageSize = "10";
    @track totalRecords = 0;
    @track totalPages = 0;
    @track start = 0;
    @track end = 0;

    // Page size options 
    pageSizeOptions = [
        { label: "5", value: "5" },
        { label: "10", value: "10" },
        { label: "25", value: "25" }
    ];

    // Modal
    @track isModalOpen = false;
    @track editId;
    @track editData = {};

    // DA Field Lists
    @track daLevel1List = [];
    @track daLevel2List = [];
    @track daLevel3List = [];

    // Static DA Field Arrays (Used for CSV)
    daLevel1Fields = [
        'DA_Level_1_Email_1__c','DA_Level_1_Email_2__c','DA_Level_1_Email_3__c',
        'DA_Level_1_Email_4__c','DA_Level_1_Email_5__c','DA_Level_1_Email_6__c',
        'DA_Level_1_Email_7__c','DA_Level_1_Email_8__c','DA_Level_1_Email_9__c',
        'DA_Level_1_Email_10__c'
    ];

    daLevel2Fields = [
        'DA_Level_2_Email_1__c','DA_Level_2_Email_2__c','DA_Level_2_Email_3__c',
        'DA_Level_2_Email_4__c','DA_Level_2_Email_5__c','DA_Level_2_Email_6__c',
        'DA_Level_2_Email_7__c','DA_Level_2_Email_8__c','DA_Level_2_Email_9__c',
        'DA_Level_2_Email_10__c'
    ];

    daLevel3Fields = [
        'DA_Level_3_Email_1__c','DA_Level_3_Email_2__c','DA_Level_3_Email_3__c',
        'DA_Level_3_Email_4__c','DA_Level_3_Email_5__c','DA_Level_3_Email_6__c',
        'DA_Level_3_Email_7__c','DA_Level_3_Email_8__c','DA_Level_3_Email_9__c',
        'DA_Level_3_Email_10__c'
    ];

    connectedCallback() {
        this.fetchAccounts();
    }

    fetchAccounts() {
        this.loading = true;

        getAccounts({ searchKey: this.searchKey })
            .then((result) => {
                this.records = result;
                this.totalRecords = result.length;
                this.page = 1;
                this.setPagination();
            })
            .finally(() => {
                this.loading = false;
            });
    }

    /* ---------------- SEARCH ---------------- */

    typingTimer;

    handleSearchChange(event) {
        this.searchKey = event.target.value;

        clearTimeout(this.typingTimer);

        this.typingTimer = setTimeout(() => {
            this.fetchAccounts();
        }, 400);
    }

    /* ---------------- PAGINATION ---------------- */

    setPagination() {
        const size = parseInt(this.pageSize, 10);
        this.totalPages = Math.ceil(this.totalRecords / size);
        this.updateRecordsToDisplay();
    }

    updateRecordsToDisplay() {
        const size = parseInt(this.pageSize, 10); 
        let startIndex = (this.page - 1) * size;
        let endIndex = startIndex + size;

        this.recordsToDisplay = this.records.slice(startIndex, endIndex);

        this.start = this.totalRecords === 0 ? 0 : startIndex + 1;  
        this.end = Math.min(endIndex, this.totalRecords); 
    }

    previousPage() {
        if (this.page > 1) {
            this.page--;
            this.updateRecordsToDisplay();
        }
    }

    nextPage() {
        if (this.page < this.totalPages) {
            this.page++;
            this.updateRecordsToDisplay();
        }
    }

    get disablePrev() {
        return this.page <= 1;
    }

    get disableNext() {
        return this.page >= this.totalPages;
    }

    handlePageSizeChange(event) {
        this.pageSize = event.detail.value;
        this.page = 1;
        this.setPagination();
    }

    /* ---------------- MODAL OPEN ---------------- */

    openEditModal(event) {
        this.editId = event.target.dataset.id;
        const acc = this.records.find(r => r.Id === this.editId);

        this.editData = { Id: this.editId }; // reset

        // Build 3 lists dynamically
        this.daLevel1List = [];
        this.daLevel2List = [];
        this.daLevel3List = [];

        for (let i = 1; i <= 10; i++) {

            let f1 = `DA_Level_1_Email_${i}__c`;
            let f2 = `DA_Level_2_Email_${i}__c`;
            let f3 = `DA_Level_3_Email_${i}__c`;

            this.daLevel1List.push({ api: f1, label: `DA Level 1 Email ${i}`, value: acc[f1] });
            this.daLevel2List.push({ api: f2, label: `DA Level 2 Email ${i}`, value: acc[f2] });
            this.daLevel3List.push({ api: f3, label: `DA Level 3 Email ${i}`, value: acc[f3] });

            this.editData[f1] = acc[f1];
            this.editData[f2] = acc[f2];
            this.editData[f3] = acc[f3];
        }

        this.isModalOpen = true;
    }

    /* ---------------- HANDLE FIELD CHANGE ---------------- */

    handleFieldChange(event) {
        const api = event.target.dataset.api;
        const val = event.target.value;

        this.editData[api] = val;

        const update = (list) => {
            list.forEach(f => {
                if (f.api === api) f.value = val;
            });
        };

        update(this.daLevel1List);
        update(this.daLevel2List);
        update(this.daLevel3List);
    }

    closeModal() {
        this.isModalOpen = false;
    }

    /* ---------------- SAVE ACCOUNT ---------------- */

    updateEmail() {
        this.loading = true;

        updateAccount({ accInput: this.editData })
            .then(() => {
                this.isModalOpen = false;
                this.fetchAccounts();
            })
            .finally(() => {
                this.loading = false;
            });
    }

    /* ---------------- CSV DOWNLOAD ---------------- */

    downloadCSV() {

        // CSV Header
        let header = [
            "Account Name",
            "Account ID",
            "BMID"
        ];

        header = header.concat(
            this.daLevel1Fields,
            this.daLevel2Fields,
            this.daLevel3Fields
        );

        let csv = header.join(",") + "\n";

        this.records.forEach(acc => {
            let row = [
                acc.Name,
                acc.Id,
                acc.Bureau_Member_Id__c || ""
            ];

            this.daLevel1Fields.forEach(f => row.push(acc[f] || ""));
            this.daLevel2Fields.forEach(f => row.push(acc[f] || ""));
            this.daLevel3Fields.forEach(f => row.push(acc[f] || ""));

            csv += row.join(",") + "\n";
        });

        let element = document.createElement("a");
        element.href = "data:text/csv;charset=utf-8," + encodeURI(csv);
        element.download = "Account_Email_Export.csv";
        element.click();
    }

    /* ---------------- CSV UPLOAD ---------------- */

    openCSVUpload() {
        this.template.querySelector('[data-id="csvUploader"]').click();
    }

    uploadCSV(event) {
        let file = event.target.files[0];
        if (!file) return;

        let reader = new FileReader();

        reader.onload = () => {
            let csv = reader.result;
            this.loading = true;

            updateAccountsFromCSV({ csvString: csv })
                .then(() => this.fetchAccounts())
                .finally(() => this.loading = false);
        };

        reader.readAsText(file);
    }
}