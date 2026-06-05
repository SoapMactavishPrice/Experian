import { LightningElement, track, api } from 'lwc';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import getCasesWithEmailMessage2 from '@salesforce/apex/GenerateDocumentforCaseController.getCasesWithEmailMessage2';
export default class GenerateDocumentforCase extends LightningElement {
    @track selectedCaseId;
    onMasterSelection(event) {
        this.selectedCaseId = event.target.selectedRecordId;
        this.getCasesData();
    }
    @track keyIndex = 0;
    @track caseList = [];
    @track EmailBodyList = [];
    @track checkCasesSize = true;
    @track CaseNumber = '';


    getCasesData() {
        this.caseList = [];
        if (this.selectedCaseId) {
            getCasesWithEmailMessage2({ caseId: this.selectedCaseId }).then(result => {
                let data = JSON.parse(result);
                let temp = {};
                this.CaseNumber = data.caseNumber;
                let childData = data.childList;
                this.EmailBodyList = data.childList;
                console.log(data);
                console.log('data.childList.length', data.childList.length);
                if (data.childList.length == 0) {
                    const event = new ShowToastEvent({
                        title: 'info',
                        message: ' Email Message not found',
                        variant: 'info',
                        mode: 'dismissable',
                    });
                    this.dispatchEvent(event);
                }
                else if (data.childList.length > 0) {

                    temp = {
                        tindex: this.keyIndex++,
                        Id: data.cId,
                        CaseNumber: data.caseNumber,
                        Subject: data.subject,
                        Category: data.Case_Category,
                        Status: data.Status,
                    }
                    this.caseList.unshift(temp);
                    //this.caseList = temp;
                    if (this.caseList.length > 0) {
                        this.checkCasesSize = false;
                    } else {
                        this.checkCasesSize = true;
                    }
                }


            });
        }
    }

    download_Document() {
        console.log('temp---> 12:::>>>>   ', this.EmailBodyList.length);
        let downloadElement = document.createElement('a');

        let url = '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">';
        url += '<style>.divcls{font-size:12px} table ,th,tr{font-size:12px}</style>';
        //style="page-break-inside: always;
        //url += '<style>@media print {.pagebreak { page-break-after: always; }}</style>';

        for (let i = 0; i < this.EmailBodyList.length; i++) {
            url += '<div class="divcls">';
            url += 'From: ' + this.EmailBodyList[i].fromName;
            url += 'Sent: ' + this.EmailBodyList[i].sendTime;
            url += 'To: ' + this.EmailBodyList[i].to;
            url += 'Subject: ' + this.EmailBodyList[i].subject;
            url += this.EmailBodyList[i].body;
            url += '-----------------------------------------------------------------------------------------------------------------------------------------------------';
            url += '</div>';

            if (i < Number(this.EmailBodyList.length) - 1) {
                url += '<pre><br clear=all style="mso-special-character:line-break;page-break-after:always"></pre>';
            }

        }



        url += '</meta>';
        //console.log('url', url);
        //url = windows.decode("windows-1252").encode("utf-8")
        downloadElement.href = 'data:application/vnd.ms-word.document.macroEnabled.12;charset=utf-8,' + encodeURIComponent(url);
        // Creating anchor element to download
        // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
        //downloadElement.href = 'data:text/doc;charset=utf-8,' + encodeURI(temp);
        downloadElement.target = '_self';
        // CSV File Name
        downloadElement.download = this.CaseNumber + '.doc';
        downloadElement.style = "display: none;";
        // below statement is required if you are using firefox browser
        document.body.appendChild(downloadElement);
        // click() Javascript function to download CSV file
        // Create a line break element
        //const lineBreak = document.createElement('br');

        // Append the line break element to the document body
        //document.body.appendChild(lineBreak);
        downloadElement.click();
    }

    handleaddRemoveCases(event) {
        console.log('event', event.target.dataset.id);

        if (this.caseList.length > 0) {
            this.caseList.splice(this.caseList.findIndex(row => row.Id == event.target.dataset.id), 1);
        }

    }

    handleCancel() {
        window.location.reload();
    }
}