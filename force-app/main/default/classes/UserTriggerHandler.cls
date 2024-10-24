public with sharing class UserTriggerHandler {

    private Boolean triggerIsExecuting;
    private Integer triggerSize;

    public UserTriggerHandler(Boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<User> newUsers){

    }
    
    public void beforeUpdate(List<User> newUsers, List<User> oldUsers, Map<Id, SObject> newUserMap, Map<Id, SObject> oldUserMap){
    
    }
    
    public void beforeDelete(List<User> oldUsers, Map<Id, SObject> oldUserMap){
     
    }
    
    public void afterInsert(List<User> newUsers, Map<Id, SObject> newUserMap){        
    }
    
    public void afterUpdate(List<User> newUsers, List<User> oldUsers, Map<Id, SObject> newUserMap, Map<Id, SObject> oldUserMap){
        new UserActivationAndDeactivationProcess().manageUserActivationAndDeactivationProcess(newUsers);
    }
    
    public void afterDelete(List<User> oldUsers, Map<Id, SObject> oldUserMap){

    }
    
    public void afterUndelete(List<User> newUsers, Map<Id, SObject> newUserMap){
    
    }
}