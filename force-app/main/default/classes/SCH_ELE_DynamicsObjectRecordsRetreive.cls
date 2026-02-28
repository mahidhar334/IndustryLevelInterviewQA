// Inteview Question in SCHINDER Electric
public with sharing class SCH_ELE_DynamicsObjectRecordsRetreive {
    public SCH_ELE_DynamicsObjectRecordsRetreive() {

    }
    public List<String> getsObjectRecords(String objectName , String fields){
    String query ='Select id'+ fields +'from ' + objectName;
    List<sObject> objectRecords = Database.query(query);
    List<String> objectRecordsList = new List<String>();
    for(sObject record : objectRecords){
       // objectRecordsList.add(String.valueOf(record.get('id')));
        String value = String.valueOf(record.get(fields));
        if(value != null){
            objectRecordsList.add(value);
        }   
    }
    return objectRecordsList;
    }

    // what if we want to get multiple fields values in a list of string, then we can modify the method as below
    public List<String> getsObjectRecordsMultipleFields(String objectName , List<String> fields){
    String fieldsString = String.join(fields, ',');
    String query ='Select id, ' + fieldsString +' from ' + objectName;
    List<sObject> objectRecords = Database.query(query);
    List<String> objectRecordsList = new List<String>();
    for(sObject record : objectRecords){
        List<String> fieldValues = new List<String>();
        for(String field : fields){
            String value = String.valueOf(record.get(field));
            if(value != null){
                fieldValues.add(value);
                
            }
        }
        objectRecordsList.add(String.join(fieldValues, ','));
    }
    return objectRecordsList;
    }

    // use map instead of nested for loops
    public List<String> getsObjectRecordsMultipleFieldsUsingMap(String objectName , List<String> fields){
    String fieldsString = String.join(fields, ',');
    String query ='Select id, ' + fieldsString +' from ' + objectName;
    List<sObject> objectRecords = Database.query(query);
    List<String> objectRecordsList = new List<String>();
    for(sObject record : objectRecords){
        Map<String, String> fieldValuesMap = new Map<String, String>();
        for(String field : fields){
            String value = String.valueOf(record.get(field));
            if(value != null){
                fieldValuesMap.put(field, value);
            }
        }
        objectRecordsList.add(String.join(fieldValuesMap.values(), ','));
    }
    return objectRecordsList;
    }
                
}