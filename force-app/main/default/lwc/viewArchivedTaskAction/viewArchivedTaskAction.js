import { LightningElement, api, wire, track } from 'lwc';
import getArchivedTasks from '@salesforce/apex/ArchivedTasks.getArchivedTasks';

export default class ViewArchivedTasks extends LightningElement {
    @api recordId;
    @track tasks = [];
    @track isExpanded = true;
    @track error;
    @track noTasks = false;

    @track isOpen = false;

    get sectionClass() {
        return 'slds-section ' + (this.isOpen ? 'slds-is-open' : 'slds-is-collapsed');
    }

    // toggleSection(event) {
    //     const id = event.currentTarget.dataset.id;

    //     // Toggle isOpen and className on the clicked task item
    //     this.tasks = this.tasks.map(task => {
    //         if (task.id === id) {
    //             const newIsOpen = !task.isOpen;
    //             return {
    //                 ...task,
    //                 isOpen: newIsOpen,
    //                 className: newIsOpen ? 'slds-section slds-is-open' : 'slds-section slds-is-collapsed'
    //             };
    //         }
    //         return task;
    //     });
    // }

    @wire(getArchivedTasks, { caseId: '$recordId' })
    wiredTasks({ data, error }) {
        if (data) {
            const taskData = data.emails || [];

            this.tasks = taskData.map(rec => {
                const createdByName = rec.created_by_c__c;

                const createdDateValue =
                    rec.created_at__c;

                let formattedTime = '—';
                let formattedFull = '';
                if (createdDateValue) {
                    const eventDate = new Date(createdDateValue);
                    formattedTime = this.computeRelativeTime(eventDate);
                    formattedFull = this.formatExactDate(eventDate);
                }

                return {
                    Id: rec.Id,
                    Subject: rec.subject_c__c || rec.Subject,
                    Priority: rec.priority_c__c || rec.Priority,
                    Status: rec.status_c__c || rec.Status,
                    ActivityDate: rec.activitydate__c || rec.ActivityDate || '',
                    RelatedTo: rec.related_to_c__c || rec.Related_To__c || '',
                    CreatedByName: createdByName,
                    headerText: createdByName ? `${createdByName} Task created` : 'Task created',
                    timeAgo: formattedFull,
                    isExpanded: false,
                    iconName: 'utility:chevronright',
                };
            });

            this.noTasks = this.tasks.length === 0;
            console.log('tasks', this.tasks);
            console.log('tasks', this.tasks.length);
        } else if (error) {
            this.error = error;
        }
    }

    // toggleSection() {
    //     this.isExpanded = !this.isExpanded;
    // }

    get iconName() {
        return this.isExpanded ? 'utility:chevrondown' : 'utility:chevronright';
    }

    // get hasTasks() {
    //     return this.tasks && this.tasks.length > 0;
    // }

    get sectionClass() {
        return this.isExpanded ? 'slds-section slds-is-open' : 'slds-section';
    }

    handleToggle(event) {
        const taskId = event.currentTarget.dataset.id;

        this.tasks = this.tasks.map(task => {
            const isExpanded = task.Id === taskId ? !task.isExpanded : false;
            return {
                ...task,
                isExpanded,
                iconName: isExpanded ? 'utility:chevrondown' : 'utility:chevronright'
            };
        });

        // const selectedEmail = this.tasks.find(e => e.Id === taskId);
        // if (selectedEmail && selectedEmail.isExpanded) {
           
        // }
    }

    getTimeAgo(createdDate) {
        const created = new Date(createdDate);
        const now = new Date();
        const diffMs = now - created;
        const diffHours = Math.floor(diffMs / (1000 * 60 * 60));

        if (diffHours < 1) {
            const diffMinutes = Math.floor(diffMs / (1000 * 60));
            return diffMinutes <= 1 ? 'just now' : `${diffMinutes} min ago`;
        } else if (diffHours < 24) {
            return `${diffHours}h ago`;
        } else {
            const diffDays = Math.floor(diffHours / 24);
            return `${diffDays}d ago`;
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