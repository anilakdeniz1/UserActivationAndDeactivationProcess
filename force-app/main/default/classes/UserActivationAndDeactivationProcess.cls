/**
 * @author Sami Anıl Akdeniz <anilakdeni1@gmail.com>
 * @date 24/10/2024
 * @description Manages operataions after users isActive field is changed
 * Test Class : UserActivationAndDeactivationProcessTest
 * Test Class Coverage : %100
 */
public with sharing class UserActivationAndDeactivationProcess {
   
    /**
    * @descritpion Removes User from permission sets, groups, queues and adds or removes
    * Contains keyword from LastName after User's active checkbox is changed
    */
    public static void manageUserActivationAndDeactivationProcess(List<User> newUsers) {

        Set<Id> inactiveUserIds = new Set<Id>();
        Set<Id> activeUserIds = new Set<Id>();

        for (User userRec :newUsers) {
            inactiveUserIds = Utility.getRecordIdsWithFieldChange(newUsers, User.IsActive, false);
            activeUsersIds = Utility.getRecordIdsWithFieldChange(newUsers, User.IsActive, true);   
        }

        if (inactiveUserIds.size() > 0) {
            removeFromPermissionSets(inactiveUserIds);
            removeFromPublicGroupsAndQueues(inactiveUserIds);
            addInactiveText(inactiveUserIds);
        }
       
        if (activeUserIds.size() > 0) {
            removeInactiveText(activeUserIds);
        }
        
    }

    /**
    * @descritpion Removes User from permission sets when isActive field is set to false
    * @param inactiveUserIds Set<Id>
    */
    public static void removeFromPermissionSets(Set<Id> inactiveUserIds) {

        Set<Id> permissionSetIds = new Set<Id>();

        List<PermissionSet> permissionSets = [SELECT Id FROM PermissionSet
                                                        WHERE ProfileId = NULL
                                                        WITH SECURITY_ENFORCED];
        for (permissionSets ps : permissionSets) {
            permissionSetIds.add(ps.Id);
        }

        List<PermissionSetAssignment> permissionSetAssignmentsToBeDeleted = [SELECT Id, AssigneeId, PermissionSetId FROM PermissionSetAssignment
                                                                                                                    WHERE AssigneeId IN :inactiveUserIds
                                                                                                                    AND PermissionSetId IN :permissionSetIds
                                                                                                                    WITH SECURITY_ENFORCED];
        if (permissionSetAssignmentsToBeDeleted.size() > 0) {
            delete permissionSetAssignmentsToBeDeleted;
        }
    }

    /**
    * @descritpion Removes User from groups when isActive field is set to false
    * @param inactiveUserIds Set<Id>
    */
    public static void removeFromPublicGroupsAndQueues(Set<Id> inactiveUserIds) {

        List<GroupMember> groupMembers = [SELECT Id FROM GroupMember 
                                                    WHERE UserOrGroupId IN :inactiveUserIds 
                                                    WITH SECURITY_ENFORCED];
        if (groupMembers.size() > 0) {
            delete groupMembers;
        }
    }

    /**
    * @descritpion Adds inactive text from user when isActive field is set to false
    * @param inactiveUserIds Set<Id>
    */
    public void addInactiveText(Set<Id> inactiveUserIds) {

        List<User> inactiveUsers = [SELECT Id, LastName FROM User WHERE Id IN : inactiveUserIds];

        for (User user : inactiveUsers) {
            if (!user.LastName.contains('(Inactive)')) {
                user.LastName += '(Inactive)';
            }
        }
        
        update inactiveUsers;
    }

    /**
    * @descritpion Removes inactive text from user when isActive field is set to true
    * @param activeUserIds Set<Id>
    */
    public void removeInactiveText(Set<Id> activeUserIds) {

        List<User> activeUsers = [SELECT Id, LastName FROM User WHERE Id IN :activeUserIds];

        for (User user : activeUsers) {
            user.LastName = user.LastName.substringBefore('Inactive');
        }

        update activeUsers;
    }

    /**
    * @descritpion Because of avoiding mixed DML error called that future method.
    * @param inactiveUserIds Set<Id>
    */
    public void changeOppOwner(Set<Id> activeUserIds) {
        updateOwner(inactiveUsersIds);
    }

    /**
    * @descritpion Makes the ownerId of opportunity to System Admin's userId when User is deactivated
    * @param inactiveUserIds Set<Id>
    */
    @future
    private static void updateOwner(Set<Id> inactiveUsersIds) {
        Id systemAdminUserId = [SELECT Id FROM User WHERE Name = 'Name' AND Profile.Name = 'System Administrator'].Id;

        List<Opportunity> opportunities = [SELECT Id, OwnerId FROM Opportunity WHERE OwnerId IN :inactiveUsersIds];

        for (Opportunity opp : opportunities) {
            opp.OwnerId = systemAdminUserId;
        }

        update opportunities;
    }
}