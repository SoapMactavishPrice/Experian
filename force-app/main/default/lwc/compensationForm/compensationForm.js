import { LightningElement, track } from 'lwc';
import expe_Logo from '@salesforce/resourceUrl/experianLogo';
import saveCompensationDetails from '@salesforce/apex/ChildCaseDataTableController.saveCompensationDetails';
import getCaseNumber from '@salesforce/apex/ChildCaseDataTableController.getCaseNumber';
import isResponseAlreadySubmitted from '@salesforce/apex/ChildCaseDataTableController.isResponseAlreadySubmitted';


export default class CompensationForm extends LightningElement {

    expe_Logo = expe_Logo;
    @track selectedOption;
    @track error;
    @track disclaimerError = false;
    @track isLoading = false;
    @track caseNumber;
    @track isAlreadySubmitted = false;
    @track isInitialized = false;

    name = '';
    bank = '';
    acc = '';
    confirmAcc = '';
    ifsc = '';
    confirmIfsc = '';
    accepted = false;

    // Progressive enablement

    get isBankDisabled() {
        return !this.name;
    }

    get isAccDisabled() {
        return !this.bank;
    }

    get isConfirmAccDisabled() {
        return !this.acc;
    }

    get isIfscDisabled() {
        return !this.confirmAcc;
    }

    get isConfirmIfscDisabled() {
        return !this.ifsc;
    }

    get isDisclaimerDisabled() {
        return !this.confirmIfsc;
    }

    // get isSubmitDisabled() {
    //     if (this.selectedOption === 'OUT') {
    //         return false;
    //     }

    //     if (this.selectedOption === 'IN') {
    //         return !this.accepted;
    //     }

    //     return true;
    // }


    get isSubmitDisabled() {
        if (!this.selectedOption) return true;

        if (this.selectedOption === 'OUT') {
            return false;
        }

        if (this.selectedOption === 'IN') {
            // must accept disclaimer
            if (!this.accepted) return true;
            // all fields must be filled
            if (!this.name || !this.bank || !this.acc || !this.confirmAcc || !this.ifsc || !this.confirmIfsc) {
                return true;
            }
            // mismatch checks
            if (this.acc !== this.confirmAcc) return true;
            if (this.ifsc !== this.confirmIfsc) return true;
            // IFSC format check
            if (!this.validateIFSC(this.ifsc)) return true;
        }
        return false;
    }

    options = [
        { label: 'Opt-Out of Compensation', value: 'OUT' },
        { label: 'Opt-In for Compensation', value: 'IN' }
    ];

    get isOptOut() {
        return this.selectedOption === 'OUT';
    }

    get isOptIn() {
        return this.selectedOption === 'IN';
    }

    handleOptionChange(event) {
        this.selectedOption = event.detail.value;
        this.error = null;
    }

    // handleChange(event) {
    //     this[event.target.dataset.field] = event.target.value;
    // }

    handleChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.value;

        // CLEAR OLD ERROR (IMPORTANT)
        event.target.setCustomValidity('');
        event.target.reportValidity();

        this[field] = value;

        // Real-time validation
        // Account number match check
        if (field === 'confirmAcc' && this.acc && this.confirmAcc) {
            const input = event.target;

            if (this.acc !== this.confirmAcc) {
                input.setCustomValidity('Account numbers do not match');
            } else {
                input.setCustomValidity('');
            }
            input.reportValidity();
        }

        // if (field === 'ifsc' || field === 'confirmIfsc') {
        //     this[field] = value.toUpperCase();

        //     const input = event.target;

        //     if (field === 'confirmIfsc' && this.ifsc && this.confirmIfsc) {
        //         if (this.ifsc !== this.confirmIfsc) {
        //             input.setCustomValidity('IFSC codes do not match');
        //         } else {
        //             input.setCustomValidity('');
        //         }
        //     }

        //     input.reportValidity();
        // }

        if (field === 'ifsc' || field === 'confirmIfsc') {
            this[field] = value.toUpperCase();
            const input = event.target;

            // Format validation (FIRST)
            if (this[field] && !this.validateIFSC(this[field])) {
                input.setCustomValidity('Invalid IFSC format (Example: ABCD0XXXXXX)');
            } 
            // Match validation (ONLY for confirm field)
            else if (field === 'confirmIfsc' && this.ifsc && this.confirmIfsc) {
                if (this.ifsc !== this.confirmIfsc) {
                    input.setCustomValidity('IFSC codes do not match');
                } else {
                    input.setCustomValidity('');
                }
            } 
            else {
                input.setCustomValidity('');
            }

            input.reportValidity();
        }


        // Reset dependent fields
        switch(field) {
            case 'name':
                this.bank = '';
                this.acc = '';
                this.confirmAcc = '';
                this.ifsc = '';
                this.confirmIfsc = '';
                this.accepted = false;
                break;

            case 'bank':
                this.acc = '';
                this.confirmAcc = '';
                this.ifsc = '';
                this.confirmIfsc = '';
                this.accepted = false;
                break;

            case 'acc':
                this.confirmAcc = '';
                this.ifsc = '';
                this.confirmIfsc = '';
                this.accepted = false;
                break;

            case 'confirmAcc':
                this.ifsc = '';
                this.confirmIfsc = '';
                this.accepted = false;
                break;

            case 'ifsc':
                this.confirmIfsc = '';
                this.accepted = false;
                break;

            case 'confirmIfsc':
                this.accepted = false;
                break;
        }
    }


    handleAccept(event) {
        this.accepted = event.target.checked;
        this.disclaimerError = false;
    }

    validateIFSC(code) {
        return /^[A-Z]{4}0[A-Z0-9]{6}$/.test(code);
    }

    validateFields() {
        let valid = true;

        const inputs = this.template.querySelectorAll('lightning-input');
        inputs.forEach(input => {
            if (!input.checkValidity()) {
                input.reportValidity();
                valid = false;
            }
        });

        return valid;
    }


    handleSubmit() {
        this.isLoading = true;

        this.error = null;

        if (!this.recordId) {
            this.error = 'Missing Case reference';
            return;
        }

        // Must select option
        if (!this.selectedOption) {
            this.error = 'Please select your compensation preference';
            return;
        }

        // =========================
        // OPT-IN FLOW
        // =========================
        if (this.isOptIn) {

            if (!this.validateFields()) return;

            if (this.acc !== this.confirmAcc) {
                this.showFieldError('confirmAcc', 'Account numbers do not match');
                return;
            }

            if (this.ifsc !== this.confirmIfsc) {
                this.showFieldError('confirmIfsc', 'IFSC codes do not match');
                return;
            }

            if (!this.accepted) {
                this.error = 'Please accept the disclaimer';
                return;
            }

            saveCompensationDetails({
                recordId: this.recordId,
                isOptIn: true,
                accountHolderName: this.name,
                bankName: this.bank,
                accountNumber: this.acc,
                ifscCode: this.ifsc
            })
            .then(() => {
                this.isAlreadySubmitted = true;
            })
            .catch(error => {
                this.error = error?.body?.message || 'Error saving data';
            })
            .finally(()=>{
                this.isLoading = false;
            });
        }

        // =========================
        // OPT-OUT FLOW
        // =========================
        if (this.isOptOut) {

            saveCompensationDetails({
                recordId: this.recordId,
                isOptIn: false,
                accountHolderName: null,
                bankName: null,
                accountNumber: null,
                ifscCode: null
            })
            .then(() => {
                this.isAlreadySubmitted = true;
            })
            .catch(error => {
                this.error = error?.body?.message || 'Error saving data';
            })
            .finally(()=>{
                this.isLoading = false;
            });
        }
    }

    connectedCallback() {
        const params = new URLSearchParams(window.location.search);
        this.recordId = params.get('recordId');

        if(this.recordId){
            // isResponseAlreadySubmitted({ recordId: this.recordId })
            //     .then(result => {
            //         this.isAlreadySubmitted = result;
            //     });

            // getCaseNumber({ recordId: this.recordId })
            //     .then(result => {
            //         this.caseNumber = result;
            //     })
            //     .catch(error => {
            //         this.error = error?.body?.message || 'Error Fetching Case Number';
            //     });

            Promise.all([
                isResponseAlreadySubmitted({ recordId: this.recordId }),
                getCaseNumber({ recordId: this.recordId })
            ])
            .then(([isSubmitted, caseNum]) => {
                this.isAlreadySubmitted = isSubmitted;
                this.caseNumber = caseNum;
            })
            .catch(error => {
                this.error = error?.body?.message || 'Error loading data';
            })
            .finally(() => {
                this.isInitialized = true; // IMPORTANT
            });
        }
    }

    showFieldError(field, message) {
        const input = this.template.querySelector(`[data-field="${field}"]`);
        if (input) {
            input.setCustomValidity(message);
            input.reportValidity();
        }
    }
}