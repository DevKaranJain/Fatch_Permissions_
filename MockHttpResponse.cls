@isTest
global class MockHttpResponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://cyntexa-e8-dev-ed.my.salesforce.com/services/data/v39.0/tooling/query?q=SELECT+id,CreatedByid+from+ValidationRule', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        HttpResponse res = new HttpResponse();
        if(req.getEndpoint() == 'https://cyntexa-e8-dev-ed.my.salesforce.com/services/data/v39.0/tooling/query?q=SELECT+id,CreatedByid+from+ValidationRule'){
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"id":"03d5g0000009lwqAAA"}');
            res.setStatusCode(200);
            return res;
        }if(req.getEndpoint() =='https://cyntexa-e8-dev-ed.my.salesforce.com/services/data/v39.0/tooling/query?q=Select+Id,ValidationName,Active,Description,ErrorDisplayField,Metadata,+ErrorMessage+From+ValidationRule+where+id=03d5g0000009lwqAAA'){
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"validatonRuleName":"checking_for_user"}');
            res.setStatusCode(200);
            return res;
        }
        return res ;
        // Create a fake response
       
    }
}