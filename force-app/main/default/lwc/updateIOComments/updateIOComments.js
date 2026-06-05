import { LightningElement,track } from 'lwc';
import updateCase from '@salesforce/apex/updateIOCommentController.updateCase';
import {
ShowToastEvent
} from 'lightning/platformShowToastEvent';
export default class UpdateIOComments extends LightningElement {
get acceptedFormats() {
    return ['.csv'];
}

@track checkNotInfevor = false;
 @track totalLoadedCase = 0;
 @track failedCase = 0;
@track successCase = 0;
@track isRefresh =true;  
@track isUpdateData = true;
@track isDownloadError = true;

get options() {
    return [
        { label: 'None', value: '' },
        { label: 'Accept', value: 'Accept' },
        { label: 'Reject', value: 'Reject' },
        
    ];
}

@track disabledDone = true;

@track csvData = [];
@track headerKeys = [];

@track showTableData = false;
handleFileChange(event) {
    const file = event.target.files[0];
    this.disabledDone = false;
    this.csvData = [];
    if (file && file.type === 'text/csv') {
        const reader = new FileReader();
        reader.onload = () => {
            const csvData = reader.result;
            if (csvData.includes('\n\n')) {
    csvData = csvData.replace(/\n\n/g, '');  // Remove extra newlines
}
if (csvData.includes(' $')) {
    csvData = csvData.replace(/ $/g, '');  // Remove spaces before newlines
}
if (csvData.includes('\n\"')) {
    csvData = csvData.replace(/\n\"/g, '');  // Remove newline before quotes
}
if (csvData.includes('\n \"')) {
    csvData = csvData.replace(/\n \"/g, '');  // Remove space and newline before quotes
}
if (csvData.includes('\"\n')) {
    csvData = csvData.replace(/\"\n/g, '');  // Remove quote and newline
}

            this.processCSV(csvData);
        };
        reader.readAsText(file);
    } else {
        alert('Please upload a valid CSV file.');
    }
}

@track consumer_Status = '';
handleChange(event){
    this.consumer_Status = event.target.value;

    if(this.consumer_Status =='Resolved not in favour of the Consumer'){
        this.checkNotInfevor = true;
    }else{
        this.checkNotInfevor = false;
    }
    console.log('this.consumer_Status-->',this.consumer_Status,this.checkNotInfevor);
    

}

@track openModel = false;
handleOpenModel(){
    this.csvData = [];
    this.headerKeys = [];
    this.showTableData = false;
    this.openModel = true;
    this.disabledDone = true;
    this.isDownloadResult = true;
    this.percentage = 0;
    this.updateProgressInChild();

}

//     handleMouseOver() {
//         if(this.consumer_Status ==''){
//         //this.showMessage = true;
//         this.showToast('Error','Please Select IO Status','error');

//             }
//    }

handleMouseOut() {
    //this.showMessage = false;
}


showToast(title,msg,vari){
        const event = new ShowToastEvent({
            title: title,
            message: msg,
            variant: vari
        });
        this.dispatchEvent(event);
}


handleCloseModel(){
    this.openModel = false;
}

handleDoneModel(){
    this.showSpinner = true;
    this.openModel = false;

    setTimeout(() => {
        this.showSpinner = false;
        this.isUpdateData = false;
        this.showTableData = true;
    }, 2000);
    
}

processCSV(csv) {
    console.log('result-->',JSON.stringify(csv));
    
    const rows = csv.split('\n');
    this.headerKeys = [...rows[0].split(',').map(header => header.trim()),'Status','Message'];

    this.headerKeys = this.headerKeys.filter(key =>key.trim() !== '');

    console.log('this.headerKeys-',this.headerKeys);
    
    rows.slice(1).map((row, index) => {


        const values = row.split(',');
        
        if(values[0] !=undefined && values[0] !=''){
        const obj = {};
        
        obj['Serial_No'] = index + 1;


        obj['CaseNumber'] = values[0];
        obj['Id'] = values[1];
        obj['url'] = '/'+values[1].replace('\r', '');
        obj['IO_Status'] = values[2];
        obj['IO_Comment'] = values[3];
        //  obj['Dispute_Rejected_Reason'] = values[4];
        obj['Status'] = ''; // Status is blank
        obj['Message'] = '';
        obj.index = index;
        
        console.log('--obj--> ',JSON.stringify(obj));
        this.csvData.push(obj);
        this.totalLoadedCase = this.csvData.length;
        // return obj;
    }
    
    }).filter(row => row[headerKeys[0]]); // Filter out any empty rows
    //console.log('this.csvData 1--->', headerKeys[0]);
    console.log('this.csvData length',this.csvData.length);
    
}


@track chunkSize = 1;
@track isDownloadResult = true;
@track countResult = 0;
@track percentage = 0;
// async sendDataInChunks() {
//     const totalChunks = Math.ceil(this.csvData.length / this.chunkSize);

//     for (let i = 0; i < totalChunks; i++) {
//         //console.log('Processing chunk:', i);
        
//         const chunk = this.csvData.slice(i * this.chunkSize, (i + 1) * this.chunkSize);
        
//         try {
//             await this.sendChunkToApex(i, chunk);
//             this.percentage = (((i + 1) / totalChunks) * 100).toFixed(2);
//             this.updateProgressInChild();
//             //this.sendProgressPercentage((i + 1) / totalChunks * 100);
//         } catch (error) {
//             console.error('Error sending chunk', i, error);
//             // Optional: Handle error (e.g., skip this chunk or retry)
//         }

//         // Throttle requests
//         await new Promise(resolve => setTimeout(resolve, 100)); // 100 ms delay
//     }
// }

// async sendChunkToApex(i, chunks) {
//     try {
//         this.isUpdateData = true;

//         const results = await updateCase({ bCheck: this.checkNotInfevor, js: JSON.stringify(chunks) });
        
//         // Update countResult
//         this.countResult += results.length;

//         results.forEach(result => {
//             const index = this.csvData.findIndex(row => row.Id.substring(0, 15) === result.Id.substring(0, 15));
//             if (index !== -1) {
//                 this.csvData[index].Status = result.Status;
//                 this.csvData[index].Message = result.Message;
//             }
//         });

//         //console.log('Processed chunk:', i, 'Count result:', this.countResult);

//         // Check if all records are processed
//         if (this.countResult == this.csvData.length) {
//             //console.log('All records processed');
//             this.isDownloadResult = false;
//         }

//     } catch (error) {
//         // console.error('Error in sendChunkToApex:', error);
//         throw error; // Re-throw to be handled in sendDataInChunks
//     }
// }


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

//6 queue in one chunk


async sendDataInChunks() {

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
    const concurrencyLimit = 6; // Set the maximum number of concurrent requests
    const promises = []; // Array to hold the promises for concurrent chunks

    

    for (let i = 0; i < totalChunks; i++) {
        const chunk = recordToProceed.slice(i * this.chunkSize, (i + 1) * this.chunkSize);
        promises.push(this.sendChunkToApex(i, chunk));
        if (promises.length >= concurrencyLimit) {
            await Promise.all(promises); 
            promises.length = 0;
        }

        this.percentage = (((i + 1) / totalChunks) * 100).toFixed(2);
        this.updateProgressInChild();
    }

    if (promises.length > 0) {
        await Promise.all(promises);
    }
}

async sendChunkToApex(i, chunks) {
    try {
        this.isUpdateData = true;

        const results = await updateCase({ bCheck: this.checkNotInfevor, js: JSON.stringify(chunks) });
        
        // Update countResult
        this.countResult += results.length;

        results.forEach(result => {
            const index = this.csvData.findIndex(row => row.Id.substring(0, 15) === result.Id.substring(0, 15));
            if (index !== -1) {
                this.csvData[index].Status = result.Status;
                this.csvData[index].Message = result.Message;
            }
        });

        // Check if all records are processed
        if (this.countResult === this.csvData.length) {
            this.isDownloadResult = false;
        }
        this.getSuccessCount();

    } catch (error) {
        console.error('Error in sendChunkToApex:', error);
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
}


Refresh(){
        this.isDownloadError = true;
        this.countResult = 0;
       this.sendDataInChunks();
}

downloadErrorCsv(){
        if (!this.csvData.length) {
        alert('No data available for download.');
        return;
    }
    
    //this.headerKeys = this.headerKeys.filter(key => key !== 'IO_Status' && key.trim() !== '');
console.log('OUTPUT : ',JSON.stringify(this.csvData));
    const header = this.headerKeys.join(',');
    
    let row = header; // Start with the header row
    
        for (let i = 0; i < this.csvData.length; i++) {
            if (this.csvData[i].Status === 'Failed') {
        let message = this.csvData[i].Message;

        if (message.includes('\n\n')) {
        message = message.replace(/\n\n/g, '');  // Or replace with something else if necessary
        }

        message = message.replace('\r', '').replace(/,/g, ' ') + ','; 

            let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ',' 
            + this.csvData[i].Id.replace('\r', '') + ',' 
                + this.csvData[i].IO_Status.replace('\r', '')+','
            + this.csvData[i].IO_Comment.replace('\r', '').replace(/,/g, ' ') + ','
            + this.csvData[i].Status.replace('\r', '') + ',' 
            + message + ','
            row +='\n'+ csvRow;
        }
        }
    
    // Final CSV content
    const csvContent = row;
    
    
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    let downloadElement = document.createElement('a');

    downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvContent);
    downloadElement.target = '_self';
    downloadElement.download = 'result.csv';
    document.body.appendChild(downloadElement);
    downloadElement.click();
}




downloadCsv() {
    if (!this.csvData.length) {
        alert('No data available for download.');
        return;
    }
    
    //this.headerKeys = this.headerKeys.filter(key => key !== 'IO_Status' && key.trim() !== '');
console.log('OUTPUT : ',JSON.stringify(this.csvData));
    const header = this.headerKeys.join(',');
    
    let row = header; // Start with the header row
    
    for (let i = 0; i < this.csvData.length; i++) {
let message = this.csvData[i].Message;

if (message.includes('\n\n')) {
    message = message.replace(/\n\n/g, '');  // Or replace with something else if necessary
}

message = message.replace('\r', '').replace(/,/g, ' ') + ','; 

        let csvRow = this.csvData[i].CaseNumber.replace('\r', '') + ',' 
        + this.csvData[i].Id.replace('\r', '') + ',' 
            + this.csvData[i].IO_Status.replace('\r', '')+','
        + this.csvData[i].IO_Comment.replace('\r', '').replace(/,/g, ' ') + ','
        + this.csvData[i].Status.replace('\r', '') + ',' 
        + message + ','
        row +='\n'+ csvRow;
    }
    
    // Final CSV content
    const csvContent = row;
    
    
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    let downloadElement = document.createElement('a');

    downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvContent);
    downloadElement.target = '_self';
    downloadElement.download = 'result.csv';
    document.body.appendChild(downloadElement);
    downloadElement.click();
}




updateProgressInChild() {
     // Get the reference to the child component using 'this.template.querySelector'
        const progressBar = this.template.querySelector('c-progress-bar');

        // Call the updateProgress method of the child component
        if (progressBar) {
            progressBar.updateProgress(this.percentage);
        }

        if(this.percentage >=100){
            //this.isPause = true;
            if(Number(this.failedCase) > 0){
            this.isRefresh = false;
            this.isDownloadError = false;
            }
            // if(this.reRunCount < 2){
            //     this.isReRun = false;
            // }
            this.isResume = true;
        }
}


}