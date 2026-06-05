import { LightningElement,track,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateaccount from '@salesforce/apex/UpdateAccountwithFiles.updateaccount';

export default class  extends LightningElement {
    @track showSpinner;
     @track openModel;
     @api recordId;
     @track filesData = [];
     @track accountName;
     get acceptedFormats() {
		return ['.xlsx', '.pdf', '.png', '.jpg', '.jpeg', '.csv'];
	}
    @track saveDisbled;
     connectedCallback(){
        this.openModel=false;
        this.saveDisbled = true;
     }

     updateAccount(){
        this.openModel=true;
        console.log('recordId'+this.recordId);
     }

     handleAccountName(event){
        if(event.target.value != null &&  event.target.value != ''){
            this.saveDisbled = false;
            this.accountName= event.target.value;
        }else{
            this.saveDisbled = true;
        }
     }

     handleFileUploaded(event){
     const file = event.target.files[0];
		//this.fileNames03 = file.name;
		if (event.target.files.length > 0) {
            this.saveDisbled = false;
			let reader = new FileReader();
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': 'Name Change',
					'fileName': this.sign,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}else{
            this.saveDisbled = true;
        }
    }
     closePdfPreviewModal(){
        this.openModel=false;
     }

     SaveAccount(event){
        let tempSend = true;
        this.showSpinner = true;
        if(this.filesData.length == 0){
            tempSend = false;
            const event = new ShowToastEvent({
                title: 'Warning',
                message: 'Plaese Select Name Change File!',
                variant: 'Warning',
            });
            this.dispatchEvent(event);
        }

        // if(this.accountName == null && this.accountName == ''){
        //     tempSend = false;
        //     const event = new ShowToastEvent({
        //         title: 'Warning',
        //         message: 'Plaese Fill Account Name!',
        //         variant: 'Warning',
        //     });
        //     this.dispatchEvent(event);
        // }


        // if(this.filesData.length == 0 && this.accountName == '' && this.accountName == null){
        //     tempSend = false;
        //     const event = new ShowToastEvent({
        //         title: 'Warning',
        //         message: 'Please fill Account Name && select Name Change file.!',
        //         variant: 'Warning',
        //     });
        //     this.dispatchEvent(event);
        // }

        if(tempSend){
            updateaccount({accountId:this.recordId,newName:this.accountName,fileData:JSON.stringify(this.filesData)})
            .then(result=>{
            console.log('result===>',JSON.parse(result));
            let data=JSON.parse(result);
            if(data.sucess){
                console.log('inside if');
                const event = new ShowToastEvent({
                    title: 'Success',
                    message: 'Account Updated!',
                    variant: 'success',
                });
                this.dispatchEvent(event);
            this.openModel = false;
            this.showSpinner = false;
            window.location.reload();
            
            
        }else{
            console.log('inside else');
            //this.showSpinner = false;
            const evt = new ShowToastEvent({
                title: 'error',
                message: data.error,
                variant: error,
            });
            this.dispatchEvent(evt);
        }
        })
    
    }
     }
}