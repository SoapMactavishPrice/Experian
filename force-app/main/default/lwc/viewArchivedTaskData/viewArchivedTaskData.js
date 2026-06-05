import { LightningElement, api, wire, track } from 'lwc';
import getArchivedTasks from '@salesforce/apex/ArchivedTasks.getArchivedTasks';

export default class ViewArchivedTasks extends LightningElement {
    @api recordId;
    @track tasks = [];
    @track isExpanded = true;
    @track error;

    @wire(getArchivedTasks, { caseId: '$recordId' })
    wiredTasks({ data, error }) {
        if (data) {
            this.tasks = data.map(task => ({
                ...task,
                timeAgo: this.getTimeAgo(task.CreatedDate)
            }));
        } else if (error) {
            this.error = error;
        }
    }

    toggleSection() {
        this.isExpanded = !this.isExpanded;
    }

    get iconName() {
        return this.isExpanded ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get hasTasks() {
        return this.tasks && this.tasks.length > 0;
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
}