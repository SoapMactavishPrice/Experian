import {
	LightningElement,
	api,
	track
} from 'lwc';
import {
	ShowToastEvent
} from 'lightning/platformShowToastEvent';
//import getAccount from '@salesforce/apex/SendEmailaccountwithCase.getAccount';
import getEmail from '@salesforce/apex/QuarterlyRemindertoBank.getEmail';
import ContactMobile from '@salesforce/schema/Case.ContactMobile';
import getCaseDetail from '@salesforce/apex/QuarterlyRemindertoBank.getCaseDetail';
import SendEmail from '@salesforce/apex/QuarterlyRemindertoBank.SendEmail';
import getAccount_server from '@salesforce/apex/QuarterlyRemindertoBank.getAccount_server';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { NavigationMixin } from 'lightning/navigation';
import checkNodalOfficerexistOrNot from '@salesforce/apex/QuarterlyRemindertoBank.checkNodalOfficerexistOrNot'

export default class QuarterlyRemindertoBankcmp extends LightningElement {


	@track caseList = [];
	@track accounts = [];
	@track accountAll;
	@track showSpinner;
	@track pageSizeOption = [10, 25, 50, 100, 200];
	@track selectedcaseList = [];

	@track currentAccountId;
	@track accId;
	@track selecedAccount = [];
	@track selectedCasesAndAccounts = {};
	@track allSelected;
	@track isAccount;

	@track isModalOpen;
	@track isChecked;

	@track isOpenModelSend;
	@track isCloseModelSend;

	@track currentvalues;
	//@track values = '';

	@track emailenter;
	@track email_subject;
	@track disablestd = true;

	@track res;
	@track tempaccId = '';
	selectlevel = [
		{
			label: 'Dispute Manager – Escalation Level 1',
			value: 'Dispute Manager – Escalation Level 1'
		},
		{
			label: 'Dispute Manager – Escalation Level 2',
			value: 'Dispute Manager – Escalation Level 2'
		},
		{
			label: 'Dispute Manager – Escalation Level 3',
			value: 'Dispute Manager – Escalation Level 3'
		},
		{
			label: 'Dispute Manager – Escalation Level 4',
			value: 'Dispute Manager – Escalation Level 4'
		}

	]

		;

	@track value;
	@track allValues = [];
	@track optionsMaster = [
		{
			label: 'Dispute Manager – Escalation Level 1',
			value: 'Dispute Manager – Escalation Level 1'
		},
		{
			label: 'Dispute Manager – Escalation Level 2',
			value: 'Dispute Manager – Escalation Level 2'
		},
		{
			label: 'Dispute Manager – Escalation Level 3',
			value: 'Dispute Manager – Escalation Level 3'
		},
		{
			label: 'Dispute Manager – Escalation Level 4',
			value: 'Dispute Manager – Escalation Level 4'
		}

	];

	handleChange2(event) {
		this.value = event.target.value;
		if (!this.allValues.includes(event.target.value))
			this.allValues.push(event.target.value);

		this.handleTypeChange();
		this.modifyOptions();
	}

	handleRemove(event) {
		this.value = '';
		const valueRemoved = event.target.name;
		this.allValues.splice(this.allValues.indexOf(event.target.name), 1);
		this.handleTypeChange();
		this.modifyOptions();
	}

	modifyOptions() {
		this.selectlevel = this.optionsMaster.filter(elem => {
			if (!this.allValues.includes(elem.value))
				return elem;
			else
				return elem;

		})
	}

	@track toAddressList = [];

	@track toCcAddress;
	handleTypeChange() {
		console.log('tranfer Id ', this.tempaccId);
		getEmail({
			escalationlevel: JSON.stringify(this.allValues),
			accId: this.tempaccId
		}).then((data) => {
			let result = JSON.parse(data);
			///console.log('result.email', result.email);
			//this.toCcAddress = result.email;

			if (result.email !== undefined) {

				if (this.To_Address == '' && this.value == 'Dispute Manager – Escalation Level 1') {
					this.To_Address = [result.email].map(arr => `${String(arr)}`).join(",");
					this.toAddressList = result.email;

				} else {
					let tempresult = [];
					result.email.forEach(ele => {
						if (this.To_Address.includes(ele)) {

						} else {
							tempresult.push(ele)
						}
					})

					this.res = tempresult.map(arr => `${String(arr)}`).join(",");
					this.toCcAddress = result.email;

				}

			}
			if (result.email === undefined) {
				this.res = '';
			}
		})

	}
	get options() {
		return [{
			label: 10,
			value: 10
		},
		{
			label: 25,
			value: 25
		},
		{
			label: 50,
			value: 50
		},
		{
			label: 100,
			value: 100
		},
		{
			label: 200,
			value: 200
		}
		];
	}

	connectedCallback(event) {
		//this.getAccounts();
		this.getAccount_server();
	}

	handleChangeEmail(event) {
		this.emailenter = event.detail.value;

	}

	handleChangeEmail_subject(event) {
		this.email_subject = event.detail.value;
	}

	// getAccounts() {
	// 	this.showSpinner = true;
	// 	getAccount()
	// 		.then((data) => {
	// 			let result = JSON.parse(data);
	// 			if (result['result'] == 'success') {
	// 				// this.accounts = result['data'];
	// 				let data = result['data'];
	// 				let tempData = [];
	// 				for (let i = 0; i < data.length; i++) {
	// 					let item = {};
	// 					item.rownum = "" + (i + 1);
	// 					item = Object.assign(item, data[i]);
	// 					tempData.push(item);
	// 					console.log('Account Is', tempData);
	// 				}

	// 				this.accountAll = tempData;
	// 			}
	// 			this.showSpinner = false;
	// 		})

	// }


	selectAllacount(event) {
		for (let i = 0; i < this.accounts.length; i++) {
			let index = this.accountAll.map(a => a.resId).indexOf(this.accounts[i].resId);
			console.log(i, 'index', index);
			if (index != -1) {
				let temp = this.accountAll[index];
				temp.isSelected = event.target.checked;
				this.accounts[i] = temp;
				this.accountAll[index].isSelected = event.target.checked;
			}
		}
	}

	checkSelectAllOrNot() {
		let temp = true;
		for (let i = 0; i < this.accounts.length; i++) {
			if (this.accounts[i].isSelected == false) {
				temp = false;
				break;
			}
		}
		console.log('selectAllCheckedOrNot', temp);

		let selectAllaccount = this.template.querySelector('.selectAllaccount');
		if (selectAllaccount)
			selectAllaccount.checked = temp;
	}

	selectall(event) {
		let temp = 0;
		for (let i = 0; i < this.caseList.length; i++) {
			let index = this.caseList.map(a => a.csId).indexOf(this.caseList[i].csId);
			if (index != -1) {
				let temp = this.caseList[index];
				temp.isSelected = event.target.checked;
				this.caseList[i] = temp;
			}

			if (this.caseList[i].isSelected) {
				temp++;
			} else if (!this.caseList[i].isSelected) {
				temp = 0;
			}


		}
		this.TotalCases = temp;
	}

	checkSelectAllOrNotCase() {
		let temp = true;
		for (let i = 0; i < this.caseList.length; i++) {
			if (this.caseList[i].isSelected == false) {
				temp = false;
				break;
			}
		}
		console.log('selectAllCheckedOrNot', temp);

		let selectAllcases = this.template.querySelector('.selectAllcases');
		if (selectAllcases)
			selectAllcases.checked = temp;
	}

	handlePaginatorChange(event) {
		console.log('handlePaginatorChange entry', event.detail);
		this.accounts = JSON.parse(JSON.stringify(event.detail));
		this.rowNumberOffset = this.accounts[0].rowNumber - 1;
		this.checkSelectAllOrNot();
		console.log('handlePaginatorChange exit', event.detail);
	}

	handlerowselected(event) {
		let index = this.caseList.map(a => a.csId).indexOf(event.target.dataset.id);
		this.caseList[index].isSelected = event.target.checked;

		if (this.caseList[index].isSelected) {
			this.TotalCases++;
		} else if (!this.caseList[index].isSelected) {
			this.TotalCases--;
		}

		this.checkSelectAllOrNot();
		this.checkSelectAllOrNotCase();
	}

	viewCase(event) {
		this.allValues = [];
		this.value = '';
		this.disablestd = true;
		this.res = '';
		this.currentAccountId = event.target.dataset.id;
		this.tempaccId = this.currentAccountId;
		//this.currentAccountId = event.target.dataset.id;
		this.caseList = [];
		let index = this.accountAll.map(a => a.resId).indexOf(this.currentAccountId);
		this.caseList = this.accountAll[index].cases;
		this.isModalOpen = true;

	}

	IsclosedModel(event) {
		this.allValues = [];
		this.isModalOpen = false;
		this.TotalCases = 0;
		this.from_dte = null;
		this.to_dte = null;
		this.displayTable = false;
		//this.CheckContactExistOrNot = false;
	}

	addselecedCase(event) {
		console.log('method call');
		let index = this.accountAll.map(i => i.resId).indexOf(this.currentAccountId);
		let index2 = this.accounts.map(i => i.resId).indexOf(this.currentAccountId);

		this.accountAll[index].isSelected = false;
		this.accounts[index2].isSelected = false;
		this.caseList.forEach((element) => {
			if (element.isSelected) {
				this.accountAll[index].isSelected = true;
				this.accounts[index2].isSelected = true;
				return;
			}
		});

		this.isModalOpen = false;
	}

	handleSelectAccount(event) {
		this.accountAll.forEach((item, index) => {
			if (item.resId == event.currentTarget.dataset.id) {
				item.isSelected = event.detail.checked;
			}
		});
		this.accounts.forEach((item, index) => {
			if (item.resId == event.currentTarget.dataset.id) {
				item.isSelected = event.detail.checked;
			}
		});

		this.checkSelectAllOrNot();
	}


	TosendEmail(event) {
		let data;
		//this.addselecedCase();
		var x = new Array();
		//= a.split(",");
		console.log('event' + event.target.value);
		console.log('if Send Email', this.res);
		if (this.res != null) {

			this.x = this.res.split(",");
		} else if (this.res == null) {
			this.x = [];
			console.log('else Send Email');
		}


		this.showSpinner = true;
		this.selectedCasesAndAccounts = {};

		this.caseList.forEach(cs => {
			if (cs.isSelected) {
				if (this.selectedCasesAndAccounts[this.tempaccId] != null ||
					this.selectedCasesAndAccounts[this.tempaccId] != undefined) {
					this.selectedCasesAndAccounts[this.tempaccId].push(cs.csId);
				} else {
					this.selectedCasesAndAccounts[this.tempaccId] = [cs.csId];

				}
			}
		})

		console.log('send Called', JSON.stringify(this.selectedCasesAndAccounts));

		if (JSON.stringify(this.selectedCasesAndAccounts) === '{}') {
			console.log('Jeson', this.selectedCasesAndAccounts);
			const event = new ShowToastEvent({
				title: 'Error',
				message: ' Select Atleast one record',
				variant: 'error'
			});
			this.dispatchEvent(event);
			this.showSpinner = false;
		} else {

			console.log('send Method call');
			SendEmail({
				data: (JSON.stringify(this.selectedCasesAndAccounts)),
				toEmail: this.To_Address,
				emails: this.toCcAddress
			})
				.then(out => {
					console.log('out', JSON.parse(out));
					data = JSON.parse(out);
					if (data.msg == 'success') {
						const event = new ShowToastEvent({
							title: 'Success',
							message: 'Email Send Successfully!!!',
							variant: 'success',
						});
						this.dispatchEvent(event);
						this.selectedCasesAndAccounts = {};


						for (let i = 0; i < this.accounts.length; i++) {
							this.accounts[i].isSelected = false;
						}
						console.log('Jeson', this.selectedCasesAndAccounts);

						window.location.reload();
					} else if (data.msg != 'success') {
						const event = new ShowToastEvent({
							title: 'Error',
							message: data.msg,
							variant: 'error',
						});
						this.dispatchEvent(event);
						this.showSpinner = false;
						console.log('error',);
					}
					this.showSpinner = false;

				})
				.catch(error => {

				});

		}

	}

	refreshTable(event) {
		window.location.reload();
		/*this.isAccount = false
		for(var i  = 0 ; i< this.accounts.length;i++){
			this.accounts[i].isSelected = false;
			this.allSelected = false;
		}*/
	}



	@track PaginationData = [];
	@track pageNo = 1;
	@track totalPages = 0;
	@track totalRecords = 0;
	@track error;
	@track start;
	@track colSrNoOffset;
	@track end;
	@track zeroRecords;
	@track isPrevAvailable = false;
	@track isNextAvailable = false;
	@track timeOut = null;
	@track isFirstPage = true;
	@api offset = 0;
	@api noOfRecordsOnPage = 10;
	@api searchKeyword = '';


	get options() {
		return [
			{ label: 10, value: 10 },
			{ label: 20, value: 20 },
			{ label: 30, value: 30 }

		];
	}



	setPageNumbers() {

		if (this.PaginationData.length == 0) {
			this.start = 0;
			this.end = 0;
			this.pageNo = 0;
			this.isPrevAvailable = true;
			this.isNextAvailable = true;
			this.zeroRecords = true;
			return;
		}
		this.zeroRecords = false;

		this.pageNo = Math.floor(this.offset / this.noOfRecordsOnPage) + 1;
		this.start = this.offset + 1;
		this.end = this.offset + this.PaginationData.length;

		if (this.pageNo == 1) {
			this.isPrevAvailable = true;
		} else {
			this.isPrevAvailable = false;
		}
		if (this.pageNo == this.totalPages) {
			this.isNextAvailable = true;
		} else {
			this.isNextAvailable = false;
		}
		if (this.totalPages == 1) {
			this.isPrevAvailable = true;
			this.isNextAvailable = true;
			if (this.offset > 0) {
				this.isPrevAvailable = false;
			}
		}
		this.colSrNoOffset = this.start - 1;

	}


	handleComboBoxChange(event) {
		this.showSpinner = true;

		//this.getSelectedOpps();

		this.offset = 0;
		this.noOfRecordsOnPage = parseInt(event.detail.value);
		this.getAccount_server();
	}


	handleSearch(event) {
		//const isEnterKey = event.keyCode === 13;
		//if (isEnterKey) {
		//this.getSelectedOpps();

		this.searchKeyword = event.target.value;
		this.offset = 0;

		//this.opportunities = null;
		this.getAccount_server();
		//}
	}

	getAccount_server() {
		this.showSpinner = true;
		this.showSpinner = true;
		getAccount_server({
			ofst: this.offset,
			lmt: this.noOfRecordsOnPage,
			searchKeyword: this.searchKeyword
		}).then(data => {
			if (data) {
				let dataFromApex = JSON.parse(data);
				this.PaginationData = dataFromApex[0];

				this.totalRecords = dataFromApex[1];
				console.log('data-->', this.totalRecords);
				this.totalPages = Math.ceil(dataFromApex[1] / this.noOfRecordsOnPage);
				this.showSpinner = false;
				this.setPageNumbers();
			} else {
				this.pageSizeOption = null;
				this.showSpinner = false;
			}
		})
	}


	handlePrevClick() {
		// this.getSelectedOpps();

		this.offset = this.offset - this.noOfRecordsOnPage;
		if (this.offset < 0) {
			this.offset = 0;
		}
		this.PaginationData = null;
		this.getAccount_server();
	}

	handleNextClick() {
		//this.getSelectedOpps();

		this.offset = this.offset + this.noOfRecordsOnPage;
		this.PaginationData = null;
		this.getAccount_server();
	}

	@track TotalCases = 0;
	@track To_Address;

	viewCase_ser(event) {
		let bool = false;
		let accName = event.target.dataset.accName;
		let tempAccId = event.target.dataset.id;
		this.from_dte = null;
		this.to_dte = null;
		this.displayTable = false;
		checkNodalOfficerexistOrNot({ accId: event.target.dataset.id }).then(result => {
			let data = result;
			this.To_Address = data.Email;
			console.log('this.To_Address', this.To_Address);
			if (data.Tempchk) {
				this.viewCase_sers(tempAccId);
			} else if (!data.Tempchk) {
				const event = new ShowToastEvent({
					title: 'info',
					message: 'Nodal Officer does not exist for ' + accName + ' this Account',
					variant: 'info'
				});
				this.dispatchEvent(event);
				this.viewCase_sers(tempAccId);
			}
		})

	}
	handle_fromDate(event) {
		console.log(event.target.value);
		this.from_dte = event.target.value;
		this.CheckDatefilter();
	}

	handle_toDate(event) {
		console.log(event.target.value);
		this.to_dte = event.target.value;
		this.CheckDatefilter();
	}

	@track displayTable = false;
	@track showSpinner2 = false;
	CheckDatefilter() {

		if (this.from_dte != null && this.from_dte != '' && this.to_dte != null && this.to_dte != '') {
			this.showSpinner2 = true;
			getCaseDetail({ accId: this.tempaccId, fromDate: this.from_dte, toDate: this.to_dte }).then(result => {
				this.caseList = JSON.parse(result);
				this.TotalCases = this.caseList.length;
				//this.allValues = [];
				//this.value = '';
				this.showSpinner2 = false;

				if (this.caseList.length > 0) {
					this.displayTable = true;
					this.disablestd = false
				} else {
					this.displayTable = false;
				}
			})
		} else if (this.from_dte == null || this.to_dte == null) {
			this.displayTable = false;
			this.disablestd = true;
			this.TotalCases = 0;
		}
	}


	viewCase_sers(acId) {
		this.caseList = [];
		this.res = null;
		this.tempaccId = acId;
		this.isModalOpen = true;
	}

}