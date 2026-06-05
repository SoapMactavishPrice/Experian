import { LightningElement, api, track } from 'lwc';
import getEmails from '@salesforce/apex/EmailMessageController.getEmails';
import getEmailDetail from '@salesforce/apex/EmailMessageController.getEmailDetail';

export default class CaseEmailMessages extends LightningElement {
  @api recordId; // Case Id

  pageSize = 50;
  page = 1;

  @track rows = [];
  @track displayRows = [];
  @track searchKey = '';
  @track activeSections = [];

  connectedCallback() {
    this.load();
  }

  async load() {
    console.log('recordId', this.recordId);
    debugger;
    const offset = (this.page - 1) * this.pageSize;
    const data = await getEmails({ parentId: this.recordId, limitSize: this.pageSize, offsetSize: offset });
    console.log(data);
    this.rows = (data || []).map(r => ({ ...r, detail: null }));
    this.applyFilter();
  }

  applyFilter() {
    const key = (this.searchKey || '').toLowerCase();
    const rows = key
      ? this.rows.filter(r =>
          (r.subject || '').toLowerCase().includes(key) ||
          (r.fromAddress || '').toLowerCase().includes(key) ||
          (r.toAddress || '').toLowerCase().includes(key)
        )
      : this.rows;

    this.displayRows = rows;
  }

  handleSearch(event) {
    this.searchKey = event.target.value;
    this.applyFilter();
  }

  async handleSectionToggle(event) {
    const openSections = event.detail.openSections || [];
    this.activeSections = openSections;

    const rowsNeedingDetail = openSections
      .map(id => this.rows.find(r => r.id === id))
      .filter(r => r && !r.detail);

    if (rowsNeedingDetail.length === 0) {
      return;
    }

    const details = await Promise.all(
      rowsNeedingDetail.map(r => getEmailDetail({ emailMessageId: r.id }))
    );

    rowsNeedingDetail.forEach((row, index) => {
      const idx = this.rows.findIndex(r => r.id === row.id);
      if (idx !== -1) {
        this.rows[idx] = { ...this.rows[idx], detail: details[index] };
      }
    });

    this.rows = [...this.rows];
    this.applyFilter();
  }

  // no-op helper removed; label is now custom slot markup in HTML

  prevPage() {
    if (this.page <= 1) return;
    this.page -= 1; this.load();
  }

  nextPage() {
    this.page += 1; this.load();
  }
}