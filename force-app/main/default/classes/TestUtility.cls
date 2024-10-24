@isTest
public with sharing class TestUtility {
    
    public static User createActiveOrInactiveUser(Boolean decision) {

        Profile profile = [ SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        aUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'test_user@test.com',
            Username = System.now().millisecond() + 'test_user@test.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'Europe/Berlin',
            LocaleSidKey = 'de_DE',
            EmailEncodingKey = 'UTF-8',
            ProfileId = profile.Id,
            LanguageLocaleKey = 'de',
            ContactId = aContact.Id,
            IsActive = decision
        );

        insert aUser;
    }

    public static PermissionSet createPermissionSet() {
        PermissionSet aPermissionSet = new PermissionSet(
            Name = 'TestPermissionSet',
            Label = 'Test Permission Set' 
        );

        insert aPermissionSet;

        return aPermissionSet;
    }

    public static PermissionSetAssignment createPermissionSetAssignment(Id userId, Id permissionSetId) {
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = userId,
            PermissionSetId = permissionSetId
        );

        insert psa;

        return psa;
    }

    public static Group createGroupWithType(String type) {
        Group aGroup = new Group(
            Name = 'Test Group',
            Type = type
        );

        insert aGroup;

        return aGroup;
    }

    public static GroupMember createGroupMember(Id userId, Id groupId) {

        GroupMember aGroupMember = new GroupMember(
            UserOrGroupId = userId,
            GroupId = groupId
        );

        insert aGroupMember;

        return aGroupMember;
    }

    public static Opportunity createOpportunity(){
        Opportunity anOpportunity = new Opportunity(
            Name = 'Test Opportunity', 
            StageName = 'Prospecting', 
            CloseDate = System.today()
        );
        insert anOpportunity;
        
        return anOpportunity;
    }
}