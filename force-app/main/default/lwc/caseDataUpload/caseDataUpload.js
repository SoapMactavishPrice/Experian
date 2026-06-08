import { LightningElement, track } from 'lwc';
import updateCase from '@salesforce/apex/updateCaseController.updateCase';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';

export default class CaseDataUpload extends LightningElement {
    get acceptedFormats() {
        return ['.csv'];
    }

    @track checkNotInfevor = false;

    @track isUpdateData = true;
 
    get options() {
        return [
            { label: 'None', value: '' },
            { label: 'Resolved in favour of the Consumer', value: 'Resolved in favour of the Consumer' },
            { label: 'Resolved not in favour of the Consumer', value: 'Resolved not in favour of the Consumer' },
            { label: 'Enquiry User Id', value: 'Enquiry User Id' },
            { label: 'Change Owner Id', value: 'Change Owner Id' },
            { label: 'Forward to Bank', value: 'Forward to Bank' },
            { label: 'Send Email to Consumer', value: 'Send Email to Consumer' },
            { label: 'Sub Type 1 Change', value: 'Sub Type 1 Change' },
            { label: 'Incident Update', value: 'Incident Update' },
            { label: 'Matching in Favor', value: 'Matching in Favor' },
            { label: 'Refered To IO Case', value: 'Referred To IO Case' },
            { label: 'Attach File to the Case', value: 'Attach File to the Case' },
            { label: 'Update CST Comment', value: 'Update CST Comment' },
            { label: 'Complaint Withdrawn by Consumer', value: 'Complaint Withdrawn by Consumer' },
            { label: 'Update Junk Case', value: 'Update Junk Case' },
            { label: 'Update Open to Resolved', value: 'Update Open to Resolved' },
            { label: 'Send Email Acknowledgement', value: 'Send Email Acknowledgement' },
            { label: 'Resolved in favour of the Consumer - Data Submission', value: 'Resolved in favour of the Consumer - Data Submission' },
            { label: 'Update Contact Header Details', value: 'Update Contact Header Details' },
            { label: 'Bank details requirement - Draft 1', value: 'Bank details requirement - Draft 1' },
            { label: 'Bank details requirement - Draft 2', value: 'Bank details requirement - Draft 2' },
            { label: 'CI Liable email to Consumer', value: 'CI Liable email to Consumer' },
            { label: 'CIC Liable email to Consumer', value: 'CIC Liable email to Consumer' },
            { label: 'Bank details requirement for reprocessing', value: 'Bank details requirement for reprocessing' },
            { label: 'Payment Confirmation to Consumer', value: 'Payment Confirmation to Consumer' },
            { label: 'Update NC Case', value: 'Update NC Case' },
            { label: 'Send Provide Proof', value: 'Send Provide Proof' },
            { label: 'Send New Provide Proof', value: 'Send New Provide Proof' },
            { label: 'Send NC 1st Attempt', value: 'Send NC 1st Attempt' },
            { label: 'Send Call Back', value: 'Send Call Back' },
            { label: 'Update ECICI Remarks', value: 'Update ECICI Remarks' },
            { label: 'Update ReClose Status', value: 'Update ReClose Status' }

        ];
    }

    @track disabledDone = true;

    @track csvData = [];
    @track headerKeys = [];
    @track headerKeysNew = [];


    @track showTableData = false;
   handleFileChange(event) {
    const file = event.target.files[0];
    this.disabledDone = false;
    this.csvData = [];

    if (file && file.type === 'text/csv') {
        const reader = new FileReader();

        reader.onload = () => {
            let csvData = reader.result;

            // Optional: normalize line endings
            csvData = csvData.replace(/\r\n/g, '\n').replace(/\r/g, '\n');

            // Parse and clean only quoted commas
            const cleanedCSV = csvData.replace(/"(.*?)"/g, (match, p1) => {
                return '' + p1.replace(/,/g, ';') + ''; // replace commas only inside quotes
            });

            this.processCSV(cleanedCSV);
        };

        reader.readAsText(file);
    } else {
        alert('Please upload a valid CSV file.');
    }
}


    @track consumer_Status = '';
    handleChange(event) {
        this.consumer_Status = event.target.value;

        if (this.consumer_Status == 'Resolved not in favour of the Consumer') {
            this.checkNotInfevor = true;
        } else {
            this.checkNotInfevor = false;
        }
        console.log('this.consumer_Status-->', this.consumer_Status, this.checkNotInfevor);


    }

    @track openModel = false;
    handleOpenModel() {
        this.csvData = [];
        this.headerKeys = [];
        this.showTableData = false;
        this.openModel = true;
        this.disabledDone = true;
        this.isDownloadResult = true;
        this.percentage = 0;
        this.isResume = true;
        this.isReRun = true;
        this.isResume = true;
        this.updateProgressInChild();

    }

    handleMouseOver() {
        if (this.consumer_Status == '') {
            //this.showMessage = true;
            this.showToast('Error', 'Please Select File Type', 'error');

        }
    }

    handleMouseOut() {
        //this.showMessage = false;
    }
    @track chunkSize = 1;



    showToast(title, msg, vari) {
        const event = new ShowToastEvent({
            title: title,
            message: msg,
            variant: vari
        });
        this.dispatchEvent(event);
    }


    handleCloseModel() {
        this.openModel = false;
    }

    handleDoneModel() {
        this.showSpinner = true;
        this.openModel = false;
        this.isFileUpload = true;

        setTimeout(() => {
            this.showSpinner = false;
            this.isUpdateData = false;
            this.showTableData = true;
        }, 2000);

    }

    @track isPause = true;
    @track isResume = true;
    @track totalLoadedCase = 0;

    isErrorFalse(row) {
        return row.isError === 'false';
    }

    // Method to check if isError is an empty string
    isErrorEmpty(row) {
        return row.isError === '';
    }


@track isResolveInFaveor = false;
    processCSV(csv) {
        console.log('result-->', JSON.stringify(csv));

        const rows = csv.split('\n');

        this.headerKeys = [...rows[0].split(',').map(header => header.trim()), 'Final Status', 'Message'];

        if (this.consumer_Status == 'Resolved in favour of the Consumer') {
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()), 'Consumer_Dispute_Status_Template',  'Final Status', 'Message','API_Execution_status', 'API_Error_Message',];
        }
        if (this.consumer_Status == 'Resolved in favour of the Consumer - Data Submission') {
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()),'Resolved_Based_On_Submission', 'Consumer_Dispute_Status_Template',  'Final Status', 'Message','API_Execution_status', 'API_Error_Message',];
        }

        

        if (this.consumer_Status == 'Resolved not in favour of the Consumer') {
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()), 'Consumer_Dispute_Status_Template', 'Final Status', 'Message'];

        }
        if (this.consumer_Status == 'Forward to Bank') {
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()), 'Temp_forward_to_bank', 'Forward_to_Bank', 'Final Status', 'Message'];
        }
        if (this.consumer_Status == 'Send Email to Consumer') {
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()), 'Send_Email_to_Consumer', 'Final Status', 'Message'];
        }

        if (this.consumer_Status == 'Incident Update') {
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()), 'Forward_To_Matching_Team', 'Send_Email_to_Consumer', 'Final Status', 'Message'];
        }

        if (this.consumer_Status == 'Matching in Favor') {
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()), 'Consumer_Dispute_Status_Template', 'Final Status', 'Message'];
        }

        if (this.consumer_Status == 'Referred To IO Case') {
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()), 'Referred_To_IO_Case','Rejected Reason' ,'Final Status', 'Message'];
        }


        if (this.consumer_Status == 'Attach File to the Case') {
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()), 'ShareType', 'Visibility', 'Final Status', 'Message'];
        }

        if (this.consumer_Status == 'Update CST Comment') {
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()),'Final Status', 'Message'];
        }

        if (this.consumer_Status == 'Complaint Withdrawn by Consumer') {
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()), 'Consumer Dispute Status', 'Final Status', 'Message'];
        }

        if (this.consumer_Status == 'Update Junk Case') {
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()), 'Junk case','Status', 'Final Status', 'Message'];
        }
        if (this.consumer_Status == 'Send Email Acknowledgement') {
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()),'Send_Email_Acknowledgement', 'Final Status', 'Message'];
        }
        

        if (this.consumer_Status == 'Update Open to Resolved') {
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()), 'Status', 'Final Status', 'Message'];
        }

        if (this.consumer_Status == 'Update Contact Header Details') {
            ///consloe.log('Headers==>',this.headerKeys);
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()) , 'Final Status', 'Message'];
        }


        if (this.consumer_Status == 'Bank details requirement - Draft 1' || this.consumer_Status == 'Bank details requirement - Draft 2' || this.consumer_Status == 'Payment Confirmation to Consumer' || 
            this.consumer_Status == 'CI Liable email to Consumer' || this.consumer_Status == 'CIC Liable email to Consumer' || this.consumer_Status == 'Bank details requirement for reprocessing' || 
            this.consumer_Status == 'Update NC Case' || this.consumer_Status == 'Send Provide Proof' || this.consumer_Status == 'Send New Provide Proof' ||
            this.consumer_Status == 'Send NC 1st Attempt' || this.consumer_Status == 'Send Call Back' || this.consumer_Status == 'Update ECICI Remarks' || this.consumer_Status == 'Update ReClose Status')  {
            ///consloe.log('Headers==>',this.headerKeys);
            this.headerKeys = [...rows[0].split(',').map(header => header.trim()) , 'Final Status', 'Message'];
        }



        this.headerKeys = this.headerKeys.filter(key => key.trim() !== '');
        console.log('this.headerKeys-->', JSON.stringify(this.headerKeys));

        if (this.checkNotInfevor) {
            const consumerDisputeStatusIndex = this.headerKeys.indexOf('Consumer_Dispute_Status_Template');
            if (consumerDisputeStatusIndex !== -1 && !this.headerKeys.includes('Rejection_Reason')) {
                this.headerKeys.splice(consumerDisputeStatusIndex + 1, 0, 'Rejection_Reason');
            }
        }

        this.headerKeysNew = this.headerKeys;
        console.log('this.headerKeys-', this.headerKeys);



        rows.slice(1).map((row, index) => {


            const values = row.split(',');

            if (values[0] != undefined && values[0] != '') {
                const obj = {};

                obj['Serial_No'] = index + 1;

                // this.headerKeys.forEach((key, idx) => {
                //      obj[key] = values[idx] ? values[idx].trim() : ''; 
                // });


                obj['CaseNumber'] = values[0];
                obj['Id'] = values[1].replace('\r', '');
                obj['url'] = '/'+values[1].replace('\r', '');



                if (this.consumer_Status == 'Resolved in favour of the Consumer') {
                    this.isResolveInFaveor = true;
                    obj['Last_Reply_from_Bank_Team'] = values[2];
                    obj['Origin'] = values[3];
                    obj['Consumer_Dispute_Status'] = this.consumer_Status;
                    obj['logError'] = '-';
                    obj['isError'] = false;
                    obj['isSuccess'] = false;
                    obj['showDash'] = true;
                }

                if (this.consumer_Status == 'Resolved in favour of the Consumer - Data Submission') {
                    this.isResolveInFaveor = true;
                    obj['Last_Reply_from_Bank_Team'] = values[2];
                    obj['Origin'] = values[3];
                    obj['Consumer_Dispute_Status'] = 'Resolved in favour of the Consumer';
                    obj['Data_Submission'] = true;
                    
                    obj['logError'] = '-';
                    obj['isError'] = false;
                    obj['isSuccess'] = false;
                    obj['showDash'] = true;
                }

               
                else if (this.consumer_Status == 'Resolved not in favour of the Consumer') {
                    obj['Last_Reply_from_Bank_Team'] = values[2];
                    obj['Consumer_Dispute_Status'] = this.consumer_Status;
                }
                else if (this.consumer_Status == 'Enquiry User Id') {
                    obj['enquiry_User_Id'] = values[2];
                    obj['enquiry_Loan_Amount'] = values[3];
                } else if (this.consumer_Status == 'Change Owner Id') {
                    obj['OwnerId'] = values[2];
                } else if (this.consumer_Status == 'Forward to Bank') {
                    obj['temp_forward_to_bank'] = true;
                    obj['forward_to_bank'] = true;
                } else if (this.consumer_Status == 'Send Email to Consumer') {
                    obj['sendEmailtoConsumer'] = true;
                }

                //Sub Type 1 Change,Matching in Favor,Incident Update
                else if (this.consumer_Status == 'Sub Type 1 Change') {
                    obj['subtypeOneId'] = values[2];
                    obj['MatchingCommentsub'] = values[3];
                    obj['LastReplyFromMatchingTeamforSub'] = values[4];
                } else if (this.consumer_Status == 'Matching in Favor') {
                    obj['LastReplyFromMatchingTeam'] = values[2];
                    obj['MatchingComment'] = values[3];
                    obj['consumerDisputeStatus'] = 'Resolved in favour of the Consumer';

                } else if (this.consumer_Status == 'Incident Update') {
                    obj['incidentNo'] = values[2];
                    obj['forwardToMatechTeam'] = true;
                    obj['sendEmailtoConsumerInc'] = true;
                }
                else if (this.consumer_Status == 'Referred To IO Case') {
                    obj['lastReplyFromBacnkTeam_ref'] = values[2];
                    obj['disputeRejectedRegion_ref'] = values[3];
                    obj['referToIO'] = true;
                    obj['RejectedRegion_ref'] = 'Rejected by Lender';
                }

                if (this.consumer_Status == 'Attach File to the Case') {
                    obj['ContentDocumentId'] = values[2].replace('\r', '');
                    obj['ShareType'] = 'V';
                    obj['Visibility'] = 'AllUsers';
                }
                else if (this.consumer_Status == 'Update CST Comment') {
                    console.log('caseCSTComment-->',values[2], ' -- ',values[2].replace('\r', '').replace(/,/g, ''));
                    obj['caseCSTComment'] = values[2].replace('\r', '').replace(/,/g, '');
                }

                else if (this.consumer_Status == 'Complaint Withdrawn by Consumer') {
                    obj['caseCSTCommentv1'] = values[2].replace('\r', '').replace(/,/g, '');
                    obj['telConversionDate'] = values[3];
                    obj['ComplaintConsumerStatus'] = 'Complaint Withdrawn by Consumer';
                }

                else if (this.consumer_Status == 'Update Junk Case') {
                    //,JunkStatus
                    obj['Junkcase'] = true;
                    obj['JunkStatus'] = 'Resolved';
                }
                else if (this.consumer_Status == 'Send Email Acknowledgement') {
                    //,JunkStatus
                    obj['Send_Email_Acknowledgement'] = true;
                }

                else if (this.consumer_Status == 'Update Open to Resolved') {
                    obj['Update_Open_to_Resolved'] = 'Resolved';
                }

                    else if (this.consumer_Status == 'Update Contact Header Details') {
                                            obj['Contact_Name'] = values[2];
                                                obj['ContactEmailId'] = values[3];
                                                obj['Contact_Gender'] = values[4];
                                                obj['ContactPan'] = values[5];
                                                obj['ContactMobileNo'] = values[6];
                                                    obj['Contact_Date_of_Birth'] = values[7];
                                                    if (!values[8] || values[8].trim() === '') {
                        obj['Contact_Address'] = '.';
                        } else {
                        obj['Contact_Address'] = values[8].replace('\r', '').replace(/,/g, '');
                        }

                                //obj['Contact_Address'] = values[8].replace('\r', '').replace(/,/g, '');
                            
                }


                else if (this.consumer_Status == 'Bank details requirement - Draft 1') {
                    obj['isSendEmail'] = true;
                }

                else if (this.consumer_Status == 'Payment Confirmation to Consumer') {
                    obj['isSendPaymentConfirmation'] = true;
                }

                else if(this.consumer_Status == 'Bank details requirement for reprocessing'){
                    obj['isSendCompensationPaymentReprocessing'] = true;
                }

                else if (this.consumer_Status == 'CI Liable email to Consumer') {
                    obj['isCompensationEmailPayment'] = true;
                }

                else if(this.consumer_Status == 'CIC Liable email to Consumer'){
                    obj['isSendEmailToConsumerForDelayCIC'] = true;
                }

                else if (this.consumer_Status == 'Bank details requirement - Draft 2') {
                    obj['reSend'] =true;
                }

                else if (this.consumer_Status == 'Update NC Case') {
                    obj['isUpdateNCCase'] =true;
                }

                else if (this.consumer_Status == 'Send Provide Proof') {
                    obj['isSendProvideProof'] =true;
                }

                else if (this.consumer_Status == 'Send New Provide Proof') {
                    obj['isSendNewProvideProof'] =true;
                }

                else if (this.consumer_Status == 'Send NC 1st Attempt') {
                    obj['isSendNC1stAttempt'] =true;
                }

                else if (this.consumer_Status == 'Send Call Back') {
                    obj['isSendCallBack'] =true;
                }

                else if (this.consumer_Status == 'Update ECICI Remarks') {
                    // obj['ECICI_Remarks'] = values[2];
                    obj['ECICI_Remarks'] = values[2] ? values[2].replace('\r', '').trim() : '';
                }

                else if (this.consumer_Status == 'Update ReClose Status') {
                    obj['ReClose'] = true;
                }

                
                obj['Status'] = ''; // Status is blank
                obj['Message'] = '';
                obj.index = index;
                if (this.checkNotInfevor) {
                    obj['Rejection_Reason'] = 'Rejected by Lender';
                }
                //console.log('--obj--> ',JSON.stringify(obj));
                this.csvData.push(obj);
                this.totalLoadedCase = this.csvData.length;
                // return obj;
            }



        }).filter(row => row[headerKeys[0]]); // Filter out any empty rows
    }
  
    @track isDownloadResult = true;
    @track countResult = 0;
    @track percentage = 0;
    @track failedChunks = [];
    @track isReRun = true;
    // async sendDataInChunks() {

    //     this.isPause = false;
    //     if (this.consumer_Status == 'Forward to Bank' || this.consumer_Status == 'Send Email to Consumer' || this.consumer_Status == 'Resolved in favour of the Consumer'
    //         || this.consumer_Status == 'Sub Type 1 Change' || this.consumer_Status == 'Matching in Favor' || this.consumer_Status == 'Incident Update'

    //     ) {
    //         this.chunkSize = 1;
    //     }
    //     const totalChunks = Math.ceil(this.csvData.length / this.chunkSize);
    //     console.log('totalChunks-->', totalChunks);

    //     for (let i = 0; i < totalChunks; i++) {
    //         const chunk = this.csvData.slice(i * this.chunkSize, (i + 1) * this.chunkSize);

    //         try {
    //             await this.sendChunkToApex(i, chunk);
    //             this.percentage = (((i + 1) / totalChunks) * 100).toFixed(2);
    //             this.updateProgressInChild();
    //         } catch (error) {
    //             console.error('Error sending chunk', i, error);
    //         }

    //         await new Promise(resolve => setTimeout(resolve, 100)); // 100 ms delay
    //     }
    // }

    @track currentChunkIndex = 0;
    
    // async sendDataInChunks() {
    //     this.isPause = false;
    //     //this.currentChunkIndex = 0; // Keeps track of the current chunk
    
    //     // Set chunk size based on consumer status
    //     if (this.consumer_Status == 'Forward to Bank' || this.consumer_Status == 'Send Email to Consumer' || this.consumer_Status == 'Resolved in favour of the Consumer' ||
    //     this.consumer_Status == 'Resolved in favour of the Consumer - Data Submission'
    //         || this.consumer_Status == 'Sub Type 1 Change' || this.consumer_Status == 'Matching in Favor' || this.consumer_Status == 'Incident Update') {
    //         this.chunkSize = 1;
    //     }
        

    //     let totalChunks = Math.ceil(this.csvData.length / this.chunkSize);
    //      let recordToProceed = this.csvData;
    //     if(!this.isRefresh){
    //         this.percentage = 0;
    //         this.currentChunkIndex = 0;
    //         this.updateProgressInChild();
    //         recordToProceed = [];
    //         this.csvData.forEach(ele=>{
    //             if(ele.Status =='Failed' )
    //               recordToProceed.push(ele);

    //         })
    //         this.csvData = recordToProceed;
    //         this.totalLoadedCase = this.csvData.length;
            
    //         //this.isRefresh = true;
    //         //this.isUpdateData = false;
    //        totalChunks = Math.ceil(recordToProceed.length / this.chunkSize);
    //        console.log('totalChunks-->', totalChunks);
    //     }
    
    //     while (this.currentChunkIndex < totalChunks) {
    //         if (this.isPause) {
    //             console.log('Process paused at chunk index:', this.currentChunkIndex);
    //             // Wait until isPause is set to false again
    //             await new Promise(resolve => {
    //                 const interval = setInterval(() => {
    //                     if (!this.isPause) {
    //                         clearInterval(interval);
    //                         resolve();
    //                     }
    //                 }, 500); // Check every 500ms
    //             });
    //         }
    
    //         const chunk = recordToProceed.slice(this.currentChunkIndex * this.chunkSize, (this.currentChunkIndex + 1) * this.chunkSize);
    
    //         try {
    //             await this.sendChunkToApex(this.currentChunkIndex, chunk);
    //             this.percentage = (((this.currentChunkIndex + 1) / totalChunks) * 100).toFixed(2);
    //             this.updateProgressInChild();
    //         } catch (error) {
    //             console.error('Error sending chunk', this.currentChunkIndex, error);
    //         }
    
    //         this.currentChunkIndex++;
    
    //         // Add a small delay after each chunk (100ms)
    //         await new Promise(resolve => setTimeout(resolve, 100)); 
    //     }
    // }
    
    // Function to pause the process

    pause() {
        this.isPause = true;
        this.isResume = false;
        console.log('Process paused.');
    }


    
    resume() {
        this.isResume = true;
        this.isPause = false;
        this.sendDataInChunks(); 
    }

    // reRun(){
    //     this.reRunCount = this.reRunCount +1;
        
    //     if(this.reRunCount <= 2){
    //         this.sendDataInChunks(); 
    //     }
    //     if(this.reRunCount == 2){
    //         this.isReRun = true;
    //      }
    // }

    @track failedCase = 0;
    @track successCase = 0;
    getSuccessCount(){
        this.successCase = 0;
        this.failedCase = 0;
        this.csvData.forEach(result => {
            if (result.Status =='Success') {
                this.successCase += 1;
            } else if (result.Status =='Failed') {
                this.failedCase += 1;
            }
        });
            // Optionally, you can log the result for debugging
    console.log('Success Cases:', this.successCase);
    console.log('Failed Cases:', this.failedCase);
    }

@track downloadOnce = 0;

// async sendDataInChunks() {
//     const totalChunks = Math.ceil(this.csvData.length / this.chunkSize);
//     const concurrencyLimit = 6; // Set the maximum number of concurrent requests
//     const promises = []; // Array to hold the promises for concurrent chunks

//     for (let i = 0; i < totalChunks; i++) {
//         const chunk = this.csvData.slice(i * this.chunkSize, (i + 1) * this.chunkSize);

//         // Add the chunk promise to the array
//         promises.push(this.sendChunkToApex(i, chunk));

//         // If we have reached the concurrency limit, wait for all promises to finish before continuing
//         if (promises.length >= concurrencyLimit) {
//             await Promise.all(promises); // Wait for the current batch of promises to complete
//             promises.length = 0; // Clear the promises array for the next batch
//         }

//         // Progress Update (Optional, based on the number of completed chunks)
//         this.percentage = (((i + 1) / totalChunks) * 100).toFixed(2);
//         this.updateProgressInChild();
//     }

//     // If there are any remaining promises (less than the concurrency limit), wait for them to finish
//     if (promises.length > 0) {
//         await Promise.all(promises);
//     }
// }


async sendDataInChunks() {
    this.isPause = false;

    if (this.consumer_Status == 'Forward to Bank' || this.consumer_Status == 'Send Email to Consumer' || this.consumer_Status == 'Resolved in favour of the Consumer' ||
        this.consumer_Status == 'Resolved in favour of the Consumer - Data Submission' || this.consumer_Status == 'Sub Type 1 Change' ||
        this.consumer_Status == 'Matching in Favor' || this.consumer_Status == 'Incident Update' || this.consumer_Status == 'Bank details requirement - Draft 1' || 
        this.consumer_Status == 'Bank details requirement - Draft 2' || this.consumer_Status == 'Payment Confirmation to Consumer' || this.consumer_Status == 'CI Liable email to Consumer' || 
        this.consumer_Status == 'CIC Liable email to Consumer' || this.consumer_Status == 'Bank details requirement for reprocessing' || 
        this.consumer_Status == 'Update NC Case' || this.consumer_Status == 'Send Provide Proof' || this.consumer_Status == 'Send New Provide Proof' || 
        this.consumer_Status == 'Send NC 1st Attempt' || this.consumer_Status == 'Send Call Back' || this.consumer_Status == 'Update ECICI Remarks' || 
        this.consumer_Status == 'Update ReClose Status') {
        this.chunkSize = 1;
    }


    let recordToProceed = this.csvData;

    if (!this.isRefresh) {
        this.percentage = 0;
        this.currentChunkIndex = 0;
        this.updateProgressInChild();

        recordToProceed = this.csvData.filter(ele => ele.Status === 'Failed');
        this.csvData = recordToProceed;
        this.totalLoadedCase = recordToProceed.length;
    }

    const totalChunks = Math.ceil(recordToProceed.length / this.chunkSize);
    const concurrencyLimit = 6;
    let promises = [];

    while (this.currentChunkIndex < totalChunks) {
        if (this.isPause) {
            console.log('Process paused at chunk index:', this.currentChunkIndex);
            await new Promise(resolve => {
                const interval = setInterval(() => {
                    if (!this.isPause) {
                        clearInterval(interval);
                        resolve();
                    }
                }, 500);
            });
        }

        // Prepare next chunk
        const chunk = recordToProceed.slice(this.currentChunkIndex * this.chunkSize, (this.currentChunkIndex + 1) * this.chunkSize);

        // Push the promise for this chunk into the batch
        promises.push(
            this.sendChunkToApex(this.currentChunkIndex, chunk)
                .then(() => {
                    console.log('this.currentChunkIndex ==>',this.currentChunkIndex,totalChunks);
                    this.percentage = (((this.currentChunkIndex + 1) / totalChunks) * 100).toFixed(2);
                    console.log('current percentafe is ==>',this.percentage);
                    if(this.percentage > 100) {
                        this.percentage = 100;
                    }
                    this.updateProgressInChild();
                })
                .catch(error => {
                    console.error('Error sending chunk', this.currentChunkIndex, error);
                })
        );

        this.currentChunkIndex++;

        // If concurrency limit reached, wait for all promises to finish before continuing
        if (promises.length >= concurrencyLimit) {
            await Promise.all(promises);
            promises = [];
            // Add a small delay to avoid throttling if needed
            await new Promise(resolve => setTimeout(resolve, 100));
        }
    }

    // Await any remaining promises
    if (promises.length > 0) {
        await Promise.all(promises);
    }
}


    async sendChunkToApex(i, chunks) {
        try {
            this.isUpdateData = true;
            const results = await updateCase({ bCheck: this.checkNotInfevor, js: JSON.stringify(chunks), c_type: this.consumer_Status });
            this.countResult += results.length;
            results.forEach(result => {
                console.log('OUTPUT : ',result);
                const index = this.csvData.findIndex(row => row.Id.substring(0, 15) === result.Id.substring(0, 15));
                if (index !== -1) {
                    if (this.consumer_Status === 'Resolved in favour of the Consumer') {
                        this.csvData[index].logError = (result.logError && result.logError !== '-') ? result.logError : '-';
                        if(result.isError !=undefined){
                            console.log('OUTPUT : ',result.isError);
                          if(!!result.isError){
                             console.log('OUTPUT : isSuccess');
                             this.csvData[index].showDash = true;
                          }else {
                           this.csvData[index].isError = true;
                          }
                        }

                        if(result.Status=='Success'){
                          this.csvData[index].isSuccess = true;
                          this.csvData[index].isError = false;
                          this.csvData[index].showDash = false;

                        }else if(result.Status=='Failed'){
                          this.csvData[index].isError = true;
                          this.csvData[index].isSuccess = false;
                          this.csvData[index].showDash = false;
                        }

                    }
                    this.csvData[index].Status = result.Status;
                    this.csvData[index].Message = result.Message;
                }

                
            });

            
            if (this.countResult >= this.csvData.length) {
                if(this.downloadOnce <1){
                this.isDownloadResult = false;
                }
                this.isDownloadError = false;
            }
            this.getSuccessCount();


        } catch (error) {
            throw error; // Re-throw to be handled in sendDataInChunks
        }
    }


    sendProgressPercentage(percentage) {
        //console.log(`Progress: ${percentage.toFixed(2)}%`);

        const progressCircle = document.querySelector('.circle');
        const percentageText = document.querySelector('.percentage');

        // Update the stroke dasharray based on the percentage
        const offset = 100 - percentage; // 100 is the max value for the stroke-dasharray
        progressCircle.style.strokeDasharray = `${percentage}, 100`;

        // Update the text
        percentageText.textContent = `${Math.round(percentage)}%`;

        // if(percentage >= 100){
        //     this.isPause = true;
        //     this.isReRun = false;
        //     this.isResume = true;
        // }
    }



    @track showSpinnerDownload = false;

    downloadBeforeCsv() {
        console.log('Function called --> new fun', this.consumer_Status);

        // Check if there's data to download
        if (!this.csvData.length) {
            alert('No data available for download.');
            return;
        }
        this.downloadOnce = this.downloadOnce + 1;
        this.isDownloadResult = true;
        //this.showSpinnerDownload = true;

        // Filter out columns based on conditions
        if (this.consumer_Status === 'Resolved in favour of the Consumer') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Consumer_Dispute_Status_Template' && key !== 'API_Execution_status'  && key.trim() !== '');
        }
        if (this.consumer_Status === 'Resolved in favour of the Consumer - Data Submission') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Consumer_Dispute_Status_Template' && key!='Resolved_Based_On_Submission' && key !== 'API_Execution_status'  && key.trim() !== '');
        }

        if (this.consumer_Status === 'Resolved not in favour of the Consumer') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Consumer_Dispute_Status_Template' && key.trim() !== '');
        }

        if (this.consumer_Status == 'Forward to Bank') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Forward_to_Bank' && key !== 'Temp_forward_to_bank' && key.trim() !== '');
        }

        if (this.consumer_Status == 'Send Email to Consumer') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Send_Email_to_Consumer' && key.trim() !== '');
        }


        if (this.consumer_Status == 'Incident Update') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Forward_To_Matching_Team' && key !== 'Send_Email_to_Consumer' && key.trim() !== '');
            //this.headerKeys = [...rows[0].split(',').map(header => header.trim()),'Forward_To_Matching_Team','Send_Email_to_Consumer','Status','Message'];
        }

        if (this.consumer_Status == 'Matching in Favor') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Consumer_Dispute_Status_Template' && key.trim() !== '');

            //this.headerKeys = [...rows[0].split(',').map(header => header.trim()),'Consumer_Dispute_Status_Template',,'Status','Message'];
        }

        if (this.consumer_Status == 'Referred To IO Case') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Referred_To_IO_Case' && key !== 'Rejected_Region' && key.trim() !== '');
        }


        if (this.consumer_Status == 'Attach File to the Case') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'ShareType' && key !== 'Visibility' && key.trim() !== '');
        }


        if (this.checkNotInfevor) {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Rejection_Reason' && key.trim() !== '');
        }

        if (this.consumer_Status == 'Update CST Comment') {
            this.headerKeys = this.headerKeys.filter(key => key.trim() !== '');
        }

        if (this.consumer_Status == 'Complaint Withdrawn by Consumer') {
            this.headerKeys =this.headerKeys.filter(key => key !== 'Consumer Dispute Status' && key.trim() !== '');//  [...rows[0].split(',').map(header => header.trim()), 'Consumer Dispute Status', 'Final Status', 'Message'];
        }
        if (this.consumer_Status == 'Update Junk Case') {
            this.headerKeys =this.headerKeys.filter(key => key !== 'Junk case' && key !== 'Status' && key.trim() !== '');//  [...rows[0].split(',').map(header => header.trim()), 'Consumer Dispute Status', 'Final Status', 'Message'];
        }
        if (this.consumer_Status == 'Send Email Acknowledgement') {
            this.headerKeys =this.headerKeys.filter(key => key !== 'Send_Email_Acknowledgement' && key !== 'Status' && key.trim() !== '');//  [...rows[0].split(',').map(header => header.trim()), 'Consumer Dispute Status', 'Final Status', 'Message'];
        }

        if (this.consumer_Status == 'Update Open to Resolved') {
            this.headerKeys =this.headerKeys.filter(key =>key !== 'Status' && key.trim() !== '');//  [...rows[0].split(',').map(header => header.trim()), 'Consumer Dispute Status', 'Final Status', 'Message'];
        }

        if (this.consumer_Status == 'Update Contact Header Details') {
            this.headerKeys =this.headerKeys.filter(key =>key !== 'Status' && key.trim() !== '');//  [...rows[0].split(',').map(header => header.trim()), 'Consumer Dispute Status', 'Final Status', 'Message'];
        }

        if (this.consumer_Status == 'Bank details requirement - Draft 1' || this.consumer_Status == 'Bank details requirement - Draft 2' || this.consumer_Status == 'Payment Confirmation to Consumer' || 
            this.consumer_Status == 'CI Liable email to Consumer' || this.consumer_Status == 'CIC Liable email to Consumer' || this.consumer_Status == 'Bank details requirement for reprocessing' ||
            this.consumer_Status == 'Update NC Case' || this.consumer_Status == 'Send Provide Proof' || this.consumer_Status == 'Send New Provide Proof' || this.consumer_Status == 'Send NC 1st Attempt' || 
            this.consumer_Status == 'Send Call Back') {
            this.headerKeys = this.headerKeys.filter(key => key.trim() !== '');
        }


        


        




        // Create the CSV header row
        const header = this.headerKeys.join(',');  // Using comma to separate columns
        console.log(this.consumer_Status,header );
        let row = '';  // Initialize the CSV content with the header row

        // Handle the different consumer statuses to build the rows
        if (this.consumer_Status === 'Resolved in favour of the Consumer') {
            console.log('inside ',this.consumer_Status);
            
            for (let i = 0; i < this.csvData.length; i++) {
                // let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                //     + this.csvData[i].Id.replace('\r', '') + ','
                //     + this.csvData[i].Last_Reply_from_Bank_Team.replace('\r', '') + ','
                //     + this.csvData[i].isError.replace('\r', '') + ','
                //     + this.csvData[i].logError.replace('\r', '') + ','
                //     + this.csvData[i].Status.replace('\r', '') + ','
                //     + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ',';


                console.log('inside Error failed--> ', this.csvData[i].Status,this.csvData[i].isError);
    
                // Create the CSV row, replacing '\r' with empty string if necessary
                let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ',' 
                           + this.csvData[i].Id.replace('\r', '') + ',' 
                           + this.csvData[i].Last_Reply_from_Bank_Team.replace('\r', '') + ',' 
                           + this.csvData[i].Origin.replace('\r', '') + ',' 
                           + this.csvData[i].Status.replace('\r', '') + ',' 
                           + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                           + this.csvData[i].logError.replace('\r', '').replace(/,/g, ' ') + ',' ;
                           console.log('csvRow-->',csvRow);
                           
                // Append the row to the existing 'row' string
                row += '\n' + csvRow;
            }
        }

        if (this.consumer_Status === 'Resolved in favour of the Consumer - Data Submission') {
            console.log('inside ',this.consumer_Status);
            
            for (let i = 0; i < this.csvData.length; i++) {
                // let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                //     + this.csvData[i].Id.replace('\r', '') + ','
                //     + this.csvData[i].Last_Reply_from_Bank_Team.replace('\r', '') + ','
                //     + this.csvData[i].isError.replace('\r', '') + ','
                //     + this.csvData[i].logError.replace('\r', '') + ','
                //     + this.csvData[i].Status.replace('\r', '') + ','
                //     + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ',';


                console.log('inside Error failed--> ', this.csvData[i].Status,this.csvData[i].isError);
    
                // Create the CSV row, replacing '\r' with empty string if necessary
                let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ',' 
                           + this.csvData[i].Id.replace('\r', '') + ',' 
                           + this.csvData[i].Last_Reply_from_Bank_Team.replace('\r', '') + ',' 
                           + this.csvData[i].Origin.replace('\r', '') + ',' 
                           + this.csvData[i].Status.replace('\r', '') + ',' 
                           + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                           + this.csvData[i].logError.replace('\r', '').replace(/,/g, ' ') + ',' ;
                           console.log('csvRow-->',csvRow);
                           
                // Append the row to the existing 'row' string
                row += '\n' + csvRow;
            }
        }

        
        else if (this.consumer_Status === 'Resolved not in favour of the Consumer') {
            for (let i = 0; i < this.csvData.length; i++) {
                let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                    + this.csvData[i].Id.replace('\r', '') + ','
                    + this.csvData[i].Last_Reply_from_Bank_Team.replace('\r', '') + ','
                    + this.csvData[i].Status.replace('\r', '') + ','
                    + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','

                row += '\n' + csvRow;
            }
        }
        else if (this.consumer_Status === 'Enquiry User Id') {
            for (let i = 0; i < this.csvData.length; i++) {
                let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                    + this.csvData[i].Id.replace('\r', '') + ','
                    + this.csvData[i].enquiry_User_Id.replace('\r', '') + ','
                    + this.csvData[i].enquiry_Loan_Amount.replace('\r', '') + ','
                    + this.csvData[i].Status.replace('\r', '') + ','
                    + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                row += '\n' + csvRow;
            }
        } 
        else if (this.consumer_Status === 'Change Owner Id') {
            for (let i = 0; i < this.csvData.length; i++) {
                let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                    + this.csvData[i].Id.replace('\r', '') + ','
                    + this.csvData[i].OwnerId.replace('\r', '') + ','
                    + this.csvData[i].Status.replace('\r', '') + ','
                    + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                row += '\n' + csvRow;


            }

        } 
        else if (this.consumer_Status === 'Forward to Bank') {
            for (let i = 0; i < this.csvData.length; i++) {
                let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                    + this.csvData[i].Id.replace('\r', '') + ','
                    + this.csvData[i].Status.replace('\r', '') + ','
                    + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                row += '\n' + csvRow;


            }


        }
         else if (this.consumer_Status === 'Send Email to Consumer') {
            for (let i = 0; i < this.csvData.length; i++) {
                let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                    + this.csvData[i].Id.replace('\r', '') + ','
                    + this.csvData[i].Status.replace('\r', '') + ','
                    + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                row += '\n' + csvRow;


            }

        }
         else if (this.consumer_Status === 'Sub Type 1 Change') {
            for (let i = 0; i < this.csvData.length; i++) {
                let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                    + this.csvData[i].Id.replace('\r', '') + ','
                    + this.csvData[i].subtypeOneId.replace('\r', '') + ','
                    + this.csvData[i].MatchingCommentsub.replace('\r', '') + ','
                    + this.csvData[i].LastReplyFromMatchingTeamforSub.replace('\r', '') + ','
                    + this.csvData[i].Status.replace('\r', '') + ','
                    + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                row += '\n' + csvRow;


            }
        }

        else if (this.consumer_Status === 'Matching in Favor') {
            for (let i = 0; i < this.csvData.length; i++) {
                let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                    + this.csvData[i].Id.replace('\r', '') + ','
                    + this.csvData[i].LastReplyFromMatchingTeam.replace('\r', '') + ','
                    + this.csvData[i].MatchingComment.replace('\r', '') + ','
                    + this.csvData[i].Status.replace('\r', '') + ','
                    + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                row += '\n' + csvRow;


            }

        }
        else if (this.consumer_Status === 'Incident Update') {
            for (let i = 0; i < this.csvData.length; i++) {
                let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                    + this.csvData[i].Id.replace('\r', '') + ','
                    + this.csvData[i].incidentNo.replace('\r', '') + ','
                    + this.csvData[i].Status.replace('\r', '') + ','
                    + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                row += '\n' + csvRow;


            }
        }
        else if (this.consumer_Status == 'Referred To IO Case') {
            for (let i = 0; i < this.csvData.length; i++) {
                let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                    + this.csvData[i].Id.replace('\r', '') + ','
                    + this.csvData[i].lastReplyFromBacnkTeam_ref.replace('\r', '') + ','
                    + this.csvData[i].disputeRejectedRegion_ref.replace('\r', '') + ','
                    + this.csvData[i].Status.replace('\r', '') + ','
                    + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                row += '\n' + csvRow;


            }
        } 
        else if (this.consumer_Status == 'Attach File to the Case') {
                for (let i = 0; i < this.csvData.length; i++) {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].ContentDocumentId.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;


                }
        }
        else if (this.consumer_Status == 'Update CST Comment') {
                for (let i = 0; i < this.csvData.length; i++) {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].caseCSTComment.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;


                }
        }
        else if (this.consumer_Status == 'Complaint Withdrawn by Consumer') {
                for (let i = 0; i < this.csvData.length; i++) {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].caseCSTCommentv1.replace('\r', '') + ','
                        + this.csvData[i].telConversionDate.replace('\r', '') + ','
                        + this.csvData[i].ComplaintConsumerStatus.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;


                }
        }

        else if (this.consumer_Status == 'Update Junk Case') {
                for (let i = 0; i < this.csvData.length; i++) {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                       + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                }
        }

        else if (this.consumer_Status == 'Send Email Acknowledgement' || this.consumer_Status == 'Bank details requirement - Draft 1' || 
                this.consumer_Status == 'Bank details requirement - Draft 2' || this.consumer_Status == 'Payment Confirmation to Consumer' || 
                this.consumer_Status == 'CI Liable email to Consumer' || this.consumer_Status == 'CIC Liable email to Consumer' || 
                this.consumer_Status == 'Bank details requirement for reprocessing' || this.consumer_Status == 'Update NC Case' ||
                this.consumer_Status == 'Send Provide Proof' || this.consumer_Status == 'Send New Provide Proof' || this.consumer_Status == 'Send NC 1st Attempt' || 
                this.consumer_Status == 'Send Call Back') {
                for (let i = 0; i < this.csvData.length; i++) {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                       + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                }
        }

        else if (this.consumer_Status === 'Update ECICI Remarks') {
            for (let i = 0; i < this.csvData.length; i++) {
                let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                            + this.csvData[i].Id.replace('\r', '') + ','
                            + this.csvData[i].ECICI_Remarks.replace('\r', '') + ',' 
                            + this.csvData[i].Status.replace('\r', '') + ','
                            + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                row += '\n' + csvRow;
            }
        }

        else if (this.consumer_Status === 'Update ReClose Status') {
            for (let i = 0; i < this.csvData.length; i++) {
                let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                            + this.csvData[i].Id.replace('\r', '') + ','
                            + this.csvData[i].Status.replace('\r', '') + ','
                            + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                row += '\n' + csvRow;
            }
        }


                else if (this.consumer_Status == 'Update Open to Resolved') {
                for (let i = 0; i < this.csvData.length; i++) {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                       + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                }
                }


                else if (this.consumer_Status == 'Update Contact Header Details') {
                for (let i = 0; i < this.csvData.length; i++) {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                         + this.csvData[i].Contact_Name.replace('\r', '') + ','
                          + this.csvData[i].ContactEmailId.replace('\r', '') + ','
                           + this.csvData[i].Contact_Gender.replace('\r', '') + ','
                            + this.csvData[i].ContactPan.replace('\r', '') + ','
                             + this.csvData[i].ContactMobileNo.replace('\r', '') + ','
                             + this.csvData[i].Contact_Date_of_Birth.replace('\r', '') + ','
                             + this.csvData[i].Contact_Address.replace('\r', '') + ','
                       + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                }


                // + this.csvData[i].Junkcase.replace('\r', '') + ','
                      //  + this.csvData[i].JunkStatus.replace('\r', '') + ','
                        
        }
        console.log('row-->',row);
        
        if (row != null && row != '' && row != undefined) {
            console.log('CSV inside if content: ', row);
            let temp = header;
            temp += row;
            this.showSpinnerDownload = false;
            this.downloadCsv(temp,'result of ');
            this.isDownloadResult = true;
        }

    }

    @track reRunCount = 0;

    get buttonLabel() {
        return `Re-Run Failed ${this.reRunCount}`;
    }


    @track isDownloadError = true;
   
    @track isFileUpload = false;

errorMessage(logErrors){
    let rowVal = '';
   let logError = logErrors || '';  // Default to empty string if undefined
        if (logError.length > maxLogErrorLength) {
            // Split the logError into chunks of maxLogErrorLength
            let chunks = [];
            for (let j = 0; j < logError.length; j += maxLogErrorLength) {
                chunks.push(logError.substring(j, j + maxLogErrorLength));
            }

            // For each chunk, append a new row with the chunk of logError
            for (let k = 0; k < chunks.length; k++) {
                let continuationRow = csvRow.replace(this.csvData[i].logError, chunks[k]);
                rowVal += '\n' + continuationRow;
            }
        }
    
    return rowVal;
}
        
    disabledButtonFun(){
        this.isFileUpload = false;
        this.isUpdateData = false;
        this.isReRun = false;
        //this.isDownloadResult = false;
        this.isDownloadError = false;
        
    }

    @track downloadErrorCount = 0;
    downloadErrorCsv() {

        this.downloadErrorCount = this.downloadErrorCount + 1;
        // if(this.downloadErrorCount == 2){
        //    this.isDownloadError = true;
        // }
        


        console.log('Function called Error--> new fun', this.consumer_Status);

        // Check if there's data to download
        if (!this.csvData.length) {
            alert('No data available for download.');
            return;
        }

//this.showSpinnerDownload = true;

    console.log('OUTPUT : ',this.headerKeys);
        // Filter out columns based on conditions
        if (this.consumer_Status === 'Resolved in favour of the Consumer') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Consumer_Dispute_Status_Template' && key !== 'API_Execution_status' && key.trim() !== '');
        }

        if (this.consumer_Status === 'Resolved in favour of the Consumer - Data Submission') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Consumer_Dispute_Status_Template' && key!='Resolved_Based_On_Submission' && key !== 'API_Execution_status'  && key.trim() !== '');
        }

        if (this.consumer_Status === 'Resolved not in favour of the Consumer') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Consumer_Dispute_Status_Template' && key.trim() !== '');
        }

        if (this.consumer_Status == 'Forward to Bank') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Forward_to_Bank' && key !== 'Temp_forward_to_bank' && key.trim() !== '');
        }

        if (this.consumer_Status == 'Send Email to Consumer') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Send_Email_to_Consumer' && key.trim() !== '');
        }


        if (this.consumer_Status == 'Incident Update') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Forward_To_Matching_Team' && key !== 'Send_Email_to_Consumer' && key.trim() !== '');
            //this.headerKeys = [...rows[0].split(',').map(header => header.trim()),'Forward_To_Matching_Team','Send_Email_to_Consumer','Status','Message'];
        }

        if (this.consumer_Status == 'Matching in Favor') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Consumer_Dispute_Status_Template' && key.trim() !== '');

            //this.headerKeys = [...rows[0].split(',').map(header => header.trim()),'Consumer_Dispute_Status_Template',,'Status','Message'];
        }

        if (this.consumer_Status == 'Referred To IO Case') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Referred_To_IO_Case' && key !== 'Rejected_Region' && key.trim() !== '');
        }


        if (this.consumer_Status == 'Attach File to the Case') {
            this.headerKeys = this.headerKeys.filter(key => key !== 'ShareType' && key !== 'Visibility' && key.trim() !== '');
        }


        if (this.checkNotInfevor) {
            this.headerKeys = this.headerKeys.filter(key => key !== 'Rejection_Reason' && key.trim() !== '');
        }

        if (this.consumer_Status == 'Update CST Comment') {
            this.headerKeys = this.headerKeys.filter(key => key.trim() !== '');
        }

        if (this.consumer_Status == 'Complaint Withdrawn by Consumer') {
            this.headerKeys =this.headerKeys.filter(key => key !== 'Consumer Dispute Status' && key.trim() !== '');//  [...rows[0].split(',').map(header => header.trim()), 'Consumer Dispute Status', 'Final Status', 'Message'];
        }




        // Create the CSV header row
        const header = this.headerKeys.join(',');  // Using comma to separate columns
        
        
        let row = '';  // Initialize the CSV content with the header row

        // Handle the different consumer statuses to build the rows
        if (this.consumer_Status === 'Resolved in favour of the Consumer') {
            console.log('inside Error ', this.consumer_Status);
            for (let i = 0; i < this.csvData.length; i++) {
            if (this.csvData[i].Status === 'Failed') {
                console.log('inside Error failed--> ', this.csvData[i].Status,this.csvData[i].isError);
    
                // Create the CSV row, replacing '\r' with empty string if necessary
                let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ',' 
                           + this.csvData[i].Id.replace('\r', '') + ',' 
                           + this.csvData[i].Last_Reply_from_Bank_Team.replace('\r', '') + ',' 
                           + this.csvData[i].Origin.replace('\r', '') + ',' 
                           + this.csvData[i].Status.replace('\r', '') + ',' 
                           + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                          + this.csvData[i].logError.replace('\r', '').replace(/,/g, ' ') + ',' ;

                           console.log('csvRow-->',csvRow);
                           
                // Append the row to the existing 'row' string
                row += '\n' + csvRow;
                console.log('inside Error failed-- row -> ', row);
            }
            }
        }
        else if (this.consumer_Status === 'Resolved not in favour of the Consumer') {
            for (let i = 0; i < this.csvData.length; i++) {
                if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].Last_Reply_from_Bank_Team.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','

                    row += '\n' + csvRow;
                }
            }
        }
        else if (this.consumer_Status === 'Enquiry User Id') {
            for (let i = 0; i < this.csvData.length; i++) {
                if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].enquiry_User_Id.replace('\r', '') + ','
                        + this.csvData[i].enquiry_Loan_Amount.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                }
            }
        } else if (this.consumer_Status === 'Change Owner Id') {
            for (let i = 0; i < this.csvData.length; i++) {
                if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].OwnerId.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                }

            }

        } else if (this.consumer_Status === 'Forward to Bank') {
            for (let i = 0; i < this.csvData.length; i++) {
                if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                }


            }


        } else if (this.consumer_Status === 'Send Email to Consumer') {
            for (let i = 0; i < this.csvData.length; i++) {
                if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                }


            }

        } else if (this.consumer_Status === 'Sub Type 1 Change') {
            for (let i = 0; i < this.csvData.length; i++) {
                if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].subtypeOneId.replace('\r', '') + ','
                        + this.csvData[i].MatchingCommentsub.replace('\r', '') + ','
                        + this.csvData[i].LastReplyFromMatchingTeamforSub.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                }

            }
        }

        else if (this.consumer_Status === 'Matching in Favor') {
            for (let i = 0; i < this.csvData.length; i++) {
                if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].LastReplyFromMatchingTeam.replace('\r', '') + ','
                        + this.csvData[i].MatchingComment.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;

                }
            }

        }
        else if (this.consumer_Status === 'Incident Update') {
            for (let i = 0; i < this.csvData.length; i++) {
                if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].incidentNo.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                }

            }
        }
        else if (this.consumer_Status == 'Referred To IO Case') {
            for (let i = 0; i < this.csvData.length; i++) {
                if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].lastReplyFromBacnkTeam_ref.replace('\r', '') + ','
                        + this.csvData[i].disputeRejectedRegion_ref.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                }

            }
        } else
            if (this.consumer_Status == 'Attach File to the Case') {
                for (let i = 0; i < this.csvData.length; i++) {
                    if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                        let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                            + this.csvData[i].Id.replace('\r', '') + ','
                            + this.csvData[i].ContentDocumentId.replace('\r', '') + ','
                            + this.csvData[i].Status.replace('\r', '') + ','
                            + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                        row += '\n' + csvRow;

                    }
                }
            }
             else if (this.consumer_Status == 'Update CST Comment') {
                for (let i = 0; i < this.csvData.length; i++) {
                    if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].caseCSTComment.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                    }


                }
        }
        else if (this.consumer_Status == 'Complaint Withdrawn by Consumer') {
                for (let i = 0; i < this.csvData.length; i++) {
                    if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].caseCSTCommentv1.replace('\r', '') + ','
                        + this.csvData[i].telConversionDate.replace('\r', '') + ','
                        + this.csvData[i].ComplaintConsumerStatus.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                    }


                }
        }
         else if (this.consumer_Status == 'Update Junk Case') {
                for (let i = 0; i < this.csvData.length; i++) {
                    if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                    }


                }
        }else if (this.consumer_Status == 'Send Email Acknowledgement' || this.consumer_Status == 'Bank details requirement - Draft 1' || 
                this.consumer_Status == 'Bank details requirement - Draft 2' || this.consumer_Status == 'Payment Confirmation to Consumer' || 
                this.consumer_Status == 'CI Liable email to Consumer' || this.consumer_Status == 'CIC Liable email to Consumer' || 
                this.consumer_Status == 'Bank details requirement for reprocessing' ||  this.consumer_Status == 'Update NC Case' ||
                this.consumer_Status == 'Send Provide Proof' || this.consumer_Status == 'Send New Provide Proof' || this.consumer_Status == 'Send NC 1st Attempt' || 
                this.consumer_Status == 'Send Call Back') {
                for (let i = 0; i < this.csvData.length; i++) {
                    if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                       + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                    }
                }
        }

        else if (this.consumer_Status === 'Update ECICI Remarks') {
            for (let i = 0; i < this.csvData.length; i++) {
                    if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                        +this.csvData[i].ECICI_Remarks.replace('\r', '') + ','
                       + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                    }
                }
        }

        else if (this.consumer_Status === 'Update ReClose Status') {
            for (let i = 0; i < this.csvData.length; i++) {
                    if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                       + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                    }
                }
        }

        else if (this.consumer_Status == 'Update Open to Resolved') {
                for (let i = 0; i < this.csvData.length; i++) {
                    if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                       + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                    }
                }
        }
         else if (this.consumer_Status == 'Update Contact Header Details') {
                for (let i = 0; i < this.csvData.length; i++) {
                    if (this.csvData[i].Status == 'Failed' || this.csvData[i].Status == '-') {
                    let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ','
                        + this.csvData[i].Id.replace('\r', '') + ','
                         + this.csvData[i].Contact_Name.replace('\r', '') + ','
                          + this.csvData[i].ContactEmailId.replace('\r', '') + ','
                           + this.csvData[i].Contact_Gender.replace('\r', '') + ','
                            + this.csvData[i].ContactPan.replace('\r', '') + ','
                             + this.csvData[i].ContactMobileNo.replace('\r', '') + ','
                             + this.csvData[i].Contact_Date_of_Birth.replace('\r', '') + ','
                             + this.csvData[i].Contact_Address.replace('\r', '') + ','
                       + this.csvData[i].Status.replace('\r', '') + ','
                        + this.csvData[i].Message.replace('\r', '').replace(/,/g, ' ') + ','
                    row += '\n' + csvRow;
                    }
                }
         }


        if (row != null && row != '' && row != undefined) {
            console.log('CSV inside if content: ', row);
            let temp = header;
            temp += row;
            this.showSpinnerDownload = false;
            this.downloadCsv(temp,'error of ');
        }

    }

    


    startSetUp() {
        this.csvData = [];
        this.headerKeys = [];
        this.showTableData = false;
        this.isDownloadResult = true;
        this.percentage = 0;
        this.updateProgressInChild();
    }

    // Function to trigger the CSV download
    downloadCsv(row,type) {

        const csvContent = row;
        //this.startSetUp();
        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        let downloadElement = document.createElement('a');

        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvContent);
        downloadElement.target = '_self';

        downloadElement.download = this.getFileName(type);
        document.body.appendChild(downloadElement);
        downloadElement.click();
        document.body.removeChild(downloadElement);
    }

    Refresh(){
        this.isDownloadError = true;
        this.countResult = 0;
       this.sendDataInChunks();
    }

    getFileName(type) {
        const currentDate = new Date();

        const formattedDate = currentDate.toISOString().split('T')[0];

        const hours = currentDate.getHours().toString().padStart(2, '0'); // Ensures two-digit hours
        const minutes = currentDate.getMinutes().toString().padStart(2, '0'); // Ensures two-digit minutes
        const formattedTime = `${hours}:${minutes}`;

        const fileName = `${type}${this.consumer_Status} ${formattedDate}_${formattedTime}.csv`;
        return fileName;
    }

@track isRefresh =true;   
 updateProgressInChild() {
        // Get the reference to the child component using 'this.template.querySelector'
        const progressBar = this.template.querySelector('c-progress-bar');

        // Call the updateProgress method of the child component
        if (progressBar) {
            progressBar.updateProgress(this.percentage);
        }

        if(this.percentage >=100){
            this.isPause = true;
            this.isRefresh = false;
            this.isDownloadError = false;
            // if(this.reRunCount < 2){
            //     this.isReRun = false;
            // }
            this.isResume = true;
        }
    }


    handleDownloadModel() {
        let headers = 'CaseNumber,Id';
        if (this.consumer_Status == 'Resolved in favour of the Consumer'){
            headers += ',Last_Reply_from_Bank_Team,Origin';
        }
        if (this.consumer_Status == 'Resolved in favour of the Consumer - Data Submission'){
            headers += ',Last_Reply_from_Bank_Team,Origin';
        }
        
        else 
        if (this.consumer_Status == 'Resolved not in favour of the Consumer') {
            headers += ',Last_Reply_from_Bank_Team';
        } else if (this.consumer_Status == 'Enquiry User Id') {
            headers += ',enquiry_User_Id,enquiry_Loan_Amount';
        } else if (this.consumer_Status == 'Change Owner Id') {
            headers += ',OwnerId';
        } else if (this.consumer_Status == 'Forward to Bank') {
            //headers +=',temp_forward_to_bank,forward_to_bank';
        } else if (this.consumer_Status == 'Send Email to Consumer') {
        }

        //Sub Type 1 Change,Matching in Favor,Incident Update
        else if (this.consumer_Status == 'Sub Type 1 Change') {
            headers += ',Sub_Type_1_Id,Matching_Comment,Last_Reply_From_Matching_Team';
        } else if (this.consumer_Status == 'Matching in Favor') {
            headers += ',Last_Reply_From_Matching_Team,Matching_Comment';
        } else if (this.consumer_Status == 'Incident Update') {
            headers += ',Incident_No';
        }
        else if (this.consumer_Status == 'Referred To IO Case') {
            headers += ',Last_reply_from_Bank_Team,Dispute_Rejected_Reason';
        } else if (this.consumer_Status == 'Attach File to the Case') {
            headers += ',ContentDocumentId';
        }else if (this.consumer_Status == 'Update CST Comment') {
            headers += ',CST_Comments';
        }else if (this.consumer_Status == 'Complaint Withdrawn by Consumer') {
            headers += ',CST_Comments,Telephonic_Conversation_Date';
        }else if (this.consumer_Status == 'Update ECICI Remarks'){
            headers += ',ECICI_Remarks';
        }


        else if (this.consumer_Status == 'Update Contact Header Details') {
            headers += ',Contact_Name,ContactEmailId,Contact_Gender,ContactPan,ContactMobileNo,Contact_Date_of_Birth,Contact_Address';
        }
        // else if (this.consumer_Status == 'Update Junk Case') {
        //     headers += '';
        // }
        //this.downloadCsvheader(headers);
        this.downloadCsv(headers,'header of ');
    }

    downloadCsvheader(row) {

        const csvContent = row + '\n';
        console.log('csvContent : ', csvContent);
        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        let downloadElement = document.createElement('a');

        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvContent);
        downloadElement.target = '_self';

        downloadElement.download = `${this.consumer_Status} header.csv`;
        document.body.appendChild(downloadElement);
        downloadElement.click();
        document.body.removeChild(downloadElement);
    }


}