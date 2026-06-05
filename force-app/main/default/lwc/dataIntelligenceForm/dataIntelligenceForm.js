import { LightningElement, track } from 'lwc';
import createCases from '@salesforce/apex/DataIntelligenceCaseController.createCases';
import searchAccounts from '@salesforce/apex/DataIntelligenceCaseController.searchAccounts';
import logo from '@salesforce/resourceUrl/ExperianLogoDI';
import bgShape from '@salesforce/resourceUrl/ExperianFloatingCard';

export default class DataIntelligenceForm extends LightningElement {

    logoUrl = logo;
    isLoading = false;

    // Fields
    memberName = '';
    fileName = '';
    requestDate = '';
    requestorName = '';
    requestorEmail = '';
    requestorDept = '';
    inputFileRecords = null;

    uploadedFiles = [];
    isFileReadInProgress = false;

    notificationMessage = '';
    notificationVariant = 'error';
    notificationTimer;

    get backgroundStyle() {
        return `
            --bg-image: url(${bgShape});
        `;
    }

    @track fileLineItems = [
        {
            id: Date.now(),
            fileName: '',
            inputFileRecords: null
        }
    ];

    memberSearchKey = '';
    accountResults = [];
    showAccountDropdown = false;

    selectedAccountId;
    selectedAccountName;

    // Product options (checkbox)
    @track productOptions = [
        { label: 'AR - 24', value: 'AR - 24', checked: false },
        { label: 'CP', value: 'CP', checked: false },
        { label: 'AR - 36', value: 'AR - 36', checked: false },
        { label: 'Score', value: 'Score', checked: false },
        { label: 'AR - 48', value: 'AR - 48', checked: false },
        { label: 'Income Segmentation', value: 'Income Segmentation', checked: false },
        { label: 'RSS', value: 'RSS', checked: false },
        { label: 'Enquiries', value: 'Enquiries', checked: false },
        { label: 'Custom Variable', value: 'Custom Variable', checked: false },

        { label: 'Portfolio Data', value: 'Portfolio Data', checked: false },
        { label: 'Sourcing Data', value: 'Sourcing Data', checked: false },
        { label: 'Complete Sync Data', value: 'Complete Sync Data', checked: false },
        { label: 'Only Trade Data', value: 'Only Trade Data', checked: false },
        { label: 'Fintech Enquiries', value: 'Fintech Enquiries', checked: false }

    ];

    // Bureau options (checkbox)
    @track bureauOptions = [
        { label: 'Consumer', value: 'Consumer', checked: false },
        { label: 'Commercial', value: 'Commercial', checked: false },
        { label: 'Hunter', value: 'Hunter', checked: false }
    ];

    get showNotification() {
        return Boolean(this.notificationMessage);
    }

    get notificationClass() {
        return `form-notification ${this.notificationVariant}`;
    }

    get uploadedFilesInfo() {
        if (!this.uploadedFiles.length) {
            return '';
        }
        return `${this.uploadedFiles.length} file(s) selected`;
    }

    clearNotification() {
        this.notificationMessage = '';
        if (this.notificationTimer) {
            clearTimeout(this.notificationTimer);
            this.notificationTimer = null;
        }
    }

    showNotificationMessage(message, variant) {
        this.clearNotification();
        this.notificationVariant = variant;
        this.notificationMessage = message;
        this.notificationTimer = setTimeout(() => {
            this.notificationMessage = '';
            this.notificationTimer = null;
        }, 10000);
    }

    showError(message) {
        this.showNotificationMessage(message, 'error');
    }

    showSuccess(message) {
        this.showNotificationMessage(message, 'success');
    }

    handleCloseNotification() {
        this.clearNotification();
    }

    handleInputChange(event) {
        this.clearNotification();
        const field = event.target.dataset.id;
        this[field] = event.target.value;
    }

    handleProductChange(event) {
        this.clearNotification();
        const value = event.target.dataset.id;
        const index = this.productOptions.findIndex(opt => opt.value === value);
        this.productOptions[index].checked = event.target.checked;
    }

    handleBureauChange(event) {
        this.clearNotification();
        const value = event.target.dataset.id;
        const index = this.bureauOptions.findIndex(opt => opt.value === value);
        this.bureauOptions[index].checked = event.target.checked;
    }

    readFileAsBase64(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = () => {
                const parts = (reader.result || '').split(',');
                const base64 = parts.length > 1 ? parts[1] : '';
                resolve({
                    fileName: file.name,
                    fileBody: base64,
                    contentType: file.type
                });
            };
            reader.onerror = () => reject(new Error(`Failed to read ${file.name}`));
            reader.readAsDataURL(file);
        });
    }

    handleFileChange(event) {
        this.clearNotification();

        const files = event.target.files;
        if (!files || files.length === 0) {
            this.uploadedFiles = [];
            this.isFileReadInProgress = false;
            return;
        }

        this.isFileReadInProgress = true;
        const fileList = Array.from(files);

        Promise.all(fileList.map(file => this.readFileAsBase64(file)))
            .then(result => {
                this.uploadedFiles = result.filter(file => file.fileName && file.fileBody);
                if (!this.uploadedFiles.length) {
                    this.showError('Unable to process selected file(s). Please reselect and try again.');
                }
            })
            .catch(() => {
                this.uploadedFiles = [];
                this.showError('Failed to read selected files. Please try again.');
            })
            .finally(() => {
                this.isFileReadInProgress = false;
            });
    }

    validateForm() {
        const hasProduct = this.productOptions.some(opt => opt.checked);
        const hasBureau = this.bureauOptions.some(opt => opt.checked);

        const hasValidRows = this.fileLineItems.length > 0 && this.fileLineItems.every(item => {
            const hasFileName = item.fileName && item.fileName.trim() !== '';
            const hasInputRecords = item.inputFileRecords !== null && item.inputFileRecords !== undefined && `${item.inputFileRecords}`.trim() !== '';
            return hasFileName && hasInputRecords;
        });

        const hasUploads = this.uploadedFiles.length > 0 && this.uploadedFiles.every(file => file.fileName && file.fileBody);

        return Boolean(
            this.selectedAccountId &&
            this.requestDate &&
            this.requestorName &&
            this.requestorEmail &&
            this.requestorDept &&
            hasUploads &&
            hasProduct &&
            hasBureau &&
            hasValidRows
        );
    }

    handleSubmit() {
        if (this.isFileReadInProgress) {
            this.showError('Files are still being processed. Please wait a moment and submit again.');
            return;
        }

        if (!this.validateForm()) {
            this.showError('All fields are mandatory.');
            return;
        }

        this.clearNotification();

        this.isLoading = true; // Start Spinner

        const selectedProducts = this.productOptions
            .filter(opt => opt.checked)
            .map(opt => opt.value)
            .join(';');

        const selectedBureau = this.bureauOptions
            .filter(opt => opt.checked)
            .map(opt => opt.value)
            .join(';');

        const firstFile = this.uploadedFiles[0] || {};

        const payload = {
            MemberAccountId: this.selectedAccountId,
            RequestDate: this.requestDate,
            RequestorName: this.requestorName,
            RequestorEmail: this.requestorEmail,
            RequestorDept: this.requestorDept,
            Product: selectedProducts,
            Bureau: selectedBureau,
            FileDetails: this.fileLineItems,
            UploadFiles: this.uploadedFiles,
            // Backward compatibility for older Apex versions expecting single file keys.
            UploadFileName: firstFile.fileName,
            UploadFileBody: firstFile.fileBody
        };

        createCases({ formData: payload })
            .then(caseIds => {
                const count = Array.isArray(caseIds) ? caseIds.length : 0;
                // this.showSuccess(`${count} record(s) inserted successfully with file attachment(s).`);
                this.showSuccess('Your request has been successfully submitted!');
            })
            .catch(error => {
                this.showError(error?.body?.message || 'An unexpected error occurred while submitting the form.');
            })
            .finally(() => {
                this.isLoading = false; // Stop Spinner
            });
    }

    handleFileRowChange(event) {
        this.clearNotification();
        const index = event.target.dataset.index;
        const field = event.target.dataset.field;

        this.fileLineItems[index][field] = event.target.value;
    }

    addRow() {
        this.clearNotification();
        this.fileLineItems = [
            ...this.fileLineItems,
            {
                id: Date.now(),
                fileName: '',
                inputFileRecords: null
            }
        ];
    }

    removeRow(event) {
        this.clearNotification();
        const index = event.target.dataset.index;

        if (this.fileLineItems.length === 1) {
            return;
        }

        this.fileLineItems.splice(index, 1);
        this.fileLineItems = [...this.fileLineItems];
    }

    handleMemberSearch(event) {
        this.clearNotification();
        this.memberSearchKey = event.target.value;

        if (this.memberSearchKey.length < 2) {
            this.showAccountDropdown = false;
            return;
        }

        searchAccounts({ searchKey: this.memberSearchKey })
            .then(result => {
                this.accountResults = result;
                this.showAccountDropdown = true;
            })
            .catch(() => {
                this.accountResults = [];
                this.showAccountDropdown = false;
            });
    }

    handleAccountSelect(event) {
        this.clearNotification();
        this.selectedAccountId = event.currentTarget.dataset.id;
        this.selectedAccountName = event.currentTarget.dataset.name;

        this.memberSearchKey = this.selectedAccountName;
        this.showAccountDropdown = false;
    }
}