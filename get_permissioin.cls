public class get_permissioin {

    //this function working on user and return search user 
    @AuraEnabled(cacheable = true)
        public static List < user > main(String searchfields) 
        {
            try 
            {
                List < user > userName = new List < user > ();
                userName = [SELECT Name, Id, ProfileId FROM User where Name LIKE :( searchfields + '%')];
                return userName;
            } 
            catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
       // this function work for fatching all  fields  
    @AuraEnabled
        public static List<String> fieldsName(String searchfields , String searchobj)
        {
            try 
            {
                Map <String, Schema.SObjectType> schemaMapofAllSobject = Schema.getGlobalDescribe();
                List<String> fieldsnames = new List<String>();
                Map <String, Schema.SObjectField> MapofdesiredObject = schemaMapofAllSobject.get(searchobj).getDescribe().fields.getMap();
                for(Schema.SObjectField sObjectfield : MapofdesiredObject.Values())
                    {
            
            	        schema.describefieldresult dfield = sObjectfield.getDescribe();
                        if(dfield.getname().containsIgnoreCase(searchfields))
                        {
                            fieldsnames.add(dfield.getname());
                        }
                    } 
                            return fieldsnames;
            } 
            catch (Exception e) 
            {
                throw new AuraHandledException(e.getMessage());
            }
        }

    //this method return all the field level security     
    @AuraEnabled(cacheable = true)
        public static list < FieldPermissions > getallrecord(String userId, String sobjectName, String sobjectField) 
        {
            String str = sobjectName+'.'+sobjectField;
            list < FieldPermissions > fps = [SELECT sObjectType, Field, PermissionsRead, PermissionsEdit FROM FieldPermissions WHERE(sobjecttype =: sobjectName and field =: str) and ParentId IN(SELECT Id FROM permissionset WHERE PermissionSet.Profile.id =: userId) ORDER BY sObjectType];
            return fps;
        }
    //this field return all sObject that you search 
    @AuraEnabled(cacheable=true)
        public static List < String > getAllCustomSObjects(String searchK)
        {
            List < String > sObjectList = new List < String > ();
            for (Schema.SObjectType objTyp: Schema.getGlobalDescribe().Values()) 
            {
                Schema.DescribeSObjectResult describeSObjectResultObj = objTyp.getDescribe();
                String name = objTyp.getDescribe().getName();
                if (!name.containsignorecase('history') && !name.containsignorecase('tag') &&
                    !name.containsignorecase('share') && !name.containsignorecase('feed') &&
                    name.containsignorecase(searchK)) 
                {
                    SobjectList.add(name);
                }   
            }
                    return sObjectList;
        }

     //this method retrive all permission set    
    @AuraEnabled(cacheable = true)
    public static List < PermissionSet > getPermissionSet(String uId)
    {
        try 
        {
            List < PermissionSet > listpermission = new List < PermissionSet > ();
            listpermission = [SELECT Name, (SELECT SObjectType, Field, PermissionsRead, PermissionsEdit FROM FieldPerms) FROM PermissionSet WHERE Id IN(SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: uId) ];
            return listpermission;
        } 
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
    

    //this method reterive all validation rule id 
		@AuraEnabled(cacheable = true)
			public static String callmetadataAPI() //String users
			{
				try 
				{
					HttpRequest req = new HttpRequest();
					req.setHeader('Authorization', 'Bearer !ARIAQEs0Ow9xSCOZESuRQ_jfovQ5uqIaGR6mw33ZtbkmBHvvO8qf.o4AlEpGCxogHezQ7ykUJ6uIG3micKh.O3N5CYT7eXIf');
					req.setEndpoint('https://cyntexa-e8-dev-ed.my.salesforce.com/services/data/v39.0/tooling/query?q=SELECT+id,CreatedByid+from+ValidationRule');
					req.setMethod('GET');
					Http h = new Http();
					HttpResponse res = h.send(req);
                    
					return res.getbody();
				} 
				catch (Exception e) 
				{
					throw new AuraHandledException(e.getMessage());
				}
			}

        //this method retrieve all validaiton rule
    @AuraEnabled(cacheable=true)
        public static List<String> callvalidationrules(String use)
        {
           
            Set<Id> userId = new Set<Id>();
            List<object> result = (List<object>)(JSON.deserializeUntyped(use));
            for (object o : result) 
            {
                Map<String, Object> mapName = (Map<String, Object>)o;
                userId.add((Id)mapName.get('value'));
            }
            List<String> JsonList = new List<String>();
                for (Id ids  : userId) 
                {
                    HttpRequest req = new HttpRequest();
                    req.setHeader('Authorization', 'Bearer !ARIAQEs0Ow9xSCOZESuRQ_jfovQ5uqIaGR6mw33ZtbkmBHvvO8qf.o4AlEpGCxogHezQ7ykUJ6uIG3micKh.O3N5CYT7eXIf');
                    req.setEndpoint('https://cyntexa-e8-dev-ed.my.salesforce.com/services/data/v39.0/tooling/query?q=Select+Id,ValidationName,Active,Description,ErrorDisplayField,Metadata,+ErrorMessage+From+ValidationRule+where+id=\'' + IDS + '\'');
                    req.setMethod('GET');
                    Http h = new Http();
                    HttpResponse res = h.send(req);
                    JsonList.add(res.getBody());
                    
                }
                    return JsonList;      

            }
}