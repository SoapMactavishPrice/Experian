import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import uploadFile from '@salesforce/apex/uploadFilesOnAccount.uploadFile';

export default class UploadFilesOnAccount extends LightningElement {
	@api recordId;

	@track filesData = [];
	@track dumfile;
	@track sign = 'Authorized Signatory as per MCA – ID Proof';
	@track mdid = 'Domain Name – Confirmation';
	@track domain = 'Domain Name – Confirmation';
	@track msnap = 'MCA - Snapshot';
	@track name = 'Name Change – Confirmation';
	@track nodal_name = 'Nodal Officer – Name Change';
	@track nodal_Id = 'Nodal Officer – ID Proof';
	@track nodal_emp = 'dal Officer – Employment Proof';
	@track new_sId = 'New Authorized Signatory – ID Proof';
	@track new_emp_proof = 'New Authorized Signatory – Employment Proof';

	@track isUploading = false;

	@track fileNames1 = ' ';
	@track fileNames2 = ' ';
	@track fileNames3 = ' ';
	@track fileNames4 = ' ';
	@track fileNames5 = ' ';
	@track fileNames6 = ' ';
	@track fileNames7 = ' ';
	@track fileNames8 = ' ';
	@track fileNames9 = ' ';
	@track fileNames0 = ' ';

	@track fileNames01 = ' ';
	@track fileNames02 = ' ';
	@track fileNames03 = ' ';
	@track fileNames04 = ' ';



	get acceptedFormats() {
		return ['.xlsx', '.pdf', '.png', '.jpg', '.jpeg', '.csv'];
	}

	handleFileUploadedGST(event) {
		const file = event.target.files[0];
		this.fileNames04 = file.name;
		if (event.target.files.length > 0) {
			let reader = new FileReader();
			this.sign = 'GSTCertificate';

			console.log('GSTCertificate');
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': file.name,
					'fileName': this.sign,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}
	}


	handleFileUploadedPAN(event) {
		const file = event.target.files[0];
		this.fileNames03 = file.name;
		if (event.target.files.length > 0) {
			let reader = new FileReader();
			this.sign = 'PanCard';

			console.log('PanCard');
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': file.name,
					'fileName': this.sign,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}
	}

	handleFileUploadedRBI(event) {
		const file = event.target.files[0];
		this.fileNames02 = file.name;
		if (event.target.files.length > 0) {
			let reader = new FileReader();
			this.sign = 'RBICertificate';

			console.log('RBICertificate');
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': file.name,
					'fileName': this.sign,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}
	}

	handleFileUploadedCOI(event) {
		const file = event.target.files[0];
		this.fileNames01 = file.name;
		if (event.target.files.length > 0) {
			let reader = new FileReader();
			this.sign = 'CompanyCertificate';

			console.log('CompanyCertificate');
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': file.name,
					'fileName': this.sign,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}
	}

	handleFileUploaded(event) {
		const file = event.target.files[0];
		this.fileNames1 = file.name;
		if (event.target.files.length > 0) {
			let reader = new FileReader();
			this.sign = 'Authorized Signatory as per MCA – ID Proof';

			console.log('RBI Document');
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': file.name,
					'fileName': this.sign,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}
	}

	handleFile_bd_md_id_Proof(event) {
		const file = event.target.files[0];
		this.fileNames2 = file.name;
		if (event.target.files.length > 0) {
			console.log('BR / MD/ Company Secretary – ID Proof');
			let reader = new FileReader();
			this.mdid = 'BR / MD/ Company Secretary – ID Proof';
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': file.name,
					'fileName': this.mdid,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}

	}

	handleFile_Domain_Name_Confirm(event) {
		const file = event.target.files[0];
		this.fileNames3 = file.name;
		if (event.target.files.length > 0) {
			console.log('Domain Name – Confirmation');
			let reader = new FileReader();
			this.domain = 'Domain Name – Confirmation';
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': file.name,
					'fileName': this.domain,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}

	}

	handleFile_mca_snap(event) {
		const file = event.target.files[0];
		this.fileNames4 = file.name;
		if (event.target.files.length > 0) {
			console.log('MCA - Snapshot');
			let reader = new FileReader();
			this.msnap = 'MCA - Snapshot';
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': file.name,
					'fileName': this.msnap,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}

	}

	handleFile_name_Change_confirm(event) {
		const file = event.target.files[0];
		this.fileNames5 = file.name;
		if (event.target.files.length > 0) {
			console.log('Name Change – Confirmation');
			let reader = new FileReader();
			this.name = 'Name Change – Confirmation';
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': file.name,
					'fileName': this.name,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}

	}

	handleFile_nodal_nameChange(event) {
		const file = event.target.files[0];
		this.fileNames6 = file.name;
		if (event.target.files.length > 0) {
			console.log('Nodal Officer – Name Change');
			let reader = new FileReader();
			this.nodal_name = 'Nodal Officer – Name Change';
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': file.name,
					'fileName': this.nodal_name,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}

	}

	handleFile_Nodal_Id_proof(event) {
		const file = event.target.files[0];
		this.fileNames7 = file.name;
		if (event.target.files.length > 0) {
			console.log('Nodal Officer – ID Proof');
			let reader = new FileReader();
			this.nodal_Id = 'Nodal Officer – ID Proof';
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': file.name,
					'fileName': this.nodal_Id,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}
	}

	handleFile_emp_proof(event) {
		const file = event.target.files[0];
		this.fileNames8 = file.name;
		if (event.target.files.length > 0) {
			console.log('Nodal Officer – Employment Proof');
			let reader = new FileReader();
			this.nodal_emp = 'Nodal Officer – Employment Proof';
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': file.name,
					'fileName': this.nodal_emp,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}
	}

	handleFile_sign_id(event) {
		const file = event.target.files[0];
		this.fileNames9 = file.name;
		if (event.target.files.length > 0) {
			console.log('New Authorized Signatory – ID Proof');
			let reader = new FileReader();
			this.new_sId = 'New Authorized Signatory – ID Proof';
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': file.name,
					'fileName': this.new_sId,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}
	}

	handleFile_sign_emp_proof(event) {
		const file = event.target.files[0];
		this.fileNames0 = file.name;
		console.log('this.fileNames', this.fileNames);
		if (event.target.files.length > 0) {
			console.log('New Authorized Signatory – Employment Proof');
			let reader = new FileReader();
			this.new_emp_proof = 'New Authorized Signatory – Employment Proof';
			reader.onload = () => {
				this.dumfile = {
					'fileExtension': file.name,
					'fileName': this.new_emp_proof,
					'fileContent': reader.result
				}
				console.log('dummy data is', this.dumfile);
				this.filesData.push(this.dumfile);
			}
			reader.readAsDataURL(file);
		}
	}


	handleClick() {

		if (this.filesData.length == 0) {
			this.dispatchEvent(new ShowToastEvent({
				title: 'file upload',
				message: 'Select atleast one file.',
				variant: 'Error',
			}));
			return;
		}

		if (this.isUploading) {
			this.dispatchEvent(new ShowToastEvent({
				title: 'Warning',
				message: 'Please don\'t click upload button multiple times',
				variant: 'warn',
			}));
			return;
		}

		this.isUploading = true;
		this.showSpinner = true;

		uploadFile({
			fileData: JSON.stringify(this.filesData),
			recordId: this.recordId
		})
			.then(result => {
				if (result.length > 0) {
					const event = new ShowToastEvent({
						title: 'Success',
						message: 'Document Uploaded Successfully!!!',
						variant: 'success',
					});
					this.dispatchEvent(event);

					this.filesData = [];

					this.fileNames1 = ' ';
					this.fileNames2 = ' ';
					this.fileNames3 = ' ';
					this.fileNames4 = ' ';
					this.fileNames5 = ' ';
					this.fileNames6 = ' ';
					this.fileNames7 = ' ';
					this.fileNames8 = ' ';
					this.fileNames9 = ' ';
					this.fileNames0 = ' ';
					this.fileNames01 = ' ';
					this.fileNames02 = ' ';
					this.fileNames03 = ' ';
					this.fileNames04 = ' ';
				}

				this.showSpinner = false;
				this.isUploading = false;
			})
			.catch(e => {
				const event = new ShowToastEvent({
					title: 'Error',
					message: 'We got some error',
					variant: 'error',
				});
				this.dispatchEvent(event);
				this.isUploading = false;
			})

	}
}