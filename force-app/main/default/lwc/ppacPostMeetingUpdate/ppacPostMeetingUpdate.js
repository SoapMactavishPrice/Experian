import { LightningElement, api, wire } from 'lwc';
import getPPACDetails from '@salesforce/apex/PPACPostMeetingController.getPPACDetails';
import savePostMeetingDetails from '@salesforce/apex/PPACPostMeetingController.savePostMeetingDetails';
import renameFiles from '@salesforce/apex/PPACPostMeetingController.renameFiles';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PpacPostMeetingUpdate extends LightningElement {

    @api recordId;
    momReleaseDate;
    subCategory;
    buHead;

    acceptedFormats = [
        '.pdf',
        '.doc',
        '.docx',
        '.xls',
        '.xlsx',
        '.ppt',
        '.pptx'
    ];

    // SUB CATEGORY OPTIONS
    subCategoryOptions = [];

    // BU HEAD OPTIONS
    buHeadOptions = [];

    // LOAD RECORD
    @wire(getPPACDetails, {
        ppacId: '$recordId'
    })
    wiredPPAC({ data, error }) {

        if(data) {
            this.momReleaseDate = data.MOM_Release_Date__c;
            this.subCategory = data.Sub_Category__c;
            this.buHead = data.BU_Head__c;
            this.prepareSubCategoryOptions(data);
            this.prepareBUHeadOptions(data);
        }
        else if(error) {
            console.error(error);
        }
    }

    // CHANGE
    handleChange(event) {
        const field = event.target.dataset.field;
        this[field] = event.target.value;
    }

    // SUB CATEGORY OPTIONS
    prepareSubCategoryOptions(data) {

        const docType = data.Document_Type__c;

        if(docType === 'ECICI_Product') {
            
            this.subCategoryOptions = [
                {
                    label: 'Credit Services (CS)',
                    value: 'Credit Services (CS)'
                },
                {
                    label: 'Experian Consumer Services (ECS)',
                    value: 'Experian Consumer Services (ECS)'
                }
            ];
        }
        else if(docType === 'ECICI_Process') {

            this.subCategoryOptions = [

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
            ];
        }
        else {

            this.subCategoryOptions = [

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
            ];
        }
    }

    // BU HEAD OPTIONS
    prepareBUHeadOptions(data) {

        const docType =
            data.Document_Type__c;

        if(docType === 'ECICI_Product') {

            this.buHeadOptions = [
                {
                    label: 'Majid Asadullah',
                    value: 'Majid Asadullah'
                },
                {
                    label: 'Bikram Singh',
                    value: 'Bikram Singh'
                }
            ];
        }
        else if(docType === 'ECICI_Process') {

            this.buHeadOptions = [

                {
                    label: 'Aditya Agrawal',
                    value: 'Aditya Agrawal'
                },
                {
                    label: 'Majid Asadullah',
                    value: 'Majid Asadullah'
                },
                {
                    label: 'Bikram Singh',
                    value: 'Bikram Singh'
                },
                {
                    label: 'Kunal Thakur',
                    value: 'Kunal Thakur'
                },
                {
                    label: 'Gunjan Malviya',
                    value: 'Gunjan Malviya'
                }
            ];
        }
        else {

            this.buHeadOptions = [
                {
                    label: 'Shaleen Srivastava',
                    value: 'Shaleen Srivastava'
                }
            ];
        }
    }

    // MOM FILES
    async handleMomUpload(event) {

        try {

            const documentIds =
                event.detail.files.map(
                    file => file.documentId
                );

            await renameFiles({
                contentDocumentIds: documentIds,
                prefix: 'MOM'
            });

            this.showToast(
                'Success',
                'MOM documents uploaded successfully',
                'success'
            );
        }
        catch(error) {

            console.error(error);

            this.showToast(
                'Error',
                'Error uploading MOM files',
                'error'
            );
        }
    }

    // REVISED PPAC
    async handlePPACUpload(event) {

        try {

            const documentIds =
                event.detail.files.map(
                    file => file.documentId
                );

            await renameFiles({
                contentDocumentIds: documentIds,
                prefix: 'Re_PPACNote'
            });

            this.showToast(
                'Success',
                'Revised PPAC documents uploaded successfully',
                'success'
            );
        }
        catch(error) {

            console.error(error);

            this.showToast(
                'Error',
                'Error uploading PPAC files',
                'error'
            );
        }
    }

    // SAVE
    async handleSave() {

        try {

            await savePostMeetingDetails({

                ppacId: this.recordId,

                momReleaseDate: this.momReleaseDate,

                subCategory: this.subCategory,

                buHead: this.buHead
            });

            this.showToast(
                'Success',
                'Post meeting details updated successfully',
                'success'
            );
        }
        catch(error) {

            console.error(error);

            this.showToast(
                'Error',
                error.body?.message || 'Something went wrong',
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
}