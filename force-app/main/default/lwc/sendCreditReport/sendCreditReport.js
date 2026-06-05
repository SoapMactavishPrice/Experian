import { LightningElement,track,wire,api } from 'lwc';
import seneCreditReport from '@salesforce/apex/IntegrationHandler.seneCreditReport';

export default class SendCreditReport extends LightningElement {
    @track showSpinner=false;
    @api recordId='';
    @track message=''
    connectedCallback(){
        
    }
    handleClick(){
        console.log('handleClick call ');
        console.log('this.recordId ',this.recordId);
        
        this.showSpinner=true;
        seneCreditReport({caseIdVar:this.recordId,Action:''})
        .then((result)=>{
            console.log(result);
            this.showSpinner=false;
            if(result){
                this.message='Report Generated Successfully';
            }else{
                this.message='Something went wrong!';
            }
            
        })
    }
    handleResendClick(){
        console.log('handleClick call ');
        console.log('this.recordId ',this.recordId);
        
        this.showSpinner=true;
        seneCreditReport({caseIdVar:this.recordId,Action:'Re-send'})
        .then((result)=>{
            console.log(result);
            this.showSpinner=false;
            if(result){
                this.message='Re-send Successfully';
            }else{
                this.message='Something went wrong!';
            }
            
        })
    }
}