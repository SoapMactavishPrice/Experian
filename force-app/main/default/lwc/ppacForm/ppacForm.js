import { LightningElement } from 'lwc';
import createPPACRecord from '@salesforce/apex/PPACFormController.createPPACRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Annexure_1_Product_Approval from '@salesforce/resourceUrl/Annexure_1_Product_Approval';
import Annexure_2_Process_Approval_format from '@salesforce/resourceUrl/Annexure_2_Process_Approval_format';
import 	Annexure_3_Modification_to_existing_Product_Process_format from '@salesforce/resourceUrl/Annexure_3_Modification_to_existing_Product_Process_format';
import 	Annexure_4_Discontinuation_of_Product_and_Process_format from '@salesforce/resourceUrl/Annexure_4_Discontinuation_of_Product_and_Process_format';
import Annexure_5_Minutes_of_the_Meeting_Format from '@salesforce/resourceUrl/Annexure_5_Minutes_of_the_Meeting_Format';
import getApproverData from '@salesforce/apex/PPACApproverController.getApproverData';


export default class PpacForm extends LightningElement {

    // Fields
    entity;
    documentType;
    category;
    ppacDate;
    arbApplicability;
    arbNumber;
    psaApplicability;
    psaNumber;
    requestorEmail;
    subCategory;
    ppacName;
    isLoading = false;

    subCategoryOptions = [];

    subCategoryMapping = {

        ECICI_Product: [
            {
                label: 'Credit Services (CS)',
                value: 'Credit Services (CS)'
            },
            {
                label: 'Experian Consumer Services (ECS)',
                value: 'Experian Consumer Services (ECS)'
            }
        ],

        ECICI_Process: [
            { label: 'Data Operations', value: 'Data Operations' },
            { label: 'Consumer Support', value: 'Consumer Support' },
            { label: 'Customer Support', value: 'Customer Support' },
            { label: 'Data Intelligence', value: 'Data Intelligence' },
            { label: 'Model Governance', value: 'Model Governance' },
            { label: 'Technology', value: 'Technology' },
            { label: 'Product', value: 'Product' },
            { label: 'Client Success', value: 'Client Success' },
            { label: 'Human Resource', value: 'Human Resource' },
            { label: 'Legal', value: 'Legal' },
            { label: 'Risk', value: 'Risk' },
            { label: 'Compliance', value: 'Compliance' },
            { label: 'Information Security', value: 'Information Security' },
            { label: 'Finance', value: 'Finance' },
            { label: 'Marketing', value: 'Marketing' },
            { label: 'Data Acquisition', value: 'Data Acquisition' }
        ],

        ESIPL_Product: [
            {
                label: 'Decision Analytics',
                value: 'Decision Analytics'
            },
            {
                label: 'Identity & Fraud',
                value: 'Identity & Fraud'
            },
            {
                label: 'Software & Services',
                value: 'Software & Services'
            }
        ],

        ESIPL_Process: [
            {
                label: 'Decision Analytics',
                value: 'Decision Analytics'
            },
            {
                label: 'Identity & Fraud',
                value: 'Identity & Fraud'
            },
            {
                label: 'Software & Services',
                value: 'Software & Services'
            }
        ]
    };

    approverData = [];
    selectedApproverIds = [];
    approverColumns = [
        {
            label: 'Name',
            fieldName: 'Name'
        },
        {
            label: 'Role / Designation',
            fieldName: 'Role_Designation__c'
        }
    ];

    // UI control
    showArbNumber = false;
    showPsaNumber = false;

    // OPTIONS
    entityOptions = [
        { label: 'ECICI', value: 'ECICI' },
        { label: 'ESIPL', value: 'ESIPL' }
    ];

    documentOptions = [
        { label: 'Product', value: 'Product' },
        { label: 'Process', value: 'Process' }
    ];

    categoryOptions = [
        { label: 'New', value: 'New' },
        { label: 'Existing Renewal', value: 'Existing Renewal' }
    ];

    arbOptions = [
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' },
        { label: 'In Process', value: 'In Process' }
    ];

    psaOptions = [
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' },
        { label: 'In Process', value: 'In Process' }
    ];

    acceptedFormats = [
        '.pdf',
        '.doc',
        '.docx',
        '.xls',
        '.xlsx',
        '.ppt',
        '.pptx'
    ];

    // Uploaded Files
    uploadedFiles = [];

    // Sample Documents
    sampleDocuments = [
        {
            id: '1',
            srNo: '1',
            documentName: 'Annexure 1 Product Approval',
            fileUrl: Annexure_1_Product_Approval
        },
        {
            id: '2',
            srNo: '2',
            documentName: 'Annexure 2 Process Approval format',
            fileUrl: Annexure_2_Process_Approval_format
        },
        {
            id: '3',
            srNo: '3',
            documentName: 'Annexure 3 Modification to existing Product Process format',
            fileUrl: Annexure_3_Modification_to_existing_Product_Process_format
        },
        {
            id: '4',
            srNo: '4',
            documentName: 'Annexure 4 Discontinuation of Product and Process format',
            fileUrl: Annexure_4_Discontinuation_of_Product_and_Process_format
        },
        {
            id: '5',
            srNo: '5',
            documentName: 'Annexure 5 Minutes of the Meeting Format',
            fileUrl: Annexure_5_Minutes_of_the_Meeting_Format
        }
    ];


    sampleColumns = [
        {
            label: 'Documents',
            fieldName: 'documentName'
        },
        {
            type: 'button-icon',
            initialWidth: 100,
            typeAttributes: {
                iconName: 'utility:download',
                name: 'download',
                title: 'Download',
                variant: 'border-filled',
                alternativeText: 'Download'
            }
        }
    ];

    connectedCallback() {
        this.loadApprovers();
    }

    async loadApprovers() {
        try {
            const result = await getApproverData({
                ppacId: null
            });
            this.approverData = result.authorities;
        }
        catch(error) {
            console.error(error);
        }
    }

    handleApproverSelection(event) {
        const rows = event.detail.selectedRows;
        this.selectedApproverIds = rows.map(row => row.Id);
        console.log('Selected Approvers --> ', JSON.stringify(this.selectedApproverIds));
    }


    // DOWNLOAD
    handleRowAction(event) {

        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if(actionName === 'download') {
            window.open(row.fileUrl, '_blank');
        }
    }


    handleUploadFinished(event) {

        this.uploadedFiles = event.detail.files.map(
            file => file.documentId
        );

        console.log(
            'Uploaded File Ids --> ',
            JSON.stringify(this.uploadedFiles)
        );
    }

    // HANDLERS
    handleChange(event) {
        const field = event.target.dataset.field;
        this[field] = event.target.value;

        if(field === 'entity' || field === 'documentType') {
            this.updateSubCategoryOptions();
        }
    }

    updateSubCategoryOptions() {
        this.subCategory = null;
        this.subCategoryOptions = [];
        if(this.entity && this.documentType) {
            const key = this.entity + '_' + this.documentType;
            this.subCategoryOptions = this.subCategoryMapping[key] || [];
        }
    }

    handleArbChange(event) {
        this.arbApplicability = event.target.value;

        this.showArbNumber =
            this.arbApplicability === 'Yes' ||
            this.arbApplicability === 'In Process';

        if (!this.showArbNumber) {
            this.arbNumber = null;
        }
    }

    handlePsaChange(event) {
        this.psaApplicability = event.target.value;

        this.showPsaNumber =
            this.psaApplicability === 'Yes' ||
            this.psaApplicability === 'In Process';

        if (!this.showPsaNumber) {
            this.psaNumber = null;
        }
    }

    // SUBMIT
    async handleSubmit() {

        const allValid = [...this.template.querySelectorAll('lightning-input, lightning-combobox')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);

        if (!allValid) {
            return;
        }

        if(!this.selectedApproverIds || this.selectedApproverIds.length === 0) {
                this.showToast('Error', 'At least one approver needs to be selected', 'error');
                return;
            }

        let backendDocumentType = '';

        if(this.entity === 'ECICI' && this.documentType === 'Product') {
            backendDocumentType = 'ECICI_Product';
        }
        else if(this.entity === 'ECICI' && this.documentType === 'Process') {
            backendDocumentType = 'ECICI_Process';
        }
        else if(this.entity === 'ESIPL' && this.documentType === 'Product') {
            backendDocumentType = 'ESIPL_Product';
        }
        else if(this.entity === 'ESIPL' && this.documentType === 'Process') {
            backendDocumentType = 'ESIPL_Process';
        }

        // Build Salesforce record
        const recordInput = {
            Entity__c: this.entity,
            // Document_Type__c: this.documentType,
            Document_Type__c: backendDocumentType,
            Category__c: this.category,
            Date_of_PPAC_Meeting__c: this.ppacDate,
            ARB_Applicability__c: this.arbApplicability,
            ARB_Number__c: this.arbNumber,
            PSA_Applicability__c: this.psaApplicability,
            PSA_Number__c: this.psaNumber,
            Requestor_Email__c: this.requestorEmail,
            Sub_Category__c: this.subCategory,
            Name: this.ppacName
        };

        this.isLoading = true;

        try {
            const recordId = await createPPACRecord({
                record: recordInput,
                contentDocumentIds: this.uploadedFiles,
                approverIds: this.selectedApproverIds
            });

            this.isLoading = false;

            this.showToast('Success', 'Record created successfully', 'success');

            this.resetForm();

        } catch (error) {
            this.isLoading = false;
            console.error(error);
            this.showToast(
                'Error',
                error?.body?.message || 'Something went wrong',
                'error'
            );
        }
    }

    // TOAST
    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }

    // RESET
    resetForm() {
        this.entity = null;
        this.documentType = null;
        this.category = null;
        this.ppacDate = null;
        this.arbApplicability = null;
        this.arbNumber = null;
        this.psaApplicability = null;
        this.psaNumber = null;
        this.requestorEmail = null;

        this.showArbNumber = false;
        this.showPsaNumber = false;
        this.uploadedFiles = [];

        this.selectedApproverIds = [];
        this.selectedRows = [];

        this.subCategory = null;
        this.subCategoryOptions = [];
        this.ppacName = null;
    }
}