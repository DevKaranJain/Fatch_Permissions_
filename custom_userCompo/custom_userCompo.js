import {LightningElement,api,track} from 'lwc';
import user from '@salesforce/apex/get_permissioin.main';
import getallrecords from '@salesforce/apex/get_permissioin.getallrecord';
import mySobject from '@salesforce/apex/get_permissioin.getAllCustomSObjects';
import myfields from '@salesforce/apex/get_permissioin.fieldsName';
import retrivePermssionSet from '@salesforce/apex/get_permissioin.getPermissionSet';
import reteriveValidationRule from '@salesforce/apex/get_permissioin.callmetadataAPI';
import reteriveRule from '@salesforce/apex/get_permissioin.callvalidationrules';


export default class Custom_userCompo extends LightningElement {


	val;
	ids;
	proids;
	item;
	field;
	proId;
	data;
	name;
	permissiondata;
	userassignID;
	selecteduserName;
	test;
	value = 'running';
	objectvalues = [];
	mmap = {};
	showdata = [];
	siteURL;
	@api sessionids;
	@track validationrule = [];
	@track listofvalidationRule = [];
	@track clickedButtonLabel = 'Search';
	@track boolVisible = false;
	@track allnamedcontact;
	@track allfielddata;
	@track allusers;
	@track searchkey = "";
	@track fieldsearch = "";
	@track usersearch = "";
	@track selectedRecordId;
	@track selectedRecordName;
	@track selectedfieldName;


	columns = [{
			label: 'Field',
			fieldName: 'Field',
			type: 'text'
		},
		{
			label: 'PermissionsRead',
			fieldName: 'PermissionsRead',
			type: 'text'
		},
		{
			label: 'PermissionsEdit',
			fieldName: 'PermissionsEdit',
			type: 'text'
		},

	];
	onloaddata3(event) {
		const usersearch = event.target.value;
		this.usersearch = usersearch.trim();
		if (this.usersearch !== '' && this.usersearch.length > 0) {
			setTimeout(() => {
				this.newnames3()
			}, 300);
		} else {
			this.allusers = null;
		}
	}
	onfocusout3(event) {
		setTimeout(() => {
			this.allusers = null;
		}, 300);
	}
	newnames3() {
		user({
				searchfields: this.usersearch
			})
			.then(data => {
				var arr = [];
				this.item = [];
				for (let i = 0; i < data.length; i++) {
					this.ids = data[i].Id;
					this.val = data[i].Name;
					this.proids = data[i].ProfileId;
					arr.push({
						label: this.ids,
						value: this.val
					});
				}
				this.allusers = arr;
			})
			.catch(err => {
				console.log(err);
			});

	}
	getdataa3(event) {

		this.selecteduserName = event.target.dataset.name;
		this.selecteduserName = this.val;
		const usersearch = this.val; 
		this.usersearch = usersearch;
		event.preventDefault();
	}

	handleChangecall(storedatas) {
		var s = JSON.parse(this.listofvalidationRule);
		this.showdata = [];
		reteriveRule({
				use: this.listofvalidationRule
			})
			.then(res => {
				res.forEach(element => {
                   
					this.listofvalidationRule = [];
					var re = JSON.parse(element);
					var formula = re.records[0].Metadata.errorConditionFormula;
					var validationName = re.records[0].ValidationName;
					if (formula.includes('$User.')) {
						this.validationrule.push({
							label: validationName,
							value: formula
						});
					}
				});
				this.showdata = this.validationrule;
				this.validationrule = [];

			});
	}

	searchButton2() {
		var label = this.clickedButtonLabel;
		if (label === 'Search') {
			this.clickedButtonLabel = 'Searched';
			this.boolVisible = true;
			getallrecords({
					userId: this.proids,
					sobjectName: this.selectedRecordName,
					sobjectField: this.selectedfieldName
				})
				.then(res => {
					this.data = res;
					var storefield = [];
					if (this.data.length == 0 && this.fieldsearch != '') {
						storefield.push({

							Field: this.fieldsearch,
							PermissionsRead: false,
							PermissionsEdit: false
						});
						this.data = storefield;
					}
				})
				.catch(err => {
					console.log(err);
				});

			retrivePermssionSet({
					uId: this.ids,
				})
				.then(res => {
					this.objectvalues = [];
					var objvalues = [];
					var store = [];
					for (let i = 0; i < res.length; i++) {
						for (let j = 0; j < res[i].FieldPerms.length; j++) {
							var con = this.selectedRecordName.concat('.', this.fieldsearch)
							if (res[i].FieldPerms[j].SobjectType == this.selectedRecordName &&
								res[i].FieldPerms[j].Field == con) {
								objvalues.push({
									label: res[i].Name,
									value: res[i].FieldPerms[j].Field,
									read: res[i].FieldPerms[j].PermissionsRead,
									write: res[i].FieldPerms[j].PermissionsEdit
								});
							}
						}
						store = [];
					}
					this.objectvalues = JSON.parse(JSON.stringify(objvalues));
				});
    			this.userassignID = this.proids //this.mmap[this.value];

			//reterive all validation rule ids ;
			reteriveValidationRule({
					users: this.ids
				})
				.then(res => {

					var response = JSON.parse(res);
                    
					var r = response.records;
					this.listofvalidationRule = [];
					var storeData = [];
					for (var index = 0; index < r.length; index++) {
						var valls = r[index].Id;
						var keys = JSON.stringify(index);

						storeData.push({
							value: valls
						});
					}
					this.listofvalidationRule = JSON.stringify(storeData);
                    console.log('ids ', this.listofvalidationRule);
					this.handleChangecall(storeData);
					storeData = [];
				});


			// this is for reterive validation rules

		} else if (label === 'Searched') {
			this.clickedButtonLabel = 'Search';
			this.boolVisible = false;
		}
	}

	// for the dynamic picklist values 

	onloaddata(event) {
		const searchkey = event.target.value;
		this.searchkey = searchkey.trim();
		if (this.searchkey !== '' && this.searchkey.length > 0) {
			setTimeout(() => {
				this.newnames()
			}, 300);
		} else {
			this.allnamedcontact = null;
		}
	}
	onfocusout(event) {
		setTimeout(() => {
			this.allnamedcontact = null;
		}, 300);
	}
	newnames() {
		mySobject({
				searchK: this.searchkey
			})
			.then(data => {
				this.allnamedcontact = data;
			})
			.
		catch(err => {
			console.log(err);
		});
	}
	getdataa(event) {
		this.selectedRecordId = event.target.dataset.key;
		this.selectedRecordName = event.target.dataset.name;

		const searchkey = event.target.dataset.name;
		this.searchkey = searchkey;
		event.preventDefault();
	}



	//this will fatch all fields according to object 

	onloaddata2(event) {
		const fieldsearch = event.target.value;
		this.fieldsearch = fieldsearch.trim();
		if (this.fieldsearch !== '' && this.fieldsearch.length > 0) {
			setTimeout(() => {
				this.newnames2()
			}, 300);
		} else {
			this.allfielddata = null;
		}
	}
	onfocusout2(event) {
		setTimeout(() => {
			this.allfielddata = null;
		}, 300);
	}
	newnames2() {
		var objname = this.selectedRecordName
		myfields({
				searchfields: this.fieldsearch,
				searchobj: objname
			})
			.then(data => {
				this.allfielddata = data;
			})
			.
		catch(err => {
			console.log(err);
		});

	}
	getdataa2(event) {
		this.selectedfieldName = event.target.dataset.name;
		const fieldsearch = event.target.dataset.name;
		this.fieldsearch = fieldsearch;
		event.preventDefault();
	}
}