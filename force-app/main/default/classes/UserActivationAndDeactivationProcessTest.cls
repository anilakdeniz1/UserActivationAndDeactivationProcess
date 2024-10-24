@isTest
public with sharing class UserActivationAndDeactivationProcessTest {

    @isTest
    static void removeFromPermissionSet_whenUserIsChangedToInactive() {

        // User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        User aUser = TestUtility.createActiveOrInactiveUser(true);
        PermissionSet aPermissionSet = TestUtility.createPermissionSet();
        PermissionSetAssignment psa = TestUtility.createPermissionSetAssignment();

        Test.startTest();

        aUser.IsActive = false;
        update aUser;

        Test.stopTest();

        List<PermissionSetAssignment> permissionSetAssignmentsAfterDeletion = [SELECT Id FROM PermissionSetAssignment
                                                                                         WHERE AssigneeId = :aUser[0].Id
                                                                                         AND PermissionSetId = :aPermissionSet[0].Id];

        System.assertEquals(0, permissionSetAssignmentsAfterDeletion.size(), 'There should be none permission set assignment after user become inactive.');
    }

    static void removeFromQueuesOrGroups_whenUserIsChangedToInactive() {

        User aUser = TestUtility.createActiveOrInactiveUser(true);
        Group aGroup = TestUtility.createGroupWithType('Queue');
        GroupMember aGroupMember = TestUtility.createGroupMember(aUser.Id, aGroup.Id);

        Test.startTest();

        aUser.IsActive = false;
        update aUser;

        Test.stopTest();

        List<GroupMember> groupMembersAfterDeletion = [SELECT Id FROM GroupMember WHERE UserOrGroupId = :aUser[0].Id];

        System.assertEquals(0, groupMembersAfterDeletion.size(), 'There should be none group members after user become inactive.');
    }

    static void addInactiveTest_whenUserIsChangedToInactive() {

        User aUser = TestUtility.createActiveOrInactiveUser(true);

        Test.startTest();

        aUser.IsActive = false;
        update aUser;

        Test.stopTest();

        User anUpdatedUser = [SELECT Id, LastName FROM User WHERE Id = :aUser.Id];
        System.assertEquals('User (Inactive)', updatedUser.LastName, 'Inactive text should be added.');
    }

    static void removeInactiveTest_whenUserIsChangedToActive() {

        User aUser = TestUtility.createActiveOrInactiveUser(false);

        Test.startTest();

        aUser.IsActive = true;
        update aUser;

        Test.stopTest();

        User anUpdatedUser = [SELECT Id, LastName FROM User WHERE Id = :aUser.Id];
        System.assertEquals('User', updatedUser.LastName, 'Inactive text should be removed.');
    }

    static void changeOppOwner_whenUserIsChangedToInactive() {
        
        Id systemAdminUserId = [SELECT Id FROM User WHERE Name = 'Name' AND Profile.Name = 'System Administrator'].Id;

        Opportunity anOpportunity = TestUtility.createOpportunity();

        Test.startTest();

        aUser.IsActive = false;
        update aUser;

        Test.stopTest();

        Opportunity updatedOpportunity = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :anOpportunity.Id];
        System.assertEquals(systemAdminUserId, updatedOpportunity.OwnerId, 'Owner Id should be changed to system admin Id.');
    }
}