import { LightningElement, api, wire } from 'lwc';
import getApproverData from '@salesforce/apex/PPACApproverController.getApproverData';
import saveApprovers from '@salesforce/apex/PPACApproverController.saveApprovers';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class PpacAssignApproverAction extends LightningElement {

    @api recordId;
    data = [];
    selectedRows = [];
    selectedAuthorityIds = [];
    wiredResult;

    columns = [
        {
            label: 'Name',
            fieldName: 'Name'
        },
        {
            label: 'Role / Designation',
            fieldName: 'Role_Designation__c'
        }
    ];

    // Load Data
    @wire(getApproverData, { ppacId: '$recordId' })
    wiredData(result) {
        this.wiredResult = result;

         if(result.data){
            this.data = result.data.authorities;
            this.selectedRows = result.data.selectedAuthorityIds;
            this.selectedAuthorityIds = result.data.selectedAuthorityIds;
        }
        else if(result.error){
            console.error(result.error);
        }
    }

    // Selection Change
    handleRowSelection(event){

        const rows = event.detail.selectedRows;

        this.selectedAuthorityIds = rows.map(row => row.Id);
    }

    // Save
    async handleSave(){
        try {

            await saveApprovers({
                ppacId: this.recordId,
                selectedAuthorityIds: this.selectedAuthorityIds
            });

            await refreshApex(this.wiredResult);

            this.showToast(
                'Success',
                'Approvers updated successfully',
                'success'
            );

            this.dispatchEvent(
                new CloseActionScreenEvent()
            );
        }
        catch(error){
            console.error(error);
            this.showToast(
                'Error',
                error.body?.message || 'Something went wrong',
                'error'
            );
        }
    }

    // Toast
    showToast(title, message, variant){

        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }

    handleCancel() {
        this.dispatchEvent(
            new CloseActionScreenEvent()
        );
    }
}