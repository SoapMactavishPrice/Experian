import { LightningElement, track, api, wire } from 'lwc';
import expe_Logo from '@salesforce/resourceUrl/Grievence_Exp_logo';
import { NavigationMixin } from "lightning/navigation";
import getContactsGroupedByRole from '@salesforce/apex/GrievancesNodalOfficersPortal.getContactsGroupedByRole';
import insertContacts from '@salesforce/apex/GrievancesNodalOfficersPortal.insertContacts';
import getAccountName from '@salesforce/apex/GrievancesNodalOfficersPortal.getAccountName';


import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GrevienceLWCCmp extends NavigationMixin(LightningElement) {
  expe_Logo = expe_Logo;
  //@api recordId = '001Bi00000CgqD0IAJ';
  @api recordId;
  @track customerName = '';
  @track showSpinner = false;

  @track conRoleList = [
    'Data Submission Primary', 'Data Submission Secondary',
    'DQR Primary', 'DQR Secondary', 'DQI Primary', 'DQI Secondary',
    'Form C Primary', 'Form C Secondary', 'Chief Data Officer (CDO)',
    'OLM Primary', 'OLM Secondary', 'Dispute Resolution Officer Primary', 'Dispute Resolution Officer Secondary',
    'Data Correction Head', 'Grievance Nodal Officer (GNO)',
    'Grievance Principal Nodal Officer (GPNO)',
    'Regulatory and Compliance Primary', 'Regulatory and Compliance Secondary',
    'Chief Compliance Officer (CCO)', 'Billing Primary', 'Billing Secondary',
    'Chief Financial Officer (CFO)', 'Business / Sales Team Primary',
    'Business / Sales Team Secondary', 'Chief Business Officer (CBO)',
    'Chief Revenue Officer (CRO)',
    'Technology Team Primary',
    'Technology Team Secondary', 'Chief Technology Officer (CTO)',
    'Authorized Signatory', 'Nodal Officer (NO)', 'Principal Nodal Officer (PNO)',
    'Chief Operating Officer (COO)', 'Chief Executive Officer (CEO)'
  ];

  @track options = [];
  connectedCallback() {

    console.log('-V1-12 sep->', this.recordId + ' in 0000000');

    this.options = this.conRoleList?.map(item => ({
      label: item
        .replace(/[\/]/g, '')           // remove slashes /
        .replace(/[)]/g, '')
        .replace(/[(]/g, '')           // remove parentheses ()
        .replace(/,/g, '')              // remove commas if any (optional)
        .replace(/\s+/g, '_'),          // replace spaces with underscores
      value: item
    }));
    console.log('corrected va-->', JSON.stringify(this.options));

    setTimeout(() => {
      this.getContactsGroupedByRoles();
      this.getCustomerName();
    }, 1000);

  }

  getCustomerName() {
    getAccountName({ accId: this.recordId }).then(result => {
      this.customerName = result;
    }
    )
  }






  getContactsGroupedByRoles() {
    console.log('--> GET METHOD CALL', this.recordId);

    getContactsGroupedByRole({ accId: this.recordId })
      .then(result => {
        const parsedResult = JSON.parse(result);
        console.log('Raw result -->', parsedResult);

        if (parsedResult && typeof parsedResult === 'object' && Object.keys(parsedResult).length > 0) {
          this.options.forEach(opt => {
            const matchingData = parsedResult[opt.value]; // e.g., 'Data Submission Primary'

            const specialRoles = [
              'Data Submission Primary',
              'Data Submission Secondary',
              'OLM Primary',
              'OLM Secondary'
            ];

            if (matchingData && Array.isArray(matchingData)) {
              const newRows = matchingData.map((contact, i) => {
                const row = {
                  index: this.generateUniqueCode(),
                  srNo: i + 1,
                  Name: contact.Name || '',
                  Id: contact.Id || '',
                  Email: contact.Email || '',
                  userRole: opt.value,
                  Phone: contact.Phone || '',
                  Designation: contact.Title || '',
                  IP_Address: [{ index: this.generateUniqueCode(), fromIp: '', fromToIp: '' }],
                  isIPAddes: false,
                };

                // Add IP_Address and isIPAddes if role matches
                if (specialRoles.includes(opt.value)) {
                  row.isIPAddes = true;
                }

                return row;
              });

              this[opt.label] = [...(this[opt.label] || []), ...newRows];
            } else {
              this.addRow_RowOneTime(opt.label, opt.value, []); // No data
            }
          });

        } else {
          this.options.forEach(opt => {
            this.addRow_RowOneTime(opt.label, opt.value, []); // No data
          });
        }
      })
      .catch(error => {
        console.error('🚨 Error in getContactsGroupedByRoles:', error);
      });
  }





  @track Data_Submission_Primary = [];
  @track Data_Submission_Secondary = [];
  @track DQR_Primary = [];
  @track DQR_Secondary = [];
  @track DQI_Primary = [];
  @track DQI_Secondary = [];
  @track Form_C_Primary = [];
  @track Form_C_Secondary = [];
  @track Chief_Data_Officer_CDO = [];
  @track OLM_Primary = [];
  @track OLM_Secondary = [];
  @track Dispute_Resolution_Officer_Primary = [];
  @track Dispute_Resolution_Officer_Secondary = [];
  @track Data_Correction_Head = [];
  @track Grievance_Nodal_Officer_GNO = [];
  @track Grievance_Principal_Nodal_Officer_GPNO = [];
  @track Regulatory_and_Compliance_Primary = [];
  @track Regulatory_and_Compliance_Secondary = [];
  @track Chief_Compliance_Officer_CCO = [];
  @track Billing_Primary = [];
  @track Billing_Secondary = [];
  @track Chief_Financial_Officer_CFO = [];
  @track Business_Sales_Team_Primary = [];
  @track Business_Sales_Team_Secondary = [];
  @track Chief_Business_Officer_CBO = [];
  @track Chief_Revenue_Officer_CRO = [];
  @track Technology_Team_Primary = [];
  @track Technology_Team_Secondary = [];
  @track Chief_Technology_Officer_CTO = [];
  @track Authorized_Signatory = [];
  @track Nodal_Officer_NO = [];
  @track Principal_Nodal_Officer_PNO = [];
  @track Chief_Operating_Officer_COO = [];
  @track Chief_Executive_Officer_CEO = [];

  @track hasSignle = false;
  addRow_RowOneTime(varLabel, userRole) {
    const specialRoles = [
      'Data Submission Primary',
      'Data Submission Secondary',
      'OLM Primary',
      'OLM Secondary'
    ];

    const newRow = {
      index: this.generateUniqueCode(),  // your function that returns unique 4-digit code
      Name: '',
      Id: '',
      srNo: 1,
      Email: '',
      userRole: userRole,
      Phone: '',
      Designation: '',
      IP_Address: [{ index: this.generateUniqueCode(), fromIp: '', fromToIp: '' }],
      isIPAddes: false
    };


    // Add IP_Address and isIPAddes if it's a special role
    if (specialRoles.includes(userRole)) {
      newRow.isIPAddes = true;
    }

    if (this[varLabel]) {
      this[varLabel] = [...this[varLabel], newRow];
      console.log('varLabel -->', varLabel, '-->', JSON.stringify(this[varLabel]));
    } else {
      console.warn(`Variable ${varLabel} not found!`);
    }
  }


  @track roleArrays = [
    'Data_Submission_Primary', 'Data_Submission_Secondary',
    'DQR_Primary', 'DQR_Secondary', 'DQI_Primary', 'DQI_Secondary',
    'Form_C_Primary', 'Form_C_Secondary', 'Chief_Data_Officer_CDO',
    'OLM_Primary', 'OLM_Secondary', 'Dispute_Resolution_Officer', 'Dispute_Resolution_Officer_Secondary', 'Dispute_Resolution_Officer_Primary',
    'Data_Correction_Head', 'Grievance_Nodal_Officer_GNO',
    'Grievance_Principal_Nodal_Officer_GPNO', 'Regulatory_and_Compliance_Primary',
    'Regulatory_and_Compliance_Secondary', 'Chief_Compliance_Officer_CCO',
    'Billing_Primary', 'Billing_Secondary', 'Chief_Financial_Officer_CFO',
    'Business_Sales_Team_Primary', 'Business_Sales_Team_Secondary',
    'Chief_Business_Officer_CBO',
    'Chief_Revenue_Officer_CRO',
    'Technology_Team_Primary', 'Technology_Team_Secondary',
    'Chief_Technology_Officer_CTO', 'Authorized_Signatory',
    'Nodal_Officer_NO', 'Principal_Nodal_Officer_PNO',
    'Chief_Operating_Officer_COO', 'Chief_Executive_Officer_CEO'
  ];

  handleSave() {
    let recordsToInsert = [];
    let hasError = false;

    this.roleArrays.forEach(role => {
      if (this[role] && Array.isArray(this[role])) {
        this[role].forEach(row => {
          const hasName = row.Name && row.Name.trim() !== '';
          const hasEmail = row.Email && row.Email.trim() !== '';

          if (hasName || hasEmail) {
            if (!hasName || !hasEmail) {
              hasError = true;
              this.messageColor = 'color:red';
              this.showErrorToast1(`Both Name and Email are required for ${row.userRole}`);
            } else {
              recordsToInsert.push({
                Id: row.Id,
                index: row.index,
                Name: row.Name,
                Email: row.Email,
                Phone: row.Phone,
                Title: row.Designation,
                UserRole: row.userRole,
                IP_Address: row.IP_Address
              });
            }
          }
        });
      }
    });

    if (hasError) {
      return;
    }
    this.messageColor = '';
    console.log('recordsToInsert-->', this.recordId, JSON.stringify(recordsToInsert));
    if (recordsToInsert.length > 0) {
      this.showSpinner = true;
      insertContacts({ accId: this.recordId, JS: JSON.stringify(recordsToInsert) })
        .then((result) => {
          this.showSpinner = false;
          console.log(result);
          this.messageColor = 'color:green';
          this.showErrorToast1(result);
          if (result = 'Contacts and related IPs inserted/updated successfully') {
            setTimeout(() => {
              window.location.reload();
              //this.getContactsGroupedByRoles();
            }, 100);
          }
        })
        .catch(error => {
          this.messageColor = 'color:red';
          this.showErrorToast1('Failed to insert contacts');
        });
    } else {
      this.messageColor = 'color:red';
      this.showErrorToast1('Please add atleast one contact');
    }
  }


  @track messageColor = '';
  @track showToast1 = false;
  @track toastMessage1 = '';

  showErrorToast1(message) {
    this.toastMessage1 = message;
    this.showToast1 = true;

    setTimeout(() => {
      this.showToast1 = false;
    }, 3000);
  }

  closeToast1() {
    this.toastMessage1 = '';
    this.showToast1 = false;
  }


  @track showToast2 = false;
  @track toastMessage2 = '';

  showErrorToast2(message) {
    this.toastMessage2 = message;
    this.showToast2 = true;

    setTimeout(() => {
      this.showToast2 = false;
    }, 3000);
  }

  closeToast2() {
    this.toastMessage2 = '';
    this.showToast2 = false;
  }




  @track showToast = false;
  @track toastMessage = '';

  showErrorToast(message) {
    this.toastMessage = message;
    this.showToast = true;

    setTimeout(() => {
      this.showToast = false;
    }, 3000);
  }

  closeToast() {
    this.toastMessage = '';
    this.showToast = false;
  }

  @track isModalOpen = false;


  @track currentIpList = [];
  @track currentIpvarLabel = '';
  @track parnetIndex = '';
  @track ipTypes = [{ label: 'Single', value: 'Single' }, { label: 'Multiple', value: 'Multiple' }, { label: 'Range', value: 'Range' }]
  addRow_IpRange(event) {
    this.isModalOpen = true;

    let varLabel = event.target.dataset.label;
    let userRole = event.target.dataset.userRole;
    this.currentIpvarLabel = event.target.dataset.label;
    let uniqueIndex = event.target.dataset.index;
    this.parnetIndex = event.target.dataset.index;
    let arrayIndex = this[varLabel].findIndex(row => row.index === uniqueIndex);
    this.currentIpList = this[varLabel][arrayIndex].IP_Address;

    if (this.currentIpList.length > 1) {
      const hasRangeEntry = this.currentIpList.some(ip => ip.fromToIp && ip.fromToIp.trim() !== '');

      if (hasRangeEntry) {
        this.isSignle = true;
        this.isRange = true;
        this.selectedType = 'Range';
      } else {
        this.isSignle = true;
        this.isRange = false;
        this.selectedType = 'Multiple'; // default to Multiple if no range entries
      }

    }
  }

  handleIPChange(event) {
    const recordId = event.target.dataset.id;
    const fieldName = event.currentTarget.name;
    const varLabel = event.target.dataset.label;
    const newValue = event.target.value;
    console.log(newValue, recordId, fieldName, varLabel);
    let index = this.currentIpList.findIndex(a => a.index == recordId);

    if (index != -1) {
      this.currentIpList[index][fieldName] = event.target.value;
      console.log('current Id-->', JSON.stringify(this.currentIpList[index]));

    }

  }

  removeRow_IpFunction(event) {
    let varLabel = event.target.dataset.label;         // Array name (e.g., 'OLM_Primary')
    let rowIdToRemove = event.target.dataset.index;    // Unique 4-digit index (as string)

    if (this.currentIpList && this.currentIpList.length > 1) {
      this.currentIpList = this.currentIpList.filter(row => row.index !== rowIdToRemove);

      this.currentIpList = this.currentIpList.map((row, idx) => {
        return {
          ...row,
        };
      });
    } else {
      console.warn(`Variable ${varLabel} not found or is empty!`);
    }
  }

  @track selectedType = 'Single';
  @track isSignle = false;
  @track isRange = false;
  handleTypeChange(event) {
    this.selectedType = event.target.value;
    console.log(this.selectedType);

    this.isSignle = false;
    this.isRange = false;
    if (this.selectedType == 'Multiple') {
      this.isSignle = true;
      this.isRange = false;
    }
    if (this.selectedType == 'Range') {
      this.isSignle = true;
      this.isRange = true;
    }

  }

  handleAddIps(event) {
    let tmpChk = this.validateIpRanges();
    if (tmpChk) {



      let uniqueIndex = event.target.dataset.pindex;
      let varLabel = event.target.dataset.label;

      let arrayIndex = this[varLabel].findIndex(row => row.index === uniqueIndex);
      this[varLabel][arrayIndex].IP_Address = this.currentIpList;
      this.currentIpList = [];
      console.log('varLabel-->', varLabel, JSON.stringify(this[varLabel][arrayIndex].IP_Address));
      this.isModalOpen = false;
      this.selectedType = 'Single';
      this.isSignle = false;
      this.isRange = false;
    }
  }



  addRow_IpFunction() {
    let tmpChk = this.validateIpRanges();
    if (tmpChk) {
      const newRow = {
        index: this.generateUniqueCode(),
        fromIp: '',
        fromToIp: '',
        type: '',          // optional, if you're using "Range" / "Multiple"
        disabled: true     // optional
      };

      this.currentIpList = [...this.currentIpList, newRow];

    }
  }



  validateIpRanges() {
    const isInvalidIp = (ip) => {
      if (!ip) return false;
      ip = ip.trim();

      // Simple blocked prefixes
      const blockedPrefixes = ['0.0.0.0', '127.', '10.', '192.168.'];

      for (const prefix of blockedPrefixes) {
        if (ip.startsWith(prefix)) {
          return true;
        }
      }

      // Special handling for 172.15.x.x to 172.31.x.x
      const match172 = ip.match(/^172\.(\d{1,3})\./);
      if (match172) {
        const secondOctet = parseInt(match172[1], 10);
        if (secondOctet > 15 && secondOctet <= 31) {
          return true;
        }
      }

      return false;
    };

    // ✅ Skip validation if IP list is empty
    if (!Array.isArray(this.currentIpList) || this.currentIpList.length === 0) {
      return true;
    }

    for (let index = 0; index < this.currentIpList.length; index++) {
      const ip = this.currentIpList[index];
      const fromIp = ip.fromIp?.trim();
      const toIp = ip.fromToIp?.trim();
      const type = ip.type;

      // ✅ Required field validation
      if (this.selectedType === 'Range') {
        if (!fromIp || !toIp) {
          this.showErrorToast2(`Both "From IP" and "To IP" are required for entry #${index + 1}`);
          return false;
        }
      } else if (this.selectedType === 'Multiple' || this.selectedType === 'Single') {
        if (!fromIp) {
          this.showErrorToast2(`"From IP" is required for entry #${index + 1} in Multiple mode`);
          return false;
        }
      }

      // ✅ IP range blocking
      if (isInvalidIp(fromIp)) {
        this.showErrorToast2(`"From IP" at entry #${index + 1} is in a private/reserved range and is not allowed.`);
        return false;
      }

      if (type === 'Range' && isInvalidIp(toIp)) {
        this.showErrorToast2(`"To IP" at entry #${index + 1} is in a private/reserved range and is not allowed.`);
        return false;
      }
    }

    return true;
  }







  closeModal() {
    this.isModalOpen = false;
  }

  addRow_RowFunction(event) {
    const varLabel = event.target.dataset.label;
    const userRole = event.target.dataset.userRole;
    const uniqueIndex = event.target.dataset.index;

    let varCheck = false;

    // Check if the array exists
    if (!this[varLabel] || !Array.isArray(this[varLabel])) {
      console.error(`Variable ${varLabel} is not defined or not an array`);
      return;
    }

    const arrayIndex = this[varLabel].findIndex(row => row.index === uniqueIndex);

    if (arrayIndex !== -1) {
      const row = this[varLabel][arrayIndex];

      // Validate Email
      if (!row.Email || row.Email.trim() === '') {
        varCheck = true;
        this.showErrorToast(`Please enter Email for ${userRole}`);
      }

      // Validate Name
      if (!row.Name || row.Name.trim() === '') {
        varCheck = true;
        this.showErrorToast(`Please enter Name for ${userRole}`);
      }

      // Handle IP_Address initialization (if applicable)
      const specialRoles = [
        'Data Submission Primary',
        'Data Submission Secondary',
        'OLM Primary',
        'OLM Secondary'
      ];



      // If no validation errors, add a new row (replicate logic as needed)
      if (!varCheck) {
        const newRow = {
          index: this.generateUniqueCode(),
          Name: '',
          Id: '',
          srNo: row.srNo + 1,
          Email: '',
          userRole: userRole,
          Phone: '',
          Designation: '',
          IP_Address: [{ index: this.generateUniqueCode(), fromIp: '', fromToIp: '', disabled: true }],
          isIPAddes: false,
        };

        if (specialRoles.includes(userRole)) {
          newRow.isIPAddes = true
        }

        this[varLabel].splice(arrayIndex + 1, 0, newRow);
      }
    } else {
      console.error(`Row with index ${uniqueIndex} not found in ${varLabel}`);
    }
  }


  showToast(title, message, variant = 'info') {
    const event = new ShowToastEvent({
      title,
      message,
      variant
    });
    this.dispatchEvent(event);
  }


  removeRow_RowFunction(event) {
    let varLabel = event.target.dataset.label;         // Array name (e.g., 'OLM_Primary')
    let rowIdToRemove = event.target.dataset.index;    // Unique 4-digit index (as string)

    if (this[varLabel] && this[varLabel].length > 1) {
      this[varLabel] = this[varLabel].filter(row => row.index !== rowIdToRemove);

      this[varLabel] = this[varLabel].map((row, idx) => {
        return {
          ...row,
          srNo: idx + 1
        };
      });
    } else {
      console.warn(`Variable ${varLabel} not found or is empty!`);
    }
  }



  usedCodes = new Set();

  generateUniqueCode() {
    let code;
    do {
      code = Math.floor(1000 + Math.random() * 9000).toString();
    } while (this.usedCodes.has(code));

    this.usedCodes.add(code);
    return code;
  }


  handleInputChange(event) {
    const recordId = event.target.dataset.id;
    const fieldName = event.currentTarget.name;
    const varLabel = event.target.dataset.label;
    const newValue = event.target.value;
    console.log('this.hasSignle-->', this.hasSignle);


    console.log(recordId, fieldName, varLabel, newValue);


    const updatedData = [...this[varLabel]];

    const recordIndex = updatedData.findIndex(item => item.index === recordId);

    if (recordIndex > -1) {
      //this.hasSignle = updatedData[recordIndex].isSingle;
      updatedData[recordIndex] = {
        ...updatedData[recordIndex],
        [fieldName]: newValue
      };
      console.log('recordIndex', recordIndex, ' value->', JSON.stringify(updatedData));

      this[varLabel] = updatedData;
      console.log('Updated Data:', JSON.stringify(this[varLabel]));

    }
  }










  @track SectionList = [

    {
      id: '1',
      pid: "1",
      isOpen: true,
      iconname: 'utility:form',
      name: 'Data Submission Primary',
      iconOpen: 'utility:chevronright',
      one_ds1: true,
      isSingle: false,
    },
    {
      id: '2',
      pid: "1",
      isOpen: false,
      iconname: 'utility:form',
      name: 'Data Submission Secondary',
      iconOpen: 'utility:chevronright',
      one_ds2: false,
      isSingle: false,
    },
    {
      id: '3',
      pid: "1",
      isOpen: false,
      iconname: 'utility:chart',
      name: 'DQR Primary',
      iconOpen: 'utility:chevronright',
      one_ds3: false,
      isSingle: false,
    },
    {
      id: '4',
      pid: "1",
      isOpen: false,
      iconname: 'utility:chart',
      name: 'DQR Secondary',
      iconOpen: 'utility:chevronright',
      one_ds4: false,
      isSingle: false,
    },
    {
      id: '5',
      pid: "1",
      isOpen: false,
      iconname: 'utility:table',
      name: 'DQI Primary',
      iconOpen: 'utility:chevronright',
      one_ds5: false,
      isSingle: false,
    },
    {
      id: '6',
      pid: "1",
      isOpen: false,
      iconname: 'utility:table',
      name: 'DQI Secondary',
      iconOpen: 'utility:chevronright',
      one_ds6: false,
      isSingle: false,
    },
    {
      id: '7',
      pid: "1",
      isOpen: false,
      iconname: 'utility:copy',
      name: 'Form C Primary',
      iconOpen: 'utility:chevronright',
      one_ds7: false,
      isSingle: false,
    },

    {
      id: '9',
      pid: "1",
      isOpen: false,
      iconname: 'utility:copy',
      name: 'Form C Secondary',
      iconOpen: 'utility:chevronright',
      one_ds9: false,
      isSingle: false,
    },

    {
      id: '8',
      pid: "1",
      isOpen: false,
      iconname: 'utility:user',
      name: 'Chief Data Officer',
      iconOpen: 'utility:chevronright',
      one_ds8: false,
      isSingle: true,
    }

  ];


  //@track SectionList = [];

  handleParentClick(event) {
    const clickedId = event.currentTarget.dataset.id;
    this.showSpinner = true;
    this.hasSignle = false;
    // Step 1: Toggle isOpen flag for the clicked item
    this.grievanceData = this.grievanceData.map(item => {
      item.style = '';

      if (item.id === clickedId) {
        this.hasSignle = item.isSingle;
        return { ...item, isOpen: !item.isOpen, style: 'background-color: #dd31e2ff;border-radius: 17px;' };
      }
      return item;
    });

    // Step 2: Find the clicked item
    const index = this.grievanceData.findIndex(item => item.id === clickedId);

    if (index !== -1) {
      const selectedItem = this.grievanceData[index];
      const sections = selectedItem.section || [];
      const check = this.getValueByKey(clickedId); // e.g., "g"

      const updatedSections = [];

      console.log('section-->', JSON.stringify(sections));

      for (let i = 0; i < sections.length; i++) {
        const current = sections[i];

        // Skip null or undefined
        if (current != null) {
          const section = { ...current }; // safe shallow clone

          // ✅ Skip empty objects
          if (Object.keys(section).length === 0) {
            continue;
          }

          const sectionId = String(section.id);
          const tempVar = `${check}_ds${sectionId}`;

          section[tempVar] = sectionId === '1';

          updatedSections.push(section);
        }
      }
      this.SectionList = [];

      setTimeout(() => {
        this.SectionList = updatedSections;
        console.log('this.SectionList-->', JSON.stringify(this.SectionList));

        this.showSpinner = false;
      }, 1000);

    }
  }




  @track activeSection = '1';

  handleSectionToggle(event) {
    const selectedId = event.target.name;
    const pid = event.target.dataset.pid;

    let check = this.getValueByKey(pid);
    let tempVarToOpen = check + '_ds' + selectedId;
    this.hasSignle = false;
    for (let ele of this.SectionList) {
      const tempVar = check + '_ds' + ele.id;

      ele[tempVar] = false;
      if (ele.id == selectedId) {
        this.hasSignle = ele.isSingle;
        ele[tempVarToOpen] = !ele[tempVarToOpen];
      } else {

      }
    }
  }




  @track optionList = [
    { '1': 'one' },
    { '2': 'second' },
    { '3': 'third' },
    { '4': 'four' },
    { '5': 'five' },
    { '6': 'six' },
    { '7': 'seven' },
    { '8': 'eight' }
  ]

  getValueByKey(key) {
    //console.log('key-->',key);
    const entry = this.optionList.find(obj => obj[key]);
    //console.log(key,entry);

    return entry ? entry[key] : null; // Returns the value or null if not found
  }

  get parentClasses() {
    return this.grievanceData.map(grp => ({
      id: grp.id,
      class: grp.isOpen ? 'parent-item active' : 'parent-item'
    }));
  }

  @track grievanceData = [
    {
      id: '1',
      isOpen: true,
      name: 'Data Submission',
      iconname: 'utility:case',
      style: 'background-color: #dd31e2ff;border-radius: 17px;',
      section: [
        {
          id: '1',
          pid: "1",
          isOpen: true,
          iconname: 'utility:form',
          name: 'Data Submission Primary',
          iconOpen: 'utility:chevronright',
          one_ds1: true,
          isSingle: false,
        },
        {
          id: '2',
          pid: "1",
          isOpen: false,
          iconname: 'utility:form',
          name: 'Data Submission Secondary',
          iconOpen: 'utility:chevronright',
          one_ds2: false,
          isSingle: false,
        },
        {
          id: '3',
          pid: "1",
          isOpen: false,
          iconname: 'utility:chart',
          name: 'DQR Primary',
          iconOpen: 'utility:chevronright',
          one_ds3: false,
          isSingle: false,
        },
        {
          id: '4',
          pid: "1",
          isOpen: false,
          iconname: 'utility:chart',
          name: 'DQR Secondary',
          iconOpen: 'utility:chevronright',
          one_ds4: false,
          isSingle: false,
        },
        {
          id: '5',
          pid: "1",
          isOpen: false,
          iconname: 'utility:table',
          name: 'DQI Primary',
          iconOpen: 'utility:chevronright',
          one_ds5: false,
          isSingle: false,
        },
        {
          id: '6',
          pid: "1",
          isOpen: false,
          iconname: 'utility:table',
          name: 'DQI Secondary',
          iconOpen: 'utility:chevronright',
          one_ds6: false,
          isSingle: false,
        },
        {
          id: '7',
          pid: "1",
          isOpen: false,
          iconname: 'utility:copy',
          name: 'Form C Primary',
          iconOpen: 'utility:chevronright',
          one_ds7: false,
          isSingle: false,
        },

        {
          id: '9',
          pid: "1",
          isOpen: false,
          iconname: 'utility:copy',
          name: 'Form C Secondary',
          iconOpen: 'utility:chevronright',
          one_ds9: false,
          isSingle: false,
        },
        {
          id: '8',
          pid: "1",
          isOpen: false,
          iconname: 'utility:user',
          name: 'Chief Data Officer',
          iconOpen: 'utility:chevronright',
          one_ds8: false,
          isSingle: true,
        },


      ]
    },
    {
      id: '2',
      isOpen: false,
      name: 'Data Correction / OLM',
      iconname: 'utility:database',
      style: '',
      section: [
        {
          id: '1',
          pid: "2",
          isOpen: false,
          iconname: 'utility:task',
          name: 'OLM Primary',
          iconOpen: 'utility:chevronright',
          second_ds1: false,
          isSingle: false,

        },
        {
          id: '2',
          isOpen: false,
          pid: "2",
          iconname: 'utility:task',
          name: 'OLM Secondary',
          iconOpen: 'utility:chevronright',
          second_ds2: false,
          isSingle: false,
        },
        {
          id: '3',
          pid: "2",
          isOpen: false,
          iconname: 'utility:user',
          iconOpen: 'utility:chevronright',
          name: 'Data Correction Head',
          second_ds3: false,
          isSingle: true,
        }
      ]
    },
    {
      id: '3',
      isOpen: false,
      name: 'Complaint Related Information',
      iconname: 'utility:form',
      style: '',
      section: [
        {
          id: '1',
          pid: "3",
          isOpen: false,
          iconname: 'utility:task',
          name: 'Dispute Email ID Primary',
          iconOpen: 'utility:chevronright',
          labeltoHide: 'dsPM',
          third_ds1: false,
          isSingle: false,
        },
        {
          id: '2',
          pid: "3",
          isOpen: false,
          iconname: 'utility:task',
          name: 'Dispute Email ID Secondary',
          iconOpen: 'utility:chevronright',
          labeltoHide: 'dsSe',
          third_ds2: false,
          isSingle: false,
        },
        {
          id: '3',
          pid: "3",
          isOpen: false,
          iconname: 'utility:user',
          name: 'Grievances Nodal Officer as per RBI/2023-24/73 DoR.FIN.REC.49/20.16.003/2023-24 - Oct 26, 2023',
          iconOpen: 'utility:chevronright',
          third_ds3: false,
          isSingle: true,
        },
        {
          id: '4',
          pid: "3",
          isOpen: false,
          iconname: 'utility:user',
          name: 'Grievance Principal Nodal Officer',
          iconOpen: 'utility:chevronright',
          third_ds4: false,
          isSingle: true,
        }
      ]
    },
    {
      id: '4',
      isOpen: false,
      name: 'Regulatory and Compliance',
      iconname: 'utility:inspector_panel',
      style: '',
      section: [
        {
          id: '1',
          pid: "4",
          isOpen: false,
          iconname: 'utility:task',
          name: 'Primary Email ID',
          iconOpen: 'utility:chevronright',
          four_ds1: false,
          isSingle: false
        },
        {
          id: '2',
          pid: "4",
          isOpen: false,
          iconname: 'utility:task',
          name: 'Secondary Email ID',
          iconOpen: 'utility:chevronright',
          four_ds2: false,
          isSingle: false
        },
        {
          id: '3',
          pid: "4",
          isOpen: false,
          iconname: 'utility:user',
          name: 'Chief Compliance Officer',
          iconOpen: 'utility:chevronright',
          four_ds3: false,
          isSingle: true,
        }
      ]
    },
    {
      id: '5',
      isOpen: false,
      name: 'Billing',
      iconname: 'utility:layout_card',
      style: '',
      section: [
        {
          id: '1',
          pid: "5",
          isOpen: false,
          iconname: 'utility:task',
          name: 'Primary Email ID',
          iconOpen: 'utility:chevronright',
          five_ds1: false,
          isSingle: false,
        },
        {
          id: '2',
          pid: "5",
          isOpen: false,
          iconname: 'utility:task',
          name: 'Secondary Email ID',
          iconOpen: 'utility:chevronright',
          five_ds2: false,
          isSingle: false,
        },
        {
          id: '3',
          pid: "5",
          isOpen: false,
          iconname: 'utility:user',
          name: 'Chief Financial Officer',
          iconOpen: 'utility:chevronright',
          five_ds3: false,
          isSingle: true,
        }
      ]
    },
    {
      id: '6',
      isOpen: false,
      name: 'Business / Sales Team',
      iconname: 'utility:identity',
      style: '',
      section: [
        {
          id: '1',
          pid: "6",
          isOpen: false,
          iconname: 'utility:task',
          name: 'Primary Email ID',
          iconOpen: 'utility:chevronright',
          six_ds1: false,
          isSingle: false,
        },
        {
          id: '2',
          pid: "6",
          isOpen: false,
          iconname: 'utility:task',
          name: 'Secondary Email ID',
          iconOpen: 'utility:chevronright',
          six_ds2: false,
          isSingle: false,

        },
        {
          id: '3',
          pid: "6",
          isOpen: false,
          iconname: 'utility:user',
          name: 'Chief Business Officer (CBO)',
          iconOpen: 'utility:chevronright',
          six_ds3: false,
          isSingle: true,
        },
        ,
        {
          id: '4',
          pid: "6",
          isOpen: false,
          iconname: 'utility:user',
          name: 'Chief Revenue Officer (CRO)',
          iconOpen: 'utility:chevronright',
          six_ds4: false,
          isSingle: true,
        }
      ]
    },
    {
      id: '7',
      isOpen: false,
      name: 'Technology Team',
      iconname: 'utility:matrix',
      style: '',
      section: [
        {
          id: '1',
          pid: "7",
          isOpen: false,
          iconname: 'utility:task',
          name: 'Primary Email ID',
          iconOpen: 'utility:chevronright',
          seven_ds1: false,
          isSingle: false,
        },
        {
          id: '2',
          pid: "7",
          isOpen: false,
          iconname: 'utility:task',
          name: 'Secondary Email ID',
          iconOpen: 'utility:chevronright',
          seven_ds2: false,
          isSingle: false,
        },
        {
          id: '3',
          pid: "7",
          isOpen: false,
          iconname: 'utility:user',
          name: 'Chief Technology Officer (CTO)',
          iconOpen: 'utility:chevronright',
          seven_ds3: false,
          isSingle: true,
        }
      ]
    },
    {
      id: '8',
      isOpen: false,
      name: 'General Management Team',
      iconname: 'utility:contact',
      style: '',
      section: [
        {
          id: '1',
          pid: "8",
          isOpen: false,
          iconname: 'utility:users',
          name: 'Authorized Signatory',
          iconOpen: 'utility:chevronright',
          eight_ds1: false,
          isSingle: true,
        },
        {
          id: '2',
          pid: "8",
          isOpen: false,
          iconname: 'utility:user',
          name: 'Nodal Officer (NO)',
          iconOpen: 'utility:chevronright',
          eight_ds2: false,
          isSingle: true,
        },
        {
          id: '3',
          pid: "8",
          isOpen: false,
          iconname: 'utility:user',
          name: 'Principal Nodal Officer (PNO)',
          iconOpen: 'utility:chevronright',
          eight_ds3: false,
          isSingle: true,
        },
        {
          id: '4',
          pid: "8",
          isOpen: false,
          iconname: 'utility:user',
          name: 'Chief Operating Officer (COO)',
          iconOpen: 'utility:chevronright',
          eight_ds4: false,
          isSingle: true,
        }
      ]
    }]


}