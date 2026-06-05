import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getChildRecords from '@salesforce/apex/updateCaseController.getChildCaseUploadCheckerItemRecords';
import approveUploadChunk from '@salesforce/apex/updateCaseController.approveUploadChunk';
import getUploadedCsvDownloadUrl from '@salesforce/apex/updateCaseController.getUploadedCsvDownloadUrl';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CaseUploadCheckerApprovalChild extends LightningElement {
    @track childData = [];
    parentId;
    totalLoadedCase = 0;
    isLoading = true;

    // button states
    isRunDisabled = false;
    isRefreshDisabled = true;    
    isDownloadResultDisabled = true;
    isDownloadErrorDisabled = true;

    // Progress numbers
    percentage = 0;
    successCase = 0;
    failedCase = 0;

    chunkSize = 10;
    errorRows = [];

    @wire(CurrentPageReference)
    getPageRef(pageRef) {
        if (pageRef?.state?.c__parentId) {
            this.parentId = pageRef.state.c__parentId;
            this.loadChildRecords();
        }
    }

    loadChildRecords() {
        this.isLoading = true;

        getChildRecords({ parentId: this.parentId })
            .then(data => {
                this.childData = data.map((row, index) => {
                    return {
                        ...row,
                        Serial_No: index + 1,
                        CaseNumber: row.Case_Number__r ? row.Case_Number__r.CaseNumber : '',
                        Status: '',
                        Message: ''
                    };
                });

                this.totalLoadedCase = this.childData.length;
                this.isLoading = false;

                // Reset buttons
                this.isRunDisabled = false;
                this.isRefreshDisabled = true;
                this.isDownloadResultDisabled = true;
                this.isDownloadErrorDisabled = true;
            })
            .catch(error => {
                console.error(error);
                this.isLoading = false;
            });
    }

    // ------- RUN UPDATE (chunk based) -------
    // async handleRunUpdate() {
    //     this.errorRows = [];
    //     this.isRunDisabled = true; // permanently disabled after click
    //     this.isRefreshDisabled = true;

    //     this.percentage = 0;
    //     this.successCase = 0;
    //     this.failedCase = 0;
    //     this.updateProgressBar();

    //     const allIds = this.childData.map(r => r.Id);

    //     const chunks = [];
    //     for (let i = 0; i < allIds.length; i += this.chunkSize) {
    //         chunks.push(allIds.slice(i, i + this.chunkSize));
    //     }

    //     let processedCount = 0;

    //     for (let chunk of chunks) {
    //         try {
    //             const results = await approveUploadChunk({
    //                 childIds: chunk,
    //                 parentId: this.parentId
    //             });

    //             results.forEach(r => {
    //                 processedCount++;

    //                 if (r.success) {
    //                     this.successCase++;
    //                 } else {
    //                     this.failedCase++;

    //                     // Store failed row
    //                     this.errorRows.push({
    //                         childId: r.childId,
    //                         caseId: r.caseId,
    //                         errorMessage: r.message
    //                     });
    //                 }

    //                 const idx = this.childData.findIndex(c => c.Id === r.childId);
    //                 if (idx !== -1) {
    //                     this.childData[idx].Status = r.success ? 'Success' : 'Failed';
    //                     this.childData[idx].Message = r.message;
    //                 }
    //             });

    //         } catch (err) {
    //             console.error('Chunk error:', err);
    //             chunk.forEach(id => {
    //                 processedCount++;
    //                 this.failedCase++;

    //                 this.errorRows.push({
    //                     childId: id,
    //                     caseId: null,
    //                     errorMessage: 'Chunk execution error'
    //                 });

    //                 const idx = this.childData.findIndex(c => c.Id === id);
    //                 if (idx !== -1) {
    //                     this.childData[idx].Status = 'Failed';
    //                     this.childData[idx].Message = 'Chunk execution error';
    //                 }
    //             });
    //         }

    //         // update progress %
    //         this.percentage = ((processedCount / allIds.length) * 100).toFixed(2);
    //         this.updateProgressBar();
    //     }

    //     // After processing
    //     this.percentage = 100;
    //     this.updateProgressBar();

    //     // Enable other buttons
    //     this.isRefreshDisabled = false;
    //     this.isDownloadResultDisabled = false;
    //     this.isDownloadErrorDisabled = false;
    // }


    // ------- RUN UPDATE (chunk based) -------
    async handleRunUpdate() {
        this.errorRows = [];

        this.isRunDisabled = true; // permanently disabled after click
        this.isRefreshDisabled = true;

        this.percentage = 0;
        this.successCase = 0;
        this.failedCase = 0;
        this.updateProgressBar();

        const allIds = this.childData.map(r => r.Id);

        const chunks = [];
        for (let i = 0; i < allIds.length; i += this.chunkSize) {
            chunks.push(allIds.slice(i, i + this.chunkSize));
        }

        let processedCount = 0;

        for (let chunk of chunks) {
            try {
                const results = await approveUploadChunk({
                    childIds: chunk,
                    parentId: this.parentId
                });

                results.forEach(r => {
                    processedCount++;

                    const idx = this.childData.findIndex(c => c.Id === r.childId);
                    const row = idx !== -1 ? this.childData[idx] : null;

                    if (r.success) {
                        this.successCase++;
                    } else {
                        this.failedCase++;

                        // Store failed rows safely
                        this.errorRows.push({
                            Name: row ? row.Name : '',
                            CaseNumber: row ? row.CaseNumber : '',
                            LastReply: row ? row.Last_Reply_from_Bank_Team__c : '',
                            Message: r.message
                        });
                    }

                    // Update UI table
                    if (row) {
                        row.Status = r.success ? 'Success' : 'Failed';
                        row.Message = r.message;
                    }
                });

            } catch (err) {
                console.error('Chunk error:', err);

                chunk.forEach(id => {
                    processedCount++;
                    this.failedCase++;

                    const idx = this.childData.findIndex(c => c.Id === id);
                    const row = idx !== -1 ? this.childData[idx] : null;

                    // Store failed row in errorRows
                    this.errorRows.push({
                        Name: row ? row.Name : '',
                        CaseNumber: row ? row.CaseNumber : '',
                        LastReply: row ? row.Last_Reply_from_Bank_Team__c : '',
                        Message: 'Chunk execution error'
                    });

                    // Update UI table
                    if (row) {
                        row.Status = 'Failed';
                        row.Message = 'Chunk execution error';
                    }
                });
            }

            // update percent
            this.percentage = ((processedCount / allIds.length) * 100).toFixed(2);
            this.updateProgressBar();
        }

        // After processing
        this.percentage = 100;
        this.updateProgressBar();

        // Enable other buttons
        this.isRefreshDisabled = false;
        this.isDownloadResultDisabled = false;
        this.isDownloadErrorDisabled = false;
    }


    updateProgressBar() {
        const progressBar = this.template.querySelector('c-progress-bar');
        if (progressBar) {
            progressBar.updateProgress(this.percentage);
        }
    }

    handleRefresh() {
        // Case 1: After Run Update is completed → clear table
        if (this.isRunDisabled && !this.isRefreshDisabled) {
            this.childData = [];
            this.totalLoadedCase = 0;
            return;
        }

        // Case 2: Normal refresh before running update → reload records
        this.loadChildRecords();
    }


    // ------- Download all rows -------
    downloadBeforeCsv() {
        getUploadedCsvDownloadUrl({ parentId: this.parentId })
        .then(url => {
            if (url) {
                window.open(url, '_blank');   // opens download in new tab
            } else {
                console.error('No file found.');
            }
        })
        .catch(err => {
            console.error('File fetch error:', err);
        });
    }

    downloadErrorCsv() {
          if (!this.errorRows || this.errorRows.length === 0) {
            this.showToast('Warning', 'No Error records found.', 'warning');
            return;
        }

        console.log('errorRows Records:', this.errorRows);

        const csv = this.generateFailedCSV(this.errorRows);
        const fileName = 'Error_Case_Upload_Items.csv';

        this.downloadCSV(csv, fileName);
    }

    generateFailedCSV(records) {
        const headers = [
            'Case Number',
            'Case ID',
            'Last Reply',
            'Error Message'
        ];

        let csv = headers.join(',') + '\n';

        records.forEach(rec => {
            let row = [
                rec.Name || '',
                rec.CaseNumber || '',
                rec.LastReply || '',
                rec.Message || ''
            ];

            csv += row.join(',') + '\n';
        });

        return csv;
    }


    downloadCSV(csvContent, fileName) {
        // Create a Blob for CSV
        const blob = new Blob([csvContent], { type: 'application/octet-stream' });

        // Create an object URL
        const url = URL.createObjectURL(blob);

        // Create an anchor link
        const link = document.createElement('a');
        link.href = url;
        link.download = fileName;

        // Required by Locker Service
        document.body.appendChild(link);

        // Trigger download
        link.click();

        // Cleanup
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
                mode: 'dismissable'
            })
        );
    }

}