@isTest(seeAllData=true)
private class get_permissioinTestClass {
    static testMethod void validateusers(){
        List<user> userName = get_permissioin.main('Karan Jain');
        String s =''; 
        for(User u : userName){
            s = u.Name ; 
        }
        System.assertEquals('Karan Jain',s, 'not equal');
    //} 
    
    //static testMethod void validateFields(){
    	List<String> listOfFields  = get_permissioin.fieldsName('AnnualRevenue', 'Account');
        String sField = '';
        for(String fields : listOfFields){
            sField = fields;
        }
        System.assertEquals('AnnualRevenue',sField, 'not equal');
    //}
    
    //static testMethod void validateSobject(){
		List<String> listOfsObject  = get_permissioin.getAllCustomSObjects('KaranJain__Account_Backup__ChangeEvent');
        String sObj = '';
        for(String objects : listOfsObject){
            sobj = objects;
        }
        System.assertEquals('KaranJain__Account_Backup__ChangeEvent',sobj, 'not equal');
        
   // }
   // static testMethod void validateFieldlevels(){
        List<FieldPermissions> listOfpermission  = get_permissioin.getallrecord('00e5g000002hCnYAAU', 'account', 'account.AnnualRevenue');
        String sPermission = '';
        for(FieldPermissions per : listOfpermission){
            IF(per.Field.containsIgnoreCase('account.AnnualRevenue')){
                    sPermission= 'account.AnnualRevenue';
            }
            
        }
      
       // System.assertEquals('account.AnnualRevenue',s, 'not equal');

   // }
   // static testMethod void validatepermissionSet(){
        List < PermissionSet > lps = get_permissioin.getPermissionSet('0055g000006o1IOAAY');
        String sPermissionSet = '';
        for(PermissionSet ps : lps){
            if(ps.Name.containsIgnoreCase('permission_for_bank')){
            	sPermissionSet = ps.Name;    
            }
            
        }
        System.assertEquals('permission_for_bank',sPermissionSet, 'Equal');
        
    //}
          
    }
         @isTest static void testCallout() {
             string res1 = '';
             String s = '[{"value":"03d5g0000009lwqAAA"},{"value":"03d5g0000009kVjAAI"},{"value":"03d5g0000008m7TAAQ"},{"value":"03d5g00000090q0AAA"}]';
        // Set mock callout class 
        System.Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        get_permissioin.callmetadataAPI();
        get_permissioin.callvalidationrules(s);
        
    }
    
    
}