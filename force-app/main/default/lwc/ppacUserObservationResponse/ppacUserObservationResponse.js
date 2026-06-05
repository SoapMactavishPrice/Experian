import { LightningElement }
from 'lwc';

import getObservationDetails
from '@salesforce/apex/PPACUserObservationController.getObservationDetails';

import submitResponse
from '@salesforce/apex/PPACUserObservationController.submitResponse';

export default class PpacUserObservationResponse
extends LightningElement {

    observationId;

    ppacId;
    ppacName;
    subCategory;
    submittedBy;

    observations = [];

    response = '';

    columns = [

        {
            label:'Observation',
            fieldName:'Observation__c'
        },
        {
            label:'Response',
            fieldName:'User_Comment__c'
        }
    ];

    async connectedCallback(){

        const url =
            new URL(
                window.location.href
            );

        this.observationId =
            url.searchParams.get('id');

        await this.loadData();
    }

    async loadData(){

        const data =
            await getObservationDetails({

                observationId:
                    this.observationId
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

    handleChange(event){

        this.response =
            event.target.value;
    }

    async handleSubmit(){

        await submitResponse({

            observationId:
                this.observationId,

            response:
                this.response
        });

        alert(
            'Response Submitted Successfully'
        );

        await this.loadData();
    }
}