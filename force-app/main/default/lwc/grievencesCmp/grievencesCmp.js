import { LightningElement, track, api, wire } from 'lwc';
import expe_Logo from '@salesforce/resourceUrl/experianLogo';
import { CurrentPageReference } from 'lightning/navigation';
import getAccountData from '@salesforce/apex/GrievancesNodalOfficersControllerV2.getAccountData';
import upadteAccount from '@salesforce/apex/GrievancesNodalOfficersControllerV2.upadteAccount';
import verifyOTPEmail from '@salesforce/apex/GrievancesNodalOfficersControllerV2.verifyOTPEmail';
import sendOTPEmail from '@salesforce/apex/GrievancesNodalOfficersControllerV2.sendOTPEmail';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
// import CLIPBOARD_JS from '@salesforce/resourceUrl/clipboard';
import { loadScript } from 'lightning/platformResourceLoader';





export default class GrievencesCmp extends NavigationMixin(LightningElement) {
    expe_Logo = expe_Logo;
    countdown = 180; // Starting time in seconds (2 minutes)
    timer = null; // To store the interval for countdown
    formattedTime = '03:00'; // To store formatted time (e.g., '1:11')
    otpExpired = false;
    isOtpVerified = false;

    startCountdown() {
        this.otpExpired = false;
        this.countdown = 180; // Reset countdown to 120 seconds (2 minutes)
        this.timer = setInterval(() => this.updateTimer(), 1000); // Update every second
    }

@track isVisibeButton = true;
    updateTimer() {
        if(!this.isOpenForm){
        if (this.countdown <= 0) {
            clearInterval(this.timer); // Stop the timer
            this.otpExpired = true; // Mark OTP as expired
            this.formattedTime = '00:00'; // Show 00:00 when expired
            console.log('OTP expired');
            this.isVisibeButton = false;
        } else {
            this.countdown--; // Decrease countdown by 1 second
            
            const minutes = Math.floor(this.countdown / 60);
            const seconds = this.countdown % 60;
            
            // Format the time in mm:ss format
            this.formattedTime = `${minutes < 10 ? '0' : ''}${minutes}:${seconds < 10 ? '0' : ''}${seconds}`;
        }
        }
    }


    resetOtp() {
        this.sendOtp();
        this.isOpenForm = false;
        this.isVisibeButton = true;
        clearInterval(this.timer);
        this.countdown = 180;
        this.formattedTime = '03:00';
        this.otpExpired = false;
    }




    @track otpFields = [{'key':0,value:''},{'key':1,value:''},{'key':2,value:''},{'key':3,value:''}];
    
    //otpFields = ['1', '2', '3', '4']; // OTP fields (each index represents a field)
    isLoading = false;  // Whether a request is in progress
    errorMessage = '';  // Error message for invalid OTP
    successMessage = '';  // Success message for valid OTP

    // Handle change in OTP fields
    handleOtpInput(event) {
    let id = event.target.dataset.id;
    let index = this.otpFields.findIndex(a => a.key == id);
    let value = event.target.value;
    this.otpFields[index].value = value;
    this.errorMessage = '';
    this.successMessage = '';

    this.manageFocus(index, value);
    }

    handlePaste() {
    if (navigator.clipboard) {
        navigator.clipboard.readText()
            .then((pasteData) => {
                console.log('Pasted content:', pasteData);
                if (pasteData.length === 4 && /^[0-9]{4}$/.test(pasteData)) {
                    this.otpFields.forEach((field, index) => {
                        if (pasteData[index]) {
                            this.otpFields[index].value = pasteData[index];
                        }
                    });
                } else {
                    console.error('Invalid OTP format.');
                }
            })
            .catch((error) => {
                console.error('Clipboard read error:', error);
            });
    } else {
        console.error('Clipboard API not supported.');
    }
}



     manageFocus(index, value) {
    const otpInputs = this.template.querySelectorAll('.otp-input');
    
    setTimeout(() => {
        if (value && index < otpInputs.length - 1) {
            otpInputs[index + 1].focus();  // Focus the next input field
        } else if (!value && index > 0) {
            otpInputs[index].focus();  
        }
    }, 50); 
     }

    @track isOpenForm = false;
    // Verify OTP logic
    verifyOtp() {
        this.isLoading = true;  // Show loading spinner
        console.log('OUTPUT : ',JSON.stringify(this.otpFields));
        const otpString = this.otpFields.map(field => field.value).join('');
        let validOtp = parseInt(otpString, 10);
        console.log('OUTPUT : ',validOtp);
        if(validOtp > 0){
        setTimeout(() => {
            verifyOTPEmail({accId:this.recordId , otp:validOtp}).then(result=>{
                console.log('OUTPUT : ',result);
                let temp = JSON.parse(JSON.stringify(result));
                if(temp.Status){
                    this.Grievance();
                     setTimeout(() => {
                    this.isOpenForm = true;
                    this.successMessage = temp.Message;
                    }, 1000);
                }else{
                    this.isOpenForm = false;
                    this.errorMessage = temp.Message;
                }
            })
        }, 500);
        }else{
        this.errorMessage = 'Please Fill OTP';
        }
    }

    

    @api recordId;

    // @wire(CurrentPageReference)
    // getStateParameters(currentPageReference) {
    //     if (currentPageReference) {
    //         this.recordId = currentPageReference.state.recordId;
    //     }
    //     console.log('current record id');


    // }


clipboardJs;

    // Load Clipboard.js when component is rendered
    connectedCallback() {

            console.log('-->', this.recordId + ' in 0000000');
            //this.sendOtp();
            
        this.Grievance();
    }
    sendOtp(){
    sendOTPEmail({accId:this.recordId}).then(result=>{
        console.log('OUTPUT : ',result);
        this.startCountdown();
    })
    }



    // connectedCallback() {
    //     loadScript(this, CLIPBOARD_JS)
    //         .then(() => {
    //             // Initialize Clipboard.js once it's loaded
    //             this.clipboardJs = new ClipboardJS('.btn'); // Use Clipboard.js
    //             this.clipboardJs.on('success', (e) => {
    //                 console.log('Successfully copied to clipboard:', e);
    //             });

    //             this.clipboardJs.on('error', (e) => {
    //                 console.error('Failed to copy:', e);
    //             });
    //         })
    //         .catch((error) => {
    //             console.error('Error loading Clipboard.js:', error);
    //         });
    

        
    // }

    @track disputeValue = {};
    @track DQR_Value = {};
    @track Form_A_Value = {};
    @track Form_B_Value = {};
    @track Form_C_Value = {};
    @track olm_Value = {};

    


    @track accRecData = {};
    Grievance() {
        getAccountData({ accId: this.recordId ,otp:this.otp}).then(result => {
            this.accRecData = JSON.parse(result);
            console.log('Name', this.accRecData);
            this.DQR_Value = this.accRecData.dqr;
            this.disputeValue = this.accRecData.dispute;
            this.Form_A_Value = this.accRecData.formOne;
            this.Form_B_Value = this.accRecData.formTwo;
            this.Form_C_Value = this.accRecData.formThree;
            this.olm_Value = this.accRecData.olmEmail
            console.log('DQR_Value-->', JSON.stringify(this.DQR_Value));
            console.log('disputeValue-->', JSON.stringify(this.disputeValue));
            console.log('Form_A_Value-->', JSON.stringify(this.Form_A_Value));
            console.log('Form_B_Value-->', JSON.stringify(this.Form_B_Value));
            console.log('Form_C_Value-->', JSON.stringify(this.Form_C_Value));
        })
    }

    @track sections = [
        { id: 'DQR / DQI Information', label: 'DQR / DQI Information', isOpen: true, content: 'This is the content of Section 1.', index : 0},
        { id: 'Form C Information', label: 'Form C Information', isOpen: true, content:'This is the content of Section 2.' , index : 1},
        { id: 'Dispute Information', label: 'Dispute Information', isOpen: true,content:'This is the content of Section 3.' , index: 2},
    ];


    @track DQR_Open = true;
    @track Form_Open = true;
    @track Dispute_Form = true;
    @track OLM_Open = true;




    toggleSection(event){
        
        
        let index = event.target.dataset.label; // Get the index from data attribute
        console.log('index',index);
        
        if(index == 1){
            if(this.DQR_Open)
              this.DQR_Open = false;
            else
               this.DQR_Open = true;
        }


        if(index == 2){
            if(this.Form_Open)
              this.Form_Open = false;
            else
               this.Form_Open = true;
        }


        if(index == 3){
            if(this.Dispute_Form)
              this.Dispute_Form = false;
            else
               this.Dispute_Form = true;
        }

        if(index == 4){
            if(this.OLM_Open)
              this.OLM_Open = false;
            else
               this.OLM_Open = true;
        }
    }

    handleOLMChange(event){
        let label = event.target.dataset.label;
        this.olm_Value[label] = event.target.value;
        console.log('current--DQR-->',label,this.olm_Value[label]);
    }

    handleDQRChange(event){
        let label = event.target.dataset.label;
        this.DQR_Value[label] = event.target.value;
        console.log('current--DQR-->',label,this.DQR_Value[label]);
    }

    handleForm_A_Change(event){
        let label = event.target.dataset.label;
        this.Form_A_Value[label] = event.target.value;
        console.log('current--Form-->',label,this.Form_A_Value[label]);
    }


    handleForm_B_Change(event){
        let label = event.target.dataset.label;
        this.Form_B_Value[label] = event.target.value;
        console.log('current--Form-->',label,this.Form_B_Value[label]);
    }

    handleForm_C_Change(event){
        let label = event.target.dataset.label;
        this.Form_C_Value[label] = event.target.value;
        console.log('current--Form-->',label,this.Form_C_Value[label]);
    }

    handleDisputeChange(event){
        let label = event.target.dataset.label;
        this.disputeValue[label] = event.target.value;
        console.log('current--Dispute-->',label,this.disputeValue[label]);
        
    }



    handlechange(event) {
        let currentlabel = event.target.dataset.label;
        currentlabel = (currentlabel).toLowerCase();
        console.log('label 1', currentlabel);
        if (currentlabel.includes('phone')) {
        } else if (currentlabel.includes('email')) {
        } if (currentlabel.includes('name')) {
        }

        this.accRecData[event.target.dataset.label] = event.target.value;
        console.log('this.accRecData ', this.accRecData[event.target.dataset.label]);

    }

    phoneValidation() {
        console.log(currentlabel, phone.length);
        if (phone.length > 3) {
            console.log('inside if', currentlabel, phone.length);
            currentlabel = currentlabel.replace('__c', '');
            currentlabel = currentlabel.replaceAll('_', ' ');
            let errmsg = currentlabel + ' Should not be greater than 10 digit';
            console.log('errmsg', errmsg);
            this.ShowToastMessage('error', errmsg);
        }
    }

    @track griev_Name = false;
    @track griev_Email = false;
    @track griev_Phone = false;
    @track techCon_Name = false;
    @track techCon_Email = false;


    handleConfirm() {

        let tempcheck;
        setTimeout(() => {
            this.accRecData.dqr=  this.DQR_Value;
            this.accRecData.dispute=  this.disputeValue;
            this.accRecData.formOne=  this.Form_A_Value;
            this.accRecData.formTwo=  this.Form_B_Value;
            this.accRecData.formThree=  this.Form_C_Value;
            this.accRecData.olmEmail = this.olm_Value;
            console.log('accData-->',JSON.stringify(this.accRecData));
            
            tempcheck = this.Validation(this.accRecData);
            console.log('temp', tempcheck);
            if (Number(tempcheck) == 0) {
                console.log('inside temp', this.recordId, JSON.stringify(this.accRecData));
                upadteAccount({ json: JSON.stringify(this.accRecData), accountId: this.recordId }).then(result => {

                    for (let key in result) {
                        if (key == 'Success') {
                            this.navigateToWebPage();

                        } else {
                            this.ShowToastMessage(key, result[key]);
                        }
                    }
                })
            }

        }, 100);
    }


    navigateToWebPage() {
        //sfdcBaseURL = 'https://www.experian.com';
        window.location.href = 'https://www.experian.in';
    }


    @track Person_Name_1_chk = false;
    @track Email_1_Dispute_chk = false;
    @track Person_Name_2_chk = false;
    @track Email_2_Dispute_chk = false;
    @track Person_Name_3_chk = false;
    @track Email_3_Dispute_chk = false;
    @track Person_Name_4_chk = false;
    @track Email_4_Dispute_chk = false;
    @track Person_Name_5_chk = false;
    @track Email_5_Dispute_chk = false;
    @track Person_Name_6_chk = false;
    @track Email_6_Dispute_chk = false;
    @track Person_Name_7_chk = false;
    @track Email_7_Dispute_chk = false;
    @track Person_Name_8_chk = false;
    @track Email_8_Dispute_chk = false;
    @track Person_Name_9_chk = false;
    @track Email_9_Dispute_chk = false;
    @track Person_Name_10_chk = false;
    @track Email_10_Dispute_chk = false;
    Validation(data) {
        this.griev_Name = false;
        this.griev_Email = false;
        this.griev_Phone = false;
        this.techCon_Name = false;
        this.techCon_Email = false;
        this.Person_Name_1_chk = false;
        this.Email_1_Dispute_chk = false;
        this.Person_Name_2_chk = false;
        this.Email_2_Dispute_chk = false;
        this.Person_Name_3_chk = false;
        this.Email_3_Dispute_chk = false;
        this.Person_Name_4_chk = false;
        this.Email_4_Dispute_chk = false;
        this.Person_Name_5_chk = false;
        this.Email_5_Dispute_chk = false;
        this.Person_Name_6_chk = false;
        this.Email_6_Dispute_chk = false;
        this.Person_Name_7_chk = false;
        this.Email_7_Dispute_chk = false;
        this.Person_Name_8_chk = false;
        this.Email_8_Dispute_chk = false;
        this.Person_Name_9_chk = false;
        this.Email_9_Dispute_chk = false;
        this.Person_Name_10_chk = false;
        this.Email_10_Dispute_chk = false;

        console.log('JSON-->', JSON.stringify(data));

        let count = 0;

        if (data.Person_Name_Dispute != '' && data.Person_Name_Dispute != null) {
            if (data.Email_1_Dispute == '' || data.Email_1_Dispute == null) {
                this.Email_1_Dispute_chk = true;
                count++;
            } else {
                this.Email_1_Dispute_chk = false;
            }
        }
        else if (data.Email_1_Dispute != '' && data.Email_1_Dispute != null) {
            if (data.Person_Name_Dispute == '' || data.Person_Name_Dispute == null) {
                this.Person_Name_1_chk = true;
                count++;
            } else {
                this.Person_Name_1_chk = false;
            }
        }

        if (data.Person_Name_2 != '' && data.Person_Name_2 != null) {
            if (data.Email_2_Dispute == '' || data.Email_2_Dispute == null) {
                this.Email_2_Dispute_chk = true;
                count++;
            } else {
                this.Email_2_Dispute_chk = false;
            }
        } else if (data.Email_2_Dispute != '' && data.Email_2_Dispute != null) {
            if (data.Person_Name_2 == '' || data.Person_Name_2 == null) {
                this.Person_Name_2_chk = true;
                count++;
            } else {
                this.Person_Name_2_chk = false;
            }
        }



        if (data.Person_Name_3 != '' && data.Person_Name_3 != null) {
            if (data.Email_3_Dispute == '' || data.Email_3_Dispute == null) {
                this.Email_3_Dispute_chk = true;
                count++;
            } else {
                this.Email_3_Dispute_chk = false;
            }
        } else if (data.Email_3_Dispute != '' && data.Email_3_Dispute != null) {
            if (data.Person_Name_3 == '' || data.Person_Name_3 == null) {
                this.Person_Name_3_chk = true;
                count++;
            } else {
                this.Person_Name_3_chk = false;
            }
        }


        if (data.Person_Name_4 != '' && data.Person_Name_4 != null) {
            if (data.Email_4_Dispute == '' || data.Email_4_Dispute == null) {
                this.Email_4_Dispute_chk = true;
                count++;
            } else {
                this.Email_4_Dispute_chk = false;
            }
        } else if (data.Email_4_Dispute != '' && data.Email_4_Dispute != null) {
            if (data.Person_Name_4 == '' || data.Person_Name_4 == null) {
                this.Person_Name_4_chk = true;
                count++;
            } else {
                this.Person_Name_4_chk = false;
            }
        }


        if (data.Person_Name_5 != '' && data.Person_Name_5 != null) {
            if (data.Email_5_Dispute == '' || data.Email_5_Dispute == null) {
                this.Email_5_Dispute_chk = true;
                count++;
            } else {
                this.Email_5_Dispute_chk = false;
            }
        } else if (data.Email_5_Dispute != '' && data.Email_5_Dispute != null) {
            if (data.Person_Name_5 == '' || data.Person_Name_5 == null) {
                this.Person_Name_5_chk = true;
                count++;
            } else {
                this.Person_Name_5_chk = false;
            }
        }


        if (data.Person_Name_6 != '' && data.Person_Name_6 != null) {
            if (data.Email_6_Dispute == '' || data.Email_6_Dispute == null) {
                this.Email_6_Dispute_chk = true;
                count++;
            } else {
                this.Email_6_Dispute_chk = false;
            }
        } else if (data.Email_6_Dispute != '' && data.Email_6_Dispute != null) {
            if (data.Person_Name_6 == '' || data.Person_Name_6 == null) {
                this.Person_Name_6_chk = true;
                count++;
            } else {
                this.Person_Name_6_chk = false;
            }
        }


        if (data.Person_Name_7 != '' && data.Person_Name_7 != null) {
            if (data.Email_7_Dispute == '' || data.Email_7_Dispute == null) {
                this.Email_7_Dispute_chk = true;
                count++;
            } else {
                this.Email_7_Dispute_chk = false;
            }
        } else if (data.Email_7_Dispute != '' && data.Email_7_Dispute != null) {
            if (data.Person_Name_7 == '' || data.Person_Name_7 == null) {
                this.Person_Name_7_chk = true;
                count++;
            } else {
                this.Person_Name_7_chk = false;
            }
        }


        if (data.Person_Name_8 != '' && data.Person_Name_8 != null) {
            if (data.Email_8_Dispute == '' || data.Email_8_Dispute == null) {
                this.Email_8_Dispute_chk = true;
                count++;
            } else {
                this.Email_8_Dispute_chk = false;
            }
        } else if (data.Email_8_Dispute != '' && data.Email_8_Dispute != null) {
            if (data.Person_Name_8 == '' || data.Person_Name_8 == null) {
                this.Person_Name_8_chk = true;
                count++;
            } else {
                this.Person_Name_8_chk = false;
            }
        }

        if (data.Person_Name_9 != '' && data.Person_Name_9 != null) {
            if (data.Email_9_Dispute == '' || data.Email_9_Dispute == null) {
                this.Email_9_Dispute_chk = true;
                count++;
            } else {
                this.Email_9_Dispute_chk = false;
            }
        } else if (data.Email_9_Dispute != '' && data.Email_9_Dispute != null) {
            if (data.Person_Name_9 == '' || data.Person_Name_9 == null) {
                this.Person_Name_9_chk = true;
                count++;
            } else {
                this.Person_Name_9_chk = false;
            }
        }

        if (data.Person_Name_10 != '' && data.Person_Name_10 != null) {
            if (data.Email_10_Dispute == '' || data.Email_10_Dispute == null) {
                this.Email_10_Dispute_chk = true;
                count++;
            } else {
                this.Email_10_Dispute_chk = false;
            }
        } else if (data.Email_10_Dispute != '' && data.Email_10_Dispute != null) {
            if (data.Person_Name_10 == '' || data.Person_Name_10 == null) {
                this.Person_Name_10_chk = true;
                count++;
            } else {
                this.Person_Name_10_chk = false;
            }
        }




        if (data.Technology_Contact_Name == null || data.Technology_Contact_Name == '') {
            this.techCon_Name = true;
            count++;
        } else {
            this.techCon_Name = false;
        }

        if (data.Technology_Contact_Email == null || data.Technology_Contact_Email == '') {
            this.techCon_Email = true;
            count++;
        } else {
            this.techCon_Email = false;
        }


        if (data.Grievances_Nodal_Officer_Name == null || data.Grievances_Nodal_Officer_Name == '') {
            this.griev_Name = true;
            count++;
        } else {
            this.griev_Name = false;
        }

        if (data.Grievances_Nodal_Officer_Email == null || data.Grievances_Nodal_Officer_Email == '') {
            this.griev_Email = true;
            count++;
        } else {
            this.griev_Email = false;
        }

        if (data.Grievances_Nodal_Officer_Phone == null || data.Grievances_Nodal_Officer_Phone == '') {
            this.griev_Phone = true;
            //let target = this.template.querySelector(`[data-id="Grievances_Nodal_Officer_Phone"]`);

            // Underline the text in the div 
            //target.style.textDecoration = "underline";
            count++;
        } else {
            this.griev_Phone = false;
            //let target = this.template.querySelector(`[data-id="Grievances_Nodal_Officer_Phone"]`);
            //target.style.textDecoration = "none";
        }

        console.log('counted values ', count);
        return count;
    }


    handlePB1change(event) {
        let currentlabel = event.target.dataset.label;

        if (currentlabel == 'Person_Name_Dispute') {
            if (event.target.checked) {
                this.accRecData.inp_disabled_1 = false;
                this.accRecData.perseon_pB1 = event.target.checked;
            } else {
                this.accRecData.perseon_pB1 = false;
                if (this.accRecData.Person_Name_1 != null || this.accRecData.Email_1_Dispute != null || this.accRecData.Phone_1 != null) {
                    this.accRecData.inp_disabled_1 = true;
                }
            }
        }


        if (currentlabel == 'Person_Name_2') {
            if (event.target.checked) {
                this.accRecData.perseon_pB2 = event.target.checked;
                this.accRecData.inp_disabled_2 = false;
            } else {
                this.accRecData.perseon_pB2 = false;
                if (this.accRecData.Person_Name_2 != null || this.accRecData.Email_2_Dispute != null || this.accRecData.Phone_2 != null) {
                    this.accRecData.inp_disabled_2 = true;
                }
            }
        }


        if (currentlabel == 'Person_Name_3') {
            if (event.target.checked) {
                this.accRecData.inp_disabled_3 = false;
                this.accRecData.perseon_pB3 = event.target.checked;
            } else {
                this.accRecData.perseon_pB3 = false;
                if (this.accRecData.Person_Name_3 != null || this.accRecData.Email_3_Dispute != null || this.accRecData.Phone_3 != null) {
                    this.accRecData.inp_disabled_3 = true;
                }
            }
        }


        if (currentlabel == 'Person_Name_4') {
            if (event.target.checked) {
                this.accRecData.inp_disabled_4 = false;
                this.accRecData.perseon_pB4 = event.target.checked;
            } else {
                this.accRecData.perseon_pB4 = false;
                if (this.accRecData.Person_Name_4 != null || this.accRecData.Email_4_Dispute != null || this.accRecData.Phone_4 != null) {
                    this.accRecData.inp_disabled_4 = true;
                }
            }
        }


        if (currentlabel == 'Person_Name_5') {
            if (event.target.checked) {
                this.accRecData.inp_disabled_5 = false;
                this.accRecData.perseon_pB5 = event.target.checked;
            } else {
                this.accRecData.perseon_pB5 = false;
                if (this.accRecData.Person_Name_5 != null || this.accRecData.Email_5_Dispute != null || this.accRecData.Phone_5 != null) {
                    this.accRecData.inp_disabled_5 = true;
                }
            }
        }


        if (currentlabel == 'Person_Name_6') {
            if (event.target.checked) {
                this.accRecData.inp_disabled_6 = false;
                this.accRecData.perseon_pB6 = event.target.checked;
            } else {
                this.accRecData.perseon_pB6 = false;
                if (this.accRecData.Person_Name_6 != null || this.accRecData.Email_6_Dispute != null || this.accRecData.Phone_6 != null) {
                    this.accRecData.inp_disabled_6 = true;
                }
            }
        }


        if (currentlabel == 'Person_Name_7') {
            if (event.target.checked) {

                this.accRecData.inp_disabled_7 = false;
                this.accRecData.perseon_pB7 = event.target.checked;
            } else {
                this.accRecData.perseon_pB7 = false;
                if (this.accRecData.Person_Name_7 != null || this.accRecData.Email_7_Dispute != null || this.accRecData.Phone_7 != null) {
                    this.accRecData.inp_disabled_7 = true;
                }
            }
        }

        if (currentlabel == 'Person_Name_8') {
            if (event.target.checked) {
                this.accRecData.inp_disabled_8 = false;
                this.accRecData.perseon_pB8 = event.target.checked;
            } else {
                this.accRecData.perseon_pB8 = false;
                if (this.accRecData.Person_Name_8 != null || this.accRecData.Email_8_Dispute != null || this.accRecData.Phone_8 != null) {
                    this.accRecData.inp_disabled_8 = true;
                }
            }
        }

        if (currentlabel == 'Person_Name_9') {
            if (event.target.checked) {
                this.accRecData.inp_disabled_9 = false;
                this.accRecData.perseon_pB9 = event.target.checked;
            } else {
                this.accRecData.perseon_pB9 = false;
                if (this.accRecData.Person_Name_9 != null || this.accRecData.Email_9_Dispute != null || this.accRecData.Phone_9 != null) {
                    this.accRecData.inp_disabled_9 = true;
                }
            }
        }

        if (currentlabel == 'Person_Name_10') {
            if (event.target.checked) {
                this.accRecData.inp_disabled_10 = false;
                this.accRecData.perseon_pB10 = event.target.checked;
            } else {
                this.accRecData.perseon_pB10 = false;
                if (this.accRecData.Person_Name_10 != null || this.accRecData.Email_10_Dispute != null || this.accRecData.Phone_10 != null) {
                    this.accRecData.inp_disabled_10 = true;
                }
            }
        }
    }
    ShowToastMessage(variant, msg) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: variant,
                message: msg,
                variant: variant,
            }),
        );
    }

}