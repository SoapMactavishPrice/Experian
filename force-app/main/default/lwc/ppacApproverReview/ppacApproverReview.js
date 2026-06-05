import { LightningElement, api, wire } from 'lwc';

import getReviewData from '@salesforce/apex/PPACObservationController.getReviewData';

import createObservation from '@salesforce/apex/PPACObservationController.createObservation';

import approvePPAC from '@salesforce/apex/PPACObservationController.approvePPAC';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PpacApproverReview extends LightningElement {

    @api assignmentId;

    ppacId;
    ppacName;
    subCategory;
    submittedBy;

    observations = [];

    observation = '';

    columns = [
        {
            label: 'Observation',
            fieldName: 'Observation__c'
        },
        {
            label: 'User Response',
            fieldName: 'User_Comment__c'
        }
    ];

    async connectedCallback() {

        const url =
            new URL(window.location.href);

        this.assignmentId =
            url.searchParams.get('id');

        console.log(
            'AssignmentId from URL =>',
            this.assignmentId
        );

        await this.loadData();
    }

    async loadData(){
        try{
            const data =
                await getReviewData({
                    assignmentId:
                        this.assignmentId
                });

            this.ppacId =
                data.ppacId;

            this.ppacName =
                data.ppacName;

            this.subCategory =
                data.subCategory;

            this.submittedBy =
                data.submittedBy;

            this.observations =
                data.observations;
        }
        catch(error){

            console.error(
                'Load Error',
                error
            );
        }
    }

    renderedCallback() {
        console.log('LWC assignmentId RenderedCallBack= ', this.assignmentId);
    }

    // @wire(getReviewData,{
    //     assignmentId:'$assignmentId'
    // })
    // wiredData({data,error}){

    //     if(data){

    //         this.ppacId = data.ppacId;
    //         this.ppacName = data.ppacName;
    //         this.subCategory = data.subCategory;
    //         this.submittedBy = data.submittedBy;

    //         this.observations = data.observations;
    //     }
    // }

    handleObservationChange(event){
        this.observation = event.target.value;
    }

    async handleRaiseObservation(){

        if(!this.observation){
            return;
        }

        await createObservation({
            assignmentId:this.assignmentId,
            observation:this.observation
        });

        this.showToast(
            'Success',
            'Observation submitted',
            'success'
        );
    }

    async handleApprove(){

        await approvePPAC({
            assignmentId:this.assignmentId
        });

        this.showToast(
            'Success',
            'PPAC Approved',
            'success'
        );
    }

    showToast(title,message,variant){

        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}