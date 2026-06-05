import { LightningElement, api, track, wire } from 'lwc';
import getArchivedRecords from '@salesforce/apex/ArchivedActivity.getArchivedRecords';

export default class ArchivedEmails extends LightningElement {
    @api recordId;
    @track emails = [];
    @track noEmails = false;

    @wire(getArchivedRecords, { caseId: '$recordId' })
    wiredEmails({ data, error }) {
        if (data) {
            const emailData = data.emails || [];

            this.emails = emailData.map(email => {
                const createdDateValue =
                    email.CreatedDate || email.createddate__c || email.Created_Date__c;

                let formattedTime = '—';
                let formattedFull = '';
                if (createdDateValue) {
                    const eventDate = new Date(createdDateValue);
                    formattedTime = this.computeRelativeTime(eventDate);
                    formattedFull = this.formatExactDate(eventDate);
                }

                return {
                    ...email,
                    isExpanded: false,
                    iconName: 'utility:chevronright',
                    formattedTime,
                    formattedFull
                };
            });

            this.noEmails = this.emails.length === 0;
        } else if (error) {
            console.error('Error fetching archived emails:', error);
        }
    }

    handleToggle(event) {
        const emailId = event.currentTarget.dataset.id;

        this.emails = this.emails.map(email => {
            const isExpanded = email.Id === emailId ? !email.isExpanded : false;
            return {
                ...email,
                isExpanded,
                iconName: isExpanded ? 'utility:chevrondown' : 'utility:chevronright'
            };
        });

        const selectedEmail = this.emails.find(e => e.Id === emailId);
        if (selectedEmail && selectedEmail.isExpanded) {
            requestAnimationFrame(() => {
                const bodyContainer = this.template.querySelector(`[data-emailid="${emailId}"]`);
                if (bodyContainer) {
                    bodyContainer.innerHTML = selectedEmail.html_body_c__c || selectedEmail.text_body_c__c||'<i>No content</i>';
                }
            });
        }
    }

    computeRelativeTime(dateObj) {
        const now = new Date();
        const diffMs = now - dateObj;

        const minute = 60 * 1000;
        const hour = 60 * minute;
        const day = 24 * hour;

        if (diffMs < 30 * 1000) {
            return 'Just now';
        }
        if (diffMs < minute) {
            const secs = Math.floor(diffMs / 1000);
            return `${secs}s ago`;
        }
        if (diffMs < hour) {
            const mins = Math.floor(diffMs / minute);
            return `${mins}m ago`;
        }
        if (diffMs < day) {
            const hrs = Math.floor(diffMs / hour);
            return `${hrs}h ago`;
        }

       
        const yesterday = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 1);
        if (
            dateObj.getFullYear() === yesterday.getFullYear() &&
            dateObj.getMonth() === yesterday.getMonth() &&
            dateObj.getDate() === yesterday.getDate()
        ) {
            return 'Yesterday';
        }

        
        return this.formatExactDate(dateObj);
    }

    formatExactDate(dateObj) {
        
        const datePart = new Intl.DateTimeFormat(undefined, {
            day: 'numeric',
            month: 'long',
            year: 'numeric'
        }).format(dateObj);

        const timePart = new Intl.DateTimeFormat(undefined, {
            hour: 'numeric',
            minute: '2-digit',
            hour12: true
        })
            .format(dateObj)
            .toLowerCase();

        return `${datePart} at ${timePart}`;
    }
}