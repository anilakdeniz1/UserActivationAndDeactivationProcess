public class Utility {
 
    public static Set<Id> getRecordIdsWithFieldChange (List<sObject> newRecords, sObjectField field, boolean desicion) {
        Set<Id> validRecords = new Set<Id>();
        for (sObject newSObj :newRecords) {
            SObject oldSObj = Trigger.oldMap.get(newSObj.Id);
            if(newSObj.get(field) = desicion && newSObj.get(field) != oldSObj.get(field)) {
                validRecords.add(newSObj.Id);
            }
        }
        return validRecords;
    }
}