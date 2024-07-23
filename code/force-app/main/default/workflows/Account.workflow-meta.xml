<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_PreOccupy_Remain_10_Days</fullName>
        <description>Account: PreOccupy Remain 10 Days</description>
        <protected>false</protected>
        <recipients>
            <field>Responsible_RM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FSCEmailTemplates/PreOccupy_Remain_10_Days</template>
    </alerts>
    <alerts>
        <fullName>Account_PreOccupy_Remain_30_Days</fullName>
        <description>Account: PreOccupy Remain 30 Days</description>
        <protected>false</protected>
        <recipients>
            <field>Responsible_RM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FSCEmailTemplates/PreOccupy_Remain_30_Days</template>
    </alerts>
    <fieldUpdates>
        <fullName>ManageEndDay</fullName>
        <field>PreOccupy_End_Date__c</field>
        <formula>PreOccupy_End_Date__c +180</formula>
        <name>ManageEndDay</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Request_Release</fullName>
        <field>Request_Release__c</field>
        <literalValue>1</literalValue>
        <name>Request Release</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
