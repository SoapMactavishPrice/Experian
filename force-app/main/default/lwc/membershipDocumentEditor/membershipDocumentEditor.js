import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import getMembershipDocuments from '@salesforce/apex/MembershipDocumentController.getMembershipDocuments';
import getPicklistValues from '@salesforce/apex/MembershipDocumentController.getPicklistValues';
import saveMembershipDocuments from '@salesforce/apex/MembershipDocumentController.saveMembershipDocuments';
import initializeDocuments from '@salesforce/apex/MembershipDocumentController.initializeDocuments';

export default class MembershipDocumentEditor extends LightningElement { 
    
    _recordId;
    @track documentList = [];
    @track isLoading = false;
    @track hasRecords = false;
    
    // Picklist options cache
    picklistOptions = {
        Executive: [],
        TL: [],
        Admin: []
    };

    // Store unsaved changes: { recordId: { field: value } }
    pendingUpdates = {};

    @api
    get recordId() {
        return this._recordId;
    }
    set recordId(value) {
        this._recordId = value;
        if (value) {
            this.loadInitialData();
        }
    }

    get isSaveDisabled() {
        return this.isLoading;
    }

    /**
     * Fetch picklist values and documents for the current Lead
     */
    async loadInitialData() {
        this.isLoading = true;
        try {
            // Retrieve picklist values dynamically from Schema
            const picklists = await getPicklistValues();
            this.picklistOptions = {
                Executive: picklists.Executive || [],
                TL: picklists.TL || [],
                Admin: picklists.Admin || []
            };
            
            // Load actual records
            await this.loadDocuments();
        } catch (error) {
            this.showToast(
                'Error Loading Data', 
                (error.body ? error.body.message : error.message), 
                'error'
            );
        } finally {
            this.isLoading = false;
        }
    }

    /**
     * Queries the database for Membership Document records and maps them for UI binding
     */
    async loadDocuments() {
        const data = await getMembershipDocuments({ leadId: this._recordId });
        if (data && data.length > 0) {
            let index = 1;
            this.documentList = data.map(doc => {
                return {
                    ...doc,
                    srNo: index++,
                    // Pre-map picklist options with selection states
                    executiveOptions: this.picklistOptions.Executive.map(opt => ({
                        value: opt,
                        label: opt,
                        selected: opt === doc.Executive_Document_Status__c
                    })),
                    tlOptions: this.picklistOptions.TL.map(opt => ({
                        value: opt,
                        label: opt,
                        selected: opt === doc.TL_Document_Status__c
                    })),
                    adminOptions: this.picklistOptions.Admin.map(opt => ({
                        value: opt,
                        label: opt,
                        selected: opt === doc.Admin_Document_Status__c
                    }))
                };
            });
            this.hasRecords = true;
        } else {
            this.documentList = [];
            this.hasRecords = false;
        }
    }

    /**
     * Handle changes in inputs/selects inside the table cells
     */
    handleInputChange(event) {
        const recordId = event.target.dataset.id;
        const field = event.target.dataset.field;
        let value = event.target.type === 'checkbox' ? event.target.checked : event.target.value;

        // Keep documentList reactive and in sync
        this.documentList = this.documentList.map(doc => {
            if (doc.Id === recordId) {
                const updatedDoc = { ...doc, [field]: value };
                
                // Refresh option selection dynamically
                updatedDoc.executiveOptions = this.picklistOptions.Executive.map(opt => ({
                    value: opt,
                    label: opt,
                    selected: opt === updatedDoc.Executive_Document_Status__c
                }));
                updatedDoc.tlOptions = this.picklistOptions.TL.map(opt => ({
                    value: opt,
                    label: opt,
                    selected: opt === updatedDoc.TL_Document_Status__c
                }));
                updatedDoc.adminOptions = this.picklistOptions.Admin.map(opt => ({
                    value: opt,
                    label: opt,
                    selected: opt === updatedDoc.Admin_Document_Status__c
                }));
                
                return updatedDoc;
            }
            return doc;
        });

        // Stage the update for saving
        if (!this.pendingUpdates[recordId]) {
            this.pendingUpdates[recordId] = { Id: recordId };
        }
        this.pendingUpdates[recordId][field] = value;
    }

    /**
     * Save staged updates to database
     */
    async handleSave() {
        const recordsToSave = Object.values(this.pendingUpdates);
        
        if (recordsToSave.length === 0) {
            this.showToast('No Changes', 'No edits were made to save.', 'info');
            this.closeAction();
            return;
        }

        this.isLoading = true;
        try {
            await saveMembershipDocuments({ docs: recordsToSave });
            this.showToast('Success', 'Membership documents updated successfully.', 'success');
            this.pendingUpdates = {}; // Clear stage
            
            // Refresh Lead detail view to show updated fields
            await notifyRecordUpdateAvailable([{ recordId: this._recordId }]);
            this.closeAction();
        } catch (error) {
            this.showToast(
                'Save Error', 
                (error.body ? error.body.message : error.message), 
                'error'
            );
        } finally {
            this.isLoading = false;
        }
    }

    /**
     * Initialize standard document records if none exist
     */
    async handleInitialize() {
        this.isLoading = true;
        try {
            await initializeDocuments({ leadId: this._recordId });
            this.showToast('Success', 'Membership documents generated successfully.', 'success');
            await this.loadDocuments();
        } catch (error) {
            this.showToast(
                'Initialization Error', 
                (error.body ? error.body.message : error.message), 
                'error'
            );
        } finally {
            this.isLoading = false;
        }
    }

    /**
     * Cancel edits and close modal
     */
    handleCancel() {
        this.closeAction();
    }

    /**
     * Helper to close quick action
     */
    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    /**
     * Helper toast dispenser
     */
    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
                mode: variant === 'error' ? 'sticky' : 'dismissible'
            })
        );
    }
}
