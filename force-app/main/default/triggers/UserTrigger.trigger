trigger UserTrigger on SOBJECT (before insert, before update, before delete, after insert, after update, after delete,after undelete) {

    TriggerHandler handler = new UserTriggerHandler(Trigger.isExecuting, Trigger.size);

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            handler.beforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            handler.beforeUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        }
        when BEFORE_DELETE{
            handler.beforeDelete(Trigger.old, Trigger.oldMap);
        }
        when AFTER_INSERT{
            handler.afterInsert(Trigger.new,Trigger.newMap);
        }
        when AFTER_UPDATE{
            handler.afterUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        }
        when AFTER_DELETE{
            handler.afterDelete(Trigger.old, Trigger.oldMap);
        }
        when AFTER_UNDELETE{
            handler.afterUndelete(Trigger.new, Trigger.newMap);
        } 
    }
}