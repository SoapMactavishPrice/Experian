import { LightningElement, track, api, wire } from 'lwc';
import getDoumnetData from '@salesforce/apex/VerifySupportingDocumnets.getDoumnetData';
import getDocumentUrl from '@salesforce/apex/VerifySupportingDocumnets.getDocumentUrl';
import saveStatus from '@salesforce/apex/VerifySupportingDocumnets.saveStatus';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';



import { NavigationMixin } from 'lightning/navigation';



export default class VerifySupportingDocumnets extends NavigationMixin(LightningElement) {
    @api recId;
    connectedCallback() {
        console.log('lead Id', this.recId);
        this.getDocs();
    }

    @track docList = [];
    getDocs() {
        getDoumnetData({ leadId: this.recId }).then(result => {
            //console.log('result-->', result);
            this.docList = JSON.parse(result);
        })


    }

    get options() {
        return [
            { label: 'Pending', value: 'Pending' },
            { label: 'Approved', value: 'Approved' },
            { label: 'Rejected', value: 'Rejected' },
            { label: 'Change Requested', value: 'Change Requested' },
        ];
    }


    handleChange(event) {
        console.log(event.target.value);
        this.supportId = event.target.dataset.id;
        let index = this.docList.map(a => a.Id).indexOf(this.supportId);
        this.docList[index].status = event.target.value;
        console.log(this.docList[index].Name + ' <--->' + this.docList[index].status);
    }

    @track viewImpDocModal = false;
    @track commonImpDocName = '';
    @track supportId;
    @track commonImpDocumentModal;
    showhandleDocChange(event) {
        this.commonImpDocumentModal = null;
        this.viewImpDocModal = true;
        this.supportId = event.target.dataset.id;
        this.commonImpDocName = event.target.dataset.name;
        getDocumentUrl({ Id: this.supportId }).then(result => {
            //console.log('result', result);
            let data = JSON.parse(result);
            this.commonImpDocumentModal = data.FileUrl;
            console.log('result', data.Base64Link );
        })
        console.log('data', this.commonImpDocName);
    }

    closeModal(event) {
        this.supportId = null;
        this.commonImpDocumentModal = null;
        this.viewImpDocModal = false;
    }


    handleApprove() {
        let index = this.docList.map(a => a.Id).indexOf(this.supportId);
        this.docList[index].status = 'Approved';
        console.log(this.docList[index].Name + ' <--->' + this.docList[index].status);
    }

    handleReject() {
        let index = this.docList.map(a => a.Id).indexOf(this.supportId);
        this.docList[index].status = 'Rejected';
        console.log(this.docList[index].Name + '>>>>>>. ' + this.docList[index].status);
    }

    handleChangeRequest() {
        let index = this.docList.map(a => a.Id).indexOf(this.supportId);
        this.docList[index].status = 'Change Requested';
        console.log(this.docList[index].Name + '-------' + this.docList[index].status);

    }


    cancel() {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: this.recId,
                objectApiName: 'Lead',
                actionName: "view"
            }
        });
    }

    saveDocuments() {
        console.log(JSON.stringify(this.docList));
        saveStatus({ js: JSON.stringify(this.docList) }).then(result => {
            console.log(result);
            if (result == 'success') {
                const event = new ShowToastEvent({
                    title: 'Success',
                    message: 'Updated Successfully ',
                    variant: 'success'
                });
                this.dispatchEvent(event);


                this[NavigationMixin.Navigate]({
                    type: "standard__recordPage",
                    attributes: {
                        recordId: this.recId,
                        objectApiName: 'Lead',
                        actionName: "view"
                    }
                });
            }
        })

    }

    previewHandler(event){ 
        let currentDocId = null;
        this.supportId = event.target.dataset.id;
        console.log(event.target);
        getDocumentUrl({ Id: this.supportId }).then(result => {
            //console.log('result', result);
            //let data = JSON.parse(result);
            //this.commonImpDocumentModal = data.FileUrl;
            //console.log('result', data.Base64Link );
            currentDocId = result;
            console.log('currentDocId',currentDocId);
    if(currentDocId != null && currentDocId !=undefined){
        let fileID = currentDocId;
        this[NavigationMixin.Navigate]({
            type:'standard__namedPage',
            attributes:{
                pageName:'filePreview'
            },
            state:{
                selectedRecordId: fileID
            }
        })  

    }
      
    })
    
   
    }

}