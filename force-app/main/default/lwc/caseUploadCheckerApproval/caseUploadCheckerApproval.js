import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getUploads from '@salesforce/apex/updateCaseController.getUploads';
import updateStatus from '@salesforce/apex/updateCaseController.updateStatus';
import getChildRecords from '@salesforce/apex/updateCaseController.getChildRecords';
import approveUpload from '@salesforce/apex/updateCaseController.approveUpload';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CaseUploadCheckerApproval extends NavigationMixin(LightningElement) {
    @track data;
    @track isLoading = false;

    wiredResult;
    @wire(getUploads)
    wiredRecords({ data, error }) {
        this.wiredResult = data;
        if (data) {
            this.data = data.map(row => {
                return {
                    ...row,
                    File_Uploaded_By_Name__c: row.File_Uploaded_By__r ? row.File_Uploaded_By__r.Name : '',
                    File_Uploaded_Date_Time__c: this.formatDate(row.File_Uploaded_Date_Time__c),
                    disableActions: row.Status__c === 'Approved' || row.Status__c === 'Rejected'
                };
            });
        } else if (error) {
            console.error(error);
        }
    }

    refreshData() {
        return refreshApex(this.wiredResult);
    }

    formatDate(dateString) {
        if (!dateString) {
            return '';
        }

        const dateObj = new Date(dateString);

        // Format options
        const options = {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        };

        return dateObj.toLocaleString('en-GB', options);
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


    // handleApprove(event) {
    //     const parentId = event.target.dataset.id;
    //     this.isLoading = true; // TURN ON SPINNER

    //     approveUpload({ parentId })
    //         .then(() => {
    //             console.log('Record approved and cases updated successfully.');
    //             this.updateRowAfterAction(parentId, 'Approved');
    //             this.showToast('Success', 'Record approved and cases updated successfully.', 'success');
    //             return this.refreshData();   // refresh the datatable
    //         })
    //         .then(() => {
    //             this.isLoading = false; // TURN OFF AFTER REFRESH
    //         })
    //         .catch(error => {
    //             console.error('Error in approve:', error);
    //             this.showToast('Error', 'Failed to approve record.', 'error');
    //             this.isLoading = false; // TURN OFF EVEN IF ERROR
    //         });
    // }

     handleApprove(event) {
        const parentId = event.target.dataset.id;
        console.log('Approve clicked, parent id ', parentId);

        // Build the URL for your LWC Tab
        let url = '/lightning/n/Case_Upload_Checker_Item?c__parentId=' + parentId;

        // Open in NEW TAB
        window.open(url, '_blank');
    }

    handleReject(event) {
        const rowId = event.target.dataset.id;
        updateStatus({ recordId: rowId, status: 'Rejected' })
            .then(() => {
                this.updateRowAfterAction(rowId, 'Rejected');
                this.showToast('Rejected', 'Record has been marked as Rejected.', 'warning');
            })
            .catch(error => {
                console.error('Error updating status', error);
                this.showToast('Error', 'Something went wrong while rejecting.', 'error');
            });
    }

    // Update the status in the local data for immediate UI feedback
    updateRowStatus(rowId, status) {
        this.data = this.data.map(row => {
            if (row.Id === rowId) {
                return { ...row, Status__c: status };
            }
            return row;
        });
    }

    updateRowAfterAction(rowId, status) {
        this.data = this.data.map(row => {
            if (row.Id === rowId) {
                return {
                    ...row,
                    Status__c: status,
                    disableActions: true // new property to control button state
                };
            }
            return row;
        });
    }

    handleDownload(event) {
        const parentId = event.target.dataset.id;

        getChildRecords({ parentId })
            .then(records => {
                if (!records || records.length === 0) {
                    this.showToast('Warning', 'No child records found for this upload.', 'warning');
                    return;
                }
                console.log('Csv Child', records);
                const csv = this.generateCSV(records);
                const fileName = 'CaseUploadItems_' + parentId + '.csv';

                this.downloadCSV(csv, fileName);
                this.showToast('Success', 'CSV downloaded successfully.', 'success');
            })
            .catch(error => {
                console.error('Error fetching child records:', error);
                this.showToast('Error', 'Failed to download CSV.', 'error');
            });
    }

    generateCSV(records) {
        const headers = ['Case Number', 'Case ID', 'Last Reply from Bank Team'];

        let csv = headers.join(',') + '\n';

        records.forEach(record => {
            let row = [
                record.Case_Number__r.CaseNumber || '',
                record.Case_ID__c || '',
                record.Last_Reply_from_Bank_Team__c || ''
            ];

            csv += row.join(',') + '\n';
        });

        return csv;
    }


    downloadCSV(csvContent, fileName) {
        const blob = new Blob([csvContent], { type: 'application/octet-stream' });

        const url = URL.createObjectURL(blob);
        const link = document.createElement('a');

        link.href = url;
        link.download = fileName;

        // Required for Locker Service
        document.body.appendChild(link);

        link.click();

        // Clean up
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
    }
}