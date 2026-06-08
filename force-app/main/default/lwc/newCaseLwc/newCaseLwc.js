import { LightningElement, track } from 'lwc';
import getCaseType from '@salesforce/apex/NewCaseLwcController.getCaseType';
import createCase from '@salesforce/apex/NewCaseLwcController.createCase';
import getAccountName from '@salesforce/apex/NewCaseLwcController.getAccountName';
import createCaseCSV from '@salesforce/apex/NewCaseLwcController.createCaseCSV';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { NavigationMixin } from 'lightning/navigation';

export default class NewCaseLwc extends NavigationMixin(LightningElement) {
    selectedDate;
    @track showSpinner = false;

    @track saveDisabled = false;

    usedCodes = new Set();

    generateUniqueCode() {
        let code;
        do {
            code = Math.floor(1000 + Math.random() * 9000); // 4-digit code
        } while (this.usedCodes.has(code));

        this.usedCodes.add(code);
        return code;
    }
    preventNumbers(event) {
        const key = event.key;
        // Prevent digits (0-9)
        if (/\d/.test(key)) {
            event.preventDefault();
        }
    }


    handleCasePanChange(event) {
        this.saveDisabled = false;
        try {
            const input = event.target;
            const fieldLabel = input?.dataset?.label;
            const rawValue = input?.value;

            console.log('fieldLabel:', fieldLabel);
            console.log('rawValue:', rawValue);

           // if (!rawValue || !fieldLabel || fieldLabel !== "ContactPan") {
             //   console.warn('Invalid field or label. Skipping PAN validation.');
               // return;
            //}
            
if(fieldLabel =='ContactPan' || fieldLabel =='DisplayedKYC' || fieldLabel =='CorrectKYC' ){
            const value = rawValue.toUpperCase();
            input.value = value; // Update field to uppercase
            let errorMessage = "";

            const caseCode = parseInt(input.dataset.index, 10);
            console.log('caseCode:', caseCode);

            // Defensive: make sure caseFields exists
            if (!Array.isArray(this.caseFields)) {
                console.error('this.caseFields is not defined or not an array.');
                return;
            }

            const caseIndex = this.caseFields.findIndex(addr => addr.index === caseCode);
            console.log('caseIndex:', caseIndex);

            // PAN format validation
            ///if (value.length !== 10) {
            // errorMessage = "PAN must be exactly 10 characters long.";
            //} else {
            const firstFive = value.substring(0, 5);
            const nextFour = value.substring(5, 9);
            const lastChar = value.charAt(9);

            if (!/^[A-Z]{5}$/.test(firstFive)) {
                errorMessage = "First 5 characters must be letters (A–Z).";
                this.saveDisabled = true;
            } else if (!/^[0-9]{4}$/.test(nextFour)) {
                errorMessage = "Next 4 characters must be digits (0–9).";
                this.saveDisabled = true;
            } else if (!/^[A-Z]$/.test(lastChar)) {
                errorMessage = "Last character must be a letter (A–Z).";
                this.saveDisabled = true;
            }
            //}

            input.setCustomValidity(errorMessage);
            input.reportValidity();

            // Save the valid value into caseFields if index found
            if (caseIndex !== -1) {
                this.caseFields[caseIndex][fieldLabel] = value;
            } else {
                console.warn('No matching caseField found for index:', caseCode);
            }
}

        } catch (error) {
            console.error('Error in handleCasePanChange:', error);
        }
    }

    get today() {
        return new Date().toISOString().split('T')[0]; // Format: yyyy-mm-dd
    }

    handleCaseDateBRChange(event) {
        this.saveDisabled = false;
        const input = event.target;
        const label = input.dataset.label;
        const value = input.value;

        if (label === "Contact_Date_of_Birth") {
            const enteredDate = new Date(value);
            const today = new Date();
            today.setHours(0, 0, 0, 0); // Ignore time

            let errorMessage = "";
            if (enteredDate >= today) {
                errorMessage = "Date of Birth must be in the past and not today.";
                this.saveDisabled = true;
            }

            input.setCustomValidity(errorMessage);
            input.reportValidity();

            // Optionally update the value in caseFields
            const index = parseInt(input.dataset.index, 10);
                        const caseIndex = this.caseFields.findIndex(addr => addr.index === index);
            if (this.caseFields && this.caseFields[caseIndex]) {
                this.caseFields[caseIndex].Contact_Date_of_Birth = value;
            }
        }
    }


    handleCaseDateDisRaisedChange(event) {
        this.saveDisabled = false;

        const input = event.target;
        console.log('input : ',input);
        const label = input.dataset.label;
        const value = event.target.value;

        if (label === "Date_of_the_email_received") {
            const enteredDate = new Date(value);
            const today = new Date();
            today.setHours(0, 0, 0, 0);           // Remove time from today
            enteredDate.setHours(0, 0, 0, 0);     // Remove time from selected date

            let errorMessage = "";

            if (enteredDate > today) {
                errorMessage = "Dispute Received Date must be in the past or today.";
                this.saveDisabled = true;
            }

            input.setCustomValidity(errorMessage);
            input.reportValidity();

            // Optional: update value in caseFields array
            const index = parseInt(input.dataset.index, 10);
                        const caseIndex = this.caseFields.findIndex(addr => addr.index === index);
            console.log('OUTPUT : ',label,value,index);
            if ( this.caseFields[caseIndex]) {
                this.caseFields[caseIndex].Date_of_the_email_received = value;
            }
            console.log('OUTPUT :--> ',JSON.stringify(this.caseFields[caseIndex]));
        }
    }





    handleCaseMobileChange(event) {
        const input = event.target;
        const value = input.value;
        const label = input.dataset.label;
        this.saveDisabled = false;


        if (label === "ContactMobileNo" || label === "CorrectMobileNo" || label === "DisplayedMobileNo") {
            let errorMessage = "";

            if (!/^\d{10}$/.test(value)) {
                errorMessage = "Mobile number must be exactly 10 digits.";
                this.saveDisabled = true;

            }

            input.setCustomValidity(errorMessage);
            input.reportValidity();

            // Optionally update your tracked caseFields
            const index = parseInt(input.dataset.index, 10);
                                    const caseIndex = this.caseFields.findIndex(addr => addr.index === index);

            if (this.caseFields && this.caseFields[caseIndex]) {
                this.caseFields[caseIndex][label] = value;
            }
        }
    }


    handleCaseEmailChange(event) {
        const input = event.target;
        this.saveDisabled = false;
        const value = input.value || "";
        const label = input.dataset.label;
 
        if (label === "ContactEmailId" || label === "DisplayedEmail" || label === "CorrectEmail") {
            const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$/;
            let errorMessage = "";

            if (!emailRegex.test(value)) {
                errorMessage = "Email ID must be valid (e.g., abc123@gmail.com).";
                this.saveDisabled = true;
            }
            input.setCustomValidity(errorMessage);
            input.reportValidity();

            // Optional: update your array
            const index = parseInt(input.dataset.index, 10);
            const caseIndex = this.caseFields.findIndex(addr => addr.index === index);
            if (this.caseFields && this.caseFields[caseIndex]) {
                this.caseFields[caseIndex][label] = value;
            }
        }
    }

    handleCaseStatusChange(event) {
        const fieldName = event.target.dataset.label;
        const fieldValue = event.target.value;
        const caseCode = parseInt(event.target.dataset.index, 10); // Unique identifier
        const caseIndex = this.caseFields.findIndex(addr => addr.index === caseCode);

        if (caseIndex !== -1) {
            const input = event.target;
            let newValue = fieldValue;

            // ✅ Validation: Prevent 'Settled ' value
            if ((fieldName === "Displayed_Account_Status" || fieldName.Correct_Account_Status) && newValue.trim() === "Settled") {
                input.setCustomValidity("Displayed_Account_Status 'Settled' is not allowed.");
                input.reportValidity();
                newValue = ""; // Clear the value
            } else {
                input.setCustomValidity(""); // Clear any old errors
                input.reportValidity();
            }

            // ✅ Update caseFields if not invalid
            const updatedCase = { ...this.caseFields[caseIndex], [fieldName]: newValue };
            this.caseFields[caseIndex] = updatedCase;
            this.caseFields = [...this.caseFields]; // Trigger reactivity

            console.log(`Updated ${fieldName} for case ${caseCode}:`, newValue);
        }
    }


    @track caseFields = [];


    connectedCallback() {
        const today = new Date().toISOString().split('T')[0];
        this.selectedDate = today;

        this.getCaseTypeNew();

    }
    @track caseTypeId;

    getCaseTypeNew() {
        getCaseType().then(result => {
            this.caseTypeId = result;
            console.log('this.caseTypeId--', this.caseTypeId);

            this.addCases();
        });

    }

    addCases() {
        let temCon2 =
        {
            "index": this.generateUniqueCode(),
            "Case_Category": "Consumer",
            "Case_Complaints": "Report",
            "Case_Type_Lookup": this.caseTypeId,
            "Sub_Type_Lookup": "",
            "Sub_Type_1_Lookup": "",
             "Sub_Type_1_Lookup_Name": "",
            "Date_of_the_email_received": null,//this.selectedDate,
            "AccountId": "",
            "Displayed_Account_number": "",
            "Displayed_Account_Type": "",
            "Contact_Name": "",
            "ContactPan": "",
            "ContactMobileNo": "",
            
            "DisplayedMobileNo": "",
            "CorrectMobileNo": "",
            "DisplayedEmail": "",
            "CorrectEmail": "",
            "DisplayedKYC": "",
            "CorrectKYC": "",
            "Dis_Ern":"",
            
            "Contact_Date_of_Birth": "",
            "Contact_Address": "",
            "ContactEmailId": "",
            "Contact_Gender": "",

            "Displayed_Loan_Balance": "",
            "Correct_Loan_Balance": "",
            "Displayed_Overdue_Amount": "",
            "Correct_Overdue_Amount": "",
            "Displayed_Account_Status": "",
            "Correct_Account_Status": "",
            "Correct_Account_Opening_Date": "",
            "Displayed_Account_Opening_Date": "",



            "Displayed_loan_ownership": "",
            "Correct_loan_ownership": "",
            "Displayed_loan_type": "",
            "Correct_loan_type": "",
            "Corrected_Credit_Facility_Status": "",
            "Displayed_Credit_Facility_Status": "",



            "Correct_Name": "",
            "Displayed_Name": "",
            "Correct_Date_of_Birth": "",
            "Displayed_Date_of_Birth": "",
            "Displayed_Gender": "",
            "Correct_Gender": "",
            "DisplayedBankName":"",


            "Displayed_Mobile_No": "",
            "Correct_Mobile_No": "",
            "Correct_Address": "",
            "Displayed_Address": "",
            "Origin": "Phone",
            'isLoanBalance': false,
            'isOverDue': false,
            'isAccountStatus': false,
            'isAccOpenDate': false,
            'isLoanOwner': false,
            'isLoanType': false,
            'isCredit': false,
            'isDName': false,
            'isDOB': false,
            'isDG': false,
            'isMN': false,
            'isA1': false,
             "isMobileNo": false,
            "isEmail": false,
            "isKYC": false,

        }
        this.caseFields.push(temCon2);
    }

    removeCases(event) {
        if (this.caseFields.length > 1) {
            const addressCode = parseInt(event.target.dataset.index, 10);
            this.usedCodes.delete(addressCode);
            this.caseFields = this.caseFields.filter(address => address.index !== addressCode);
        }
    }

   handleCaseChange(event) {
    const fieldName = event.target.dataset.label;
    const fieldValue = event.target.value;
    const caseCode = parseInt(event.target.dataset.index, 10); // Unique identifier

    const caseIndex = this.caseFields.findIndex(addr => addr.index === caseCode);

    if (caseIndex !== -1) {
        let newValue = fieldValue;

        // If AccountId is changed
        if (fieldName === 'AccountId') {
            const selectedAccountId = fieldValue;
            console.log('Selected Account ID:', selectedAccountId);

            if (selectedAccountId) {
                getAccountName({ accountId: selectedAccountId })
                    .then(result => {
                        // ✅ Update Account Name and Account ID here
                        this.caseFields[caseIndex]['DisplayedBankName'] = result;
                        this.caseFields[caseIndex][fieldName] = selectedAccountId;

                        // Trigger reactivity
                        this.caseFields = [...this.caseFields];

                        console.log('Selected Account Name:', result);
                    })
                    .catch(error => {
                        console.error('Error fetching Account Name:', error);
                    });
            }
        } else {
            // For other fields, update normally
            this.caseFields[caseIndex][fieldName] = newValue;
            this.caseFields = [...this.caseFields];

            console.log(`Updated ${fieldName} for case ${caseCode}:`, newValue);
        }
    }
}

    



    lookUpV1Account(event) {
        const rowIndex = parseInt(event.target.dataset.index, 10); // Unique index
        console.log('rowIndex-->', rowIndex);

        const itemIndex = this.caseFields.findIndex(item => item.index === rowIndex);
        console.log('itemIndex-->', itemIndex);

        if (itemIndex === -1) return; // Exit if item not found


        const detail = event.detail;
        console.log(itemIndex, 'detail-->', JSON.stringify(detail));


        this.resetFields(itemIndex);


        if (detail) {
            const tempData = JSON.parse(JSON.stringify(detail));
            this.caseFields[itemIndex].Sub_Type_1_Lookup = tempData.id || '';
            this.caseFields[itemIndex].Sub_Type_1_Lookup_Name = tempData.mainField || '';

            if (tempData.mainField == 'Closed') {
                this.caseFields[itemIndex].isLoanBalance = true;
                this.caseFields[itemIndex].isOverDue = true;
                this.caseFields[itemIndex].isAccountStatus = true;
            } else if (tempData.mainField == 'Current Balance') {
                this.caseFields[itemIndex].isLoanBalance = true;
            } else if (tempData.mainField == 'Amount Overdue') {
                this.caseFields[itemIndex].isOverDue = true;
            }
             else if (tempData.mainField == 'Over due') {
                this.caseFields[itemIndex].isOverDue = true;
            } else if (tempData.mainField == 'Account Opened Date') {
                this.caseFields[itemIndex].isAccOpenDate = true;
            } else if (tempData.mainField == 'Individual' || tempData.mainField == 'Authorized User' || tempData.mainField == 'Joint' || tempData.mainField == 'Guarantor' || tempData.mainField == 'Deceased') {
                this.caseFields[itemIndex].isLoanOwner = true;
            } else if (tempData.mainField == 'Incorrect Name') {
                this.caseFields[itemIndex].isDName = true;
            } else if (tempData.mainField == 'Incorrect DOB') {
                this.caseFields[itemIndex].isDOB = true;
            } else if (tempData.mainField == 'Incorrect Gender') {
                this.caseFields[itemIndex].isDG = true;
            } else if (tempData.mainField == 'Incorrect Mobile Number') {
                this.caseFields[itemIndex].isMN = true;
            } else if (tempData.mainField == 'Incorrect Address') {
                this.caseFields[itemIndex].isA1 = true;
            }

             else if (tempData.mainField == 'Incorrect Mobile No') {
                this.caseFields[itemIndex].isMobileNo = true;
            }

             else if (tempData.mainField == 'Incorrect Email ID') {
                this.caseFields[itemIndex].isEmail = true;
            }

             else if (tempData.mainField == 'Incorrect KYC') {
                this.caseFields[itemIndex].isKYC = true;
            }

        } else {
            // Clear all fields if no detail
            this.caseFields[itemIndex].Sub_Type_Lookup = '';
            this.caseFields[itemIndex].Sub_Type_1_Lookup_Name = '';
        }

    }


    resetFields(itemIndex) {
        this.caseFields[itemIndex].isLoanBalance = false;
        this.caseFields[itemIndex].isOverDue = false;
        this.caseFields[itemIndex].isAccountStatus = false;
        this.caseFields[itemIndex].isAccOpenDate = false;
        this.caseFields[itemIndex].isLoanOwner = false;
        this.caseFields[itemIndex].isDName = false;
        this.caseFields[itemIndex].isDOB = false;

        this.caseFields[itemIndex].isDG = false;
        this.caseFields[itemIndex].isMN = false;
        this.caseFields[itemIndex].isA1 = false;
        this.caseFields[itemIndex].isMobileNo = false;
        this.caseFields[itemIndex].isEmail = false;
        this.caseFields[itemIndex].isKYC = false;
    }

    lookUpAccount(event) {
        const rowIndex = parseInt(event.target.dataset.index, 10); // Unique index
        console.log('rowIndex-->', rowIndex);

        const itemIndex = this.caseFields.findIndex(item => item.index === rowIndex);
        console.log('itemIndex-->', itemIndex);



        if (itemIndex === -1) return; // Exit if item not found


        const detail = event.detail;
        console.log(itemIndex, 'detail-->', JSON.stringify(detail));
        this.caseFields[itemIndex].isLoanType = false;
        this.caseFields[itemIndex].isCredit = false;


        this.resetFields(itemIndex);
        if (detail) {
            const tempData = JSON.parse(JSON.stringify(detail));
            this.caseFields[itemIndex].Sub_Type_Lookup = tempData.id || '';
            if (!tempData.id) {
                this.caseFields[itemIndex].Sub_Type_1_Lookup = null;
            }

            if (tempData.mainField == 'Account Type') {
                this.caseFields[itemIndex].isLoanType = true;
            }

            if (tempData.mainField == 'Credit Facility Status') {
                this.caseFields[itemIndex].isCredit = true;
            }



        } else {
            this.caseFields[itemIndex].Sub_Type_Lookup = null;
            this.caseFields[itemIndex].Sub_Type_1_Lookup = null;
        }


    }


    handleCancel() {
        this.caseFields = [];
        this.addCases();
    }

    handleSave() {
        console.log('save case-->', JSON.stringify(this.caseFields));
        let tempCheck = true;

        for (let csef of this.caseFields) {


            const today = new Date();
            const receivedDateStr = csef.Date_of_the_email_received;
            console.log(csef.Date_of_the_email_received, receivedDateStr > today)
            if (receivedDateStr) {
                const receivedDate = new Date(receivedDateStr);

                // Check if received date is in the future
                if (receivedDate > today) {
                    this.showToast('Error', 'Date of the email received should not be a future date.', 'error');
                    tempCheck = false;
                }
            }


            

            if (csef.Sub_Type_1_Lookup_Name =='SF/WD/WO/SETTLED/RES') {
                    this.showToast('Error', 'Please change the Sub Type', 'error');
                    tempCheck = false;
            }

            if (csef.Sub_Type_1_Lookup_Name =='Incorrect KYC') {
                if(csef.DisplayedKYC =='' || csef.DisplayedKYC ==null || csef.DisplayedKYC==undefined ){
                    this.showToast('Error', 'Please Fill Displayed PAN No', 'error');
                    tempCheck = false;
                }

                if(csef.CorrectKYC =='' || csef.CorrectKYC ==null || csef.CorrectKYC==undefined ){
                    this.showToast('Error', 'Please Fill Correct PAN No', 'error');
                    tempCheck = false;
                }
                
            }


            if (csef.Sub_Type_1_Lookup_Name =='Incorrect Email ID') {
                if(csef.DisplayedEmail =='' || csef.DisplayedEmail ==null || csef.DisplayedEmail==undefined ){
                    this.showToast('Error', 'Please Fill Displayed Email Id', 'error');
                    tempCheck = false;
                }

                if(csef.CorrectEmail =='' || csef.CorrectEmail ==null || csef.CorrectEmail==undefined ){
                    this.showToast('Error', 'Please Fill Correct Email Id', 'error');
                    tempCheck = false;
                }
                
            }

             if (csef.Sub_Type_1_Lookup_Name =='Incorrect Mobile No') {
                if(csef.DisplayedMobileNo =='' || csef.DisplayedMobileNo ==null || csef.DisplayedMobileNo==undefined ){
                    this.showToast('Error', 'Please Fill Displayed Mobile No', 'error');
                    tempCheck = false;
                }

                if(csef.CorrectMobileNo =='' || csef.CorrectMobileNo ==null || csef.CorrectMobileNo==undefined ){
                    this.showToast('Error', 'Please Fill Correct Mobile No', 'error');
                    tempCheck = false;
                }
                
            }



           
        


            let displayedStatus = csef.Displayed_Account_Status;
            console.log('OUTPUT : ',displayedStatus);
            if (displayedStatus && displayedStatus.trim() === 'Settled') {
                this.showToast('Error', 'Displayed_Account_Status ->"Settled" is not allowed.', 'error');
                tempCheck = false;
            }

            // ✅ Check only if Correct_Account_Status exists
            let correctStatus = csef.Correct_Account_Status;
            console.log('correctStatus : ',correctStatus);
            if (correctStatus && correctStatus.trim() === 'Settled') {
                this.showToast('Error', 'Correct Account Status ->"Settled" is not allowed.', 'error');
                tempCheck = false;
            }


            let Origin = csef.Origin;
            console.log('correctStatus : ',correctStatus);
            if (Origin && Origin.trim() === 'Portal') {
                this.showToast('Error', 'Origin ->"Portal" is not allowed.', 'error');
                tempCheck = false;
            }

            

        }


        setTimeout(() => {


            if (tempCheck) {
                this.showSpinner = true;


                console.log('Save 0-->   OUTPUT : ',JSON.stringify(this.caseFields));

                createCase({ js: JSON.stringify(this.caseFields) })
                    .then(result => {
                        this.showSpinner = false;
                        if (result.Status == 'Success') {
                            this.showToast('Success', result.Message, 'Success');
                            //let caseId = result.caseId;
                            //c/accountFormDetailssetTimeout(() => {
                            //window.location.reload();
                            //}, 1000);

                            this.handleCancel();


                        } else if (result.Status == 'Failed') {
                            this.showToast('Error', result.Message, 'Error');
                        }

                    })
            }
        }, 500);

    }


    showToast(title, msg, vari) {
        const event = new ShowToastEvent({
            title: title,
            message: msg,
            variant: vari,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }


    handleProceed(recId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recId, // Replace with your recordId
                actionName: 'view'
            }
        });

    }



    loanTypeOptions = [
        { label: 'Auto Loan (Personal)', value: 'Auto Loan (Personal)' },
        { label: 'Housing Loan', value: 'Housing Loan' },
        { label: 'Property Loan', value: 'Property Loan' },
        { label: 'Loan Against Shares / Securities', value: 'Loan Against Shares / Securities' },
        { label: 'Personal Loan', value: 'Personal Loan' },
        { label: 'Consumer Loan', value: 'Consumer Loan' },
        { label: 'Gold Loan', value: 'Gold Loan' },
        { label: 'Education Loan', value: 'Education Loan' },
        { label: 'Loan to Professional', value: 'Loan to Professional' },
        { label: 'Credit Card', value: 'Credit Card' },
        { label: 'Leasing', value: 'Leasing' },
        { label: 'Overdraft', value: 'Overdraft' },
        { label: 'Two-Wheeler Loan', value: 'Two-Wheeler Loan' },
        { label: 'Non-Funded Credit Facility', value: 'Non-Funded Credit Facility' },
        { label: 'Loan Against Bank Deposits', value: 'Loan Against Bank Deposits' },
        { label: 'Fleet Card', value: 'Fleet Card' },
        { label: 'Commercial Vehicle Loan', value: 'Commercial Vehicle Loan' },
        { label: 'Seller Financing', value: 'Seller Financing' },
        { label: 'GECL Loan Secured', value: 'GECL Loan Secured' },
        { label: 'GECL Loan Unsecured', value: 'GECL Loan Unsecured' },
        { label: 'Secured Credit Card', value: 'Secured Credit Card' },
        { label: 'Used Car Loan', value: 'Used Car Loan' },
        { label: 'Construction Equipment Loan', value: 'Construction Equipment Loan' },
        { label: 'Tractor Loan', value: 'Tractor Loan' },
        { label: 'Corporate Credit Card', value: 'Corporate Credit Card' },
        { label: 'Kisan Credit Card', value: 'Kisan Credit Card' },
        { label: 'Loan on Credit Card', value: 'Loan on Credit Card' },
        { label: 'Prime Minister Jaan Dhan Yojana – Overdraft', value: 'Prime Minister Jaan Dhan Yojana – Overdraft' },
        { label: 'Mudra Loans – Shishu / Kishor / Tarun', value: 'Mudra Loans – Shishu / Kishor / Tarun' },
        { label: 'Microfinance – Business Loan', value: 'Microfinance – Business Loan' },
        { label: 'Microfinance – Personal Loan', value: 'Microfinance – Personal Loan' },
        { label: 'Microfinance – Housing Loan', value: 'Microfinance – Housing Loan' },
        { label: 'Microfinance – Others', value: 'Microfinance – Others' },
        { label: 'Pradhan Mantri Awas Yojana - Credit Link Subsidy Scheme MAY CLSS', value: 'Pradhan Mantri Awas Yojana - Credit Link Subsidy Scheme MAY CLSS' },
        { label: 'P2P Personal Loan', value: 'P2P Personal Loan' },
        { label: 'P2P Auto Loan', value: 'P2P Auto Loan' },
        { label: 'P2P Education Loan', value: 'P2P Education Loan' },
        { label: 'Business Loan – Secured', value: 'Business Loan – Secured' },
        { label: 'Business Loan – General', value: 'Business Loan – General' },
        { label: 'Business Loan – Priority Sector – Small Business', value: 'Business Loan – Priority Sector – Small Business' },
        { label: 'Business Loan – Priority Sector – Agriculture', value: 'Business Loan – Priority Sector – Agriculture' },
        { label: 'Business Loan – Priority Sector – Others', value: 'Business Loan – Priority Sector – Others' },
        { label: 'Business Non-Funded Credit Facility – General', value: 'Business Non-Funded Credit Facility – General' },
        { label: 'Business Non-Funded Credit Facility-Priority Sector- Small Business', value: 'Business Non-Funded Credit Facility-Priority Sector- Small Business' },
        { label: 'Business Non-Funded Credit Facility-Priority Sector-Agriculture', value: 'Business Non-Funded Credit Facility-Priority Sector-Agriculture' },
        { label: 'Business Non-Funded Credit Facility-Priority Sector-Others', value: 'Business Non-Funded Credit Facility-Priority Sector-Others' },
        { label: 'Business Loan Against Bank Deposits', value: 'Business Loan Against Bank Deposits' },
        { label: 'Business Loan – Unsecured', value: 'Business Loan – Unsecured' },
        { label: 'Short Term Personal Loan', value: 'Short Term Personal Loan' },
        { label: 'Priority Sector- Gold Loan', value: 'Priority Sector- Gold Loan' },
        { label: 'Temporary Overdraft', value: 'Temporary Overdraft' },
        { label: 'Other', value: 'Other' }
    ];


    /* Newly Added Code is below this - bulk upload functionality */

    // acceptedFormats = ['.csv'];
    get acceptedFormats() {
        return 'text/csv';
    }
    disabledDone = true;
    csvData = [];
    columns = [];
    isDownloadResult = true;
    isDownloadError = true;

    activeTab = 'new';

    get disableStartUpload() {
        return this.disabledDone || !this.isDownloadResult || !this.isDownloadError;
    }


    headerMap = {
        "Case Category": "Case_Category__c",
        "Case Complaint": "Case_Complaints__c",
        "Case Type Name": "Case_Type_Lookup__c",
        "Sub Type Name": "Sub_Type_Lookup__c",
        "Sub Type 1 Name": "Sub_Type_1_Lookup__c",
        "Dispute Received Date": "Date_of_the_email_received__c",
        "Displayed Bank Name": "Displayed_Bank_Name__c",
        "Displayed Account number": "Displayed_Account_number__c",
        "Displayed Account Type": "Displayed_Account_Type__c",
        "Dispute Detail": "Dispute_Detail__c",
        "Contact_Name": "Contact_Name__c",
        "ContactPan": "ContactPan__c",
        "ContactMobileNo": "ContactMobileNo__c",
        "Contact_Date_of_Birth": "Contact_Date_of_Birth__c",
        "Contact_Address": "Contact_Address__c",
        "ContactEmailId": "ContactEmailId__c",
        "Contact_Gender": "Contact_Gender__c",
        "ERN": "Dis_Ern__c",
        "ERN NO": "Dis_Ern__c",
        "Status": "Status",
        "Error Msg": "Message"
    };


    displayColumnsOrder = [
        "Sub Type Name",
        "Sub Type 1 Name",
        "Dispute Received Date",
        "Displayed Bank Name",
        "Displayed Account number",
        "Displayed Account Type",
        "Dispute Detail",
        "Contact_Name",
        "ContactPan",
        "ContactMobileNo",
        "Contact_Date_of_Birth",
        "Contact_Address",
        "ContactEmailId",
        "Contact_Gender",
        "ERN"
    ];

    displayLabelMap = {
        "Sub Type Name": "Sub Type",
        "Sub Type 1 Name": "Sub Type 1",
        "Dispute Detail": "Dispute Detail",
        "Contact_Name": "Contact Name",
        "ContactPan": "Contact PAN",
        "ContactMobileNo": "Contact Mobile No",
        "Contact_Date_of_Birth": "Date of Birth",
        "Contact_Address": "Contact Address",
        "ContactEmailId": "Contact Email ID",
        "Contact_Gender": "Contact Gender"
    };


    getExportHeaders() {
        return [
            'Case Category',
            'Case Complaint',
            'Case Type Name',
            'Sub Type Name',
            'Sub Type 1 Name',
            'Dispute Received Date',
            'Displayed Bank Name',
            'Displayed Account number',
            'Displayed Account Type',
            'Dispute Detail',
            'Contact_Name',
            'ContactPan',
            'ContactMobileNo',
            'Contact_Date_of_Birth',
            'Contact_Address',
            'ContactEmailId',
            'Contact_Gender',
            'ERN',
            'Status',
            'Error Msg'
        ];
    }

    mandatoryFields = [
        'Case_Category__c',
        'Case_Complaints__c',
        'Case_Type_Lookup__c',
        'Sub_Type_Lookup__c',
        'Sub_Type_1_Lookup__c',
        'Date_of_the_email_received__c',
        'Displayed_Bank_Name__c',
        'Displayed_Account_number__c',
        'Displayed_Account_Type__c',
        'Dispute_Detail__c',
        'Contact_Name__c',
        'ContactPan__c',
        'ContactMobileNo__c',
        'Contact_Date_of_Birth__c',
        'Contact_Address__c',
        'ContactEmailId__c',
        'Contact_Gender__c',
        'Dis_Ern__c'
    ];

    hasMissingMandatoryField(apexObj) {
        return this.mandatoryFields.some(field => {
            const value = apexObj[field];
            return (
                value === undefined ||
                value === null ||
                value.toString().trim() === ''
            );
        });
    }



    handleTabChange(event) {
        this.activeTab = event.target.value;
    }


    handleDownloadSample() {
        const headers = Object.keys(this.headerMap).join(',');
        this.downloadCsv(headers, 'Case_Sample');
    }


    downloadCsv(row, fileNamePrefix) {

        const csvContent = row + '\n'; // newline so Excel formats properly

        let downloadElement = document.createElement('a');

        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvContent);
        downloadElement.target = '_self';
        downloadElement.download = fileNamePrefix + '.csv';

        document.body.appendChild(downloadElement);
        downloadElement.click();
        document.body.removeChild(downloadElement);
    }


    handleFileChange(event) {

        const file = event.target.files[0];
        this.csvData = [];
        this.disabledDone = true;
        console.log('Inside File Chnage');

      if (file && file.name.endsWith('.csv')) {
            console.log('Inside IF File Chnage');
            const reader = new FileReader();
            reader.onload = () => {
                console.log('Inside reader onload');
                let csvData = reader.result;
                csvData = csvData.replace(/\r\n/g, '\n').replace(/\r/g, '\n');
                //  FIX BROKEN UNICODE SPACES
                csvData = csvData
                    .replace(/\u00A0/g, ' ')
                    .replace(/\u2007/g, ' ')
                    .replace(/\u202F/g, ' ')
                    .replace(/\uFFFD/g, ' ');
                // const cleanedCSV = csvData.replace(/"(.*?)"/g, (match, p1) => {
                //     return p1.replace(/,/g, ';');
                // });
                // this.processCSV(cleanedCSV);
                this.processCSV(csvData);
                console.log('After process csv');
                this.disabledDone = false;
            };

            // reader.readAsText(file);
            reader.readAsText(file, 'UTF-8');

        } else {
            alert('Please upload a valid CSV file.');
        }
    }

    processCSV(csv) {
        console.log('Inside process csv');

        const rows = csv.split('\n');
        // const csvHeaders = rows[0]
        //     .split(',')
        //     .map(h => h.trim())
        //     .filter(h => h !== '');

        const csvHeaders = rows[0]
            .split(',')
            .map(h => {
                let header = h.trim();

                // NORMALIZE ERN HEADERS
                if (header.toUpperCase() === 'ERN NO') {
                    header = 'ERN';
                }

                return header;
            })
            .filter(h => h !== '');

        const apiHeaders = csvHeaders.map(h => this.headerMap[h]);

        this.columns = this.displayColumnsOrder.map(h => ({
            label: this.displayLabelMap[h] || h,
            fieldName: h,
            type: 'text',
            initialWidth: 180
        }));

        this.columns.push(
            { label: 'Status', fieldName: 'Status', type: 'text', initialWidth: 120 },
            { label: 'Error Msg', fieldName: 'Message', type: 'text', initialWidth: 260 }
        );

        this.csvData = [];

        rows.slice(1).forEach((row, index) => {

            // const values = row.match(/(".*?"|[^",]+)(?=\s*,|\s*$)/g)
            //                 ?.map(v => v.replace(/^"|"$/g, '').trim());

            const values = row.split(/,(?=(?:(?:[^"]*"){2})*[^"]*$)/) // split on commas not inside quotes
                           .map(v => v.replace(/^"|"$/g, '').trim());

            // CRITICAL SAFETY CHECK
            // if (!values || !values.length) return;
            if (!values || values.every(v => v === '')) return;

            const obj = {};
            const apexObj = {};

            csvHeaders.forEach((key, i) => {
                const val = values[i] ? values[i].trim() : '';
                apexObj[apiHeaders[i]] = val;
                obj[key] = val;
            });

            obj.Status = '';
            obj.Message = '';
            obj.index = index;
            obj._apex = apexObj;

            this.csvData.push(obj);
        });

        this.csvData = [...this.csvData];

        console.log('Process CSV completed');

        //Progress bar
        this.totalLoadedCase = this.csvData.length;
        this.successCase = 0;
        this.failedCase = 0;
        this.percentage = 0;

        // reset child progress bar explicitly
        this.updateProgressInChild(0);
    }



    // async handleDone() {
    //     this.showSpinner = true;
    //     await this.sendDataInChunks();
    //     this.showSpinner = false;

    //     // enable buttons after processing
    //     this.isDownloadResult = false;
    //     this.isDownloadError = false;
    // }


    async handleDone() {
        try {
            this.showSpinner = true;

            // Disable actions during upload
            this.disabledDone = true;
            this.isDownloadResult = true;
            this.isDownloadError = true;

            await this.sendDataInChunks();

        } catch (error) {
            console.error('Bulk upload failed:', error);
        } finally {
            // Always executed (success or failure)
            this.showSpinner = false;

            // Enable download buttons AFTER upload completes
            this.isDownloadResult = false;
            this.isDownloadError = false;

            // Keep Start Upload disabled once processing is done
            this.disabledDone = true;
        }
    }



    // async sendDataInChunks() {
    //     this.chunkSize = 1;
    //     this.currentChunkIndex = 0;
    //     const totalChunks = this.csvData.length;

    //     while (this.currentChunkIndex < totalChunks) {

    //         const chunk = [this.csvData[this.currentChunkIndex]];

    //         await this.sendChunkToApex(this.currentChunkIndex, chunk);

    //         this.currentChunkIndex++;

    //         //Progress bar
    //         // percentage calculation
    //         this.percentage = Math.round(
    //             (this.currentChunkIndex / totalChunks) * 100
    //         );

    //         // update reusable progress bar
    //         this.updateProgressInChild(this.percentage);

    //     }
    // }


    async sendDataInChunks() {
        this.chunkSize = 1;

        const total = this.csvData.length;
        const concurrencyLimit = 6;

        this.currentChunkIndex = 0;
        this.percentage = 0;
        let completedCount = 0; // NEW: tracks actual completed records

        let activePromises = [];

        while (this.currentChunkIndex < total) {

            const index = this.currentChunkIndex;
            const chunk = [this.csvData[index]]; // 1 record per call

            // push async call
            activePromises.push(
                this.sendChunkToApex(index, chunk)
                    .then(() => {
                        completedCount++;
                        // progress update
                        const completed = index + 1;
                        this.percentage = Math.round((completedCount / total) * 100);
                        this.updateProgressInChild(this.percentage);
                    })
            );

            this.currentChunkIndex++;

            // wait when concurrency limit is reached
            if (activePromises.length >= concurrencyLimit) {
                await Promise.all(activePromises);
                activePromises = [];
            }
        }

        // wait for remaining promises
        if (activePromises.length > 0) {
            await Promise.all(activePromises);
        }
    }


    async sendChunkToApex(i, chunk) {
        const apexObj = chunk[0]._apex;

        // CLIENT-SIDE VALIDATION
        if (this.hasMissingMandatoryField(apexObj)) {
            this.csvData[i].Status = 'Failed';
            this.csvData[i].Message = 'Please fill all the fields';

            this.csvData = [...this.csvData];
            this.getSuccessCount();
            return; // DO NOT CALL APEX
        }

        try {
            const results = await createCaseCSV({
                js: JSON.stringify([chunk[0]._apex])
            });
            const result = results[0]; // only 1 record
            this.csvData[i].Status = result.Status;
            this.csvData[i].Message = result.Message;
        } catch (error) {
            this.csvData[i].Status = 'Failed';
            this.csvData[i].Message =
                error.body?.message || 'Unexpected error';
        }
        this.csvData = [...this.csvData];
        
        //Progress bar
        this.getSuccessCount();
    }


    buildCsvRows(records) {
        const headers = this.getExportHeaders();
        let csv = headers.join(',') + '\n';

        records.forEach(row => {
            const values = headers.map(h => {
                let value =
                    h === 'Status' ? row.Status :
                    h === 'Error Msg' ? row.Message :
                    row[h];

                    // FORCE EMPTY COLUMN IF VALUE IS NULL / UNDEFINED
                    if (value === null || value === undefined) {
                        value = '';
                    }

                // return `"${(value || '').replace(/"/g, '""')}"`;
                //  FORCE TEXT FOR LONG NUMBERS
                if (h === 'Displayed Account number' || h === 'ERN') {
                    return `="${value || ''}"`;
                }
                return `"${(value || '').replace(/"/g, '""')}"`;
            });
            csv += values.join(',') + '\n';
        });
        return csv;
    }

    downloadBeforeCsv = () => {
        console.log('Download ALL clicked', this.csvData);

        if (!this.csvData || !this.csvData.length) {
            alert('No data to download');
            return;
        }

        const csv = this.buildCsvRows(this.csvData);
        this.triggerDownload(csv, 'All_Results');
    }

    downloadErrorCsv = () => {
        console.log('Download ERROR clicked', this.csvData);

        const errors = (this.csvData || []).filter(r => r.Status === 'Failed');

        if (!errors.length) {
            alert('No Error Records');
            return;
        }

        const csv = this.buildCsvRows(errors);
        this.triggerDownload(csv, 'Error_Results');
    }


    triggerDownload(csv, name) {
        const link = document.createElement('a');
        link.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        link.target = '_self';
        link.download = name + '.csv';

        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }

    //Progress bar 
    @track percentage = 0;
    @track totalLoadedCase = 0;
    @track successCase = 0;
    @track failedCase = 0;

    getSuccessCount() {
        this.successCase = 0;
        this.failedCase = 0;

        this.csvData.forEach(row => {
            if (row.Status === 'Success') {
                this.successCase++;
            } else if (row.Status === 'Failed') {
                this.failedCase++;
            }
        });
    }

    updateProgressInChild(value) {
        const progressBar = this.template.querySelector('c-progress-bar');
        if (progressBar) {
            progressBar.updateProgress(value);
        }
    }

}