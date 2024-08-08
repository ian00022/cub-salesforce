global with sharing class ReservedRelease implements Database.Batchable<SObject>{
    public ReservedRelease() {

    }

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, Name, Release_Date__c, Responsible_RM__c, Responsible_RM__r.Belong_Country__c, Responsible_RM__r.Email  FROM Account WHERE Release_Date__c = Today AND Managed_RM__c = null');
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts){
        List<CustomNotificationType> customNotificationTypeDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE  DeveloperName= 'Account_RM_Reserved_Release' LIMIT 1];
        // List<EmailTemplate> emailTemplates = [SELECT Id,Subject, Body FROM EmailTemplate WHERE DeveloperName = 'OccupyAccount_Released_Eng' OR DeveloperName = 'OccupyAccount_Released_TW' ORDER BY Subject DESC];
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        String enNotification = System.Label.get('','Released_Notification','en');
        String zhNotification = System.Label.get('','Released_Notification','zh');
        String enEmail = System.Label.get('','OccupyAccount_Released','en');
        String zhEmail = System.Label.get('','OccupyAccount_Released','zh');

        for(Account account : accounts){
            if(account.Release_Date__c == Date.today()){

                String title;
                String notificationBody;
                String eamilBody;

                if (account.Responsible_RM__r.Belong_Country__c == 'TW') {
                    title = '預佔客戶已釋出';
                    notificationBody =  account.Name + zhNotification;
                    eamilBody = zhEmail; 
                } else {
                    title = 'occupy account has been released';
                    notificationBody =  account.Name + enNotification;
                    eamilBody = enEmail;  
                }

                 // Send Notification
                 Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                 currNotification.setTitle(title);
                 currNotification.setBody(notificationBody);
                 currNotification.setNotificationTypeId(customNotificationTypeDetail.isEmpty() ? null : customNotificationTypeDetail[0].Id);
                 currNotification.setTargetId(account.Id);
                //  currNotification.send(new Set<String> {account.Responsible_RM__c});
                 
                try {
                    currNotification.send(new Set<String> {account.Responsible_RM__c});
                } catch (Exception ex) {
                    System.debug('Notification Failed: ' + ex.getMessage());
                }

                // Send Email
                String fullRecordURL = URL.getOrgDomainURL().toExternalForm() + '/' + account.Id;
                if(account.Responsible_RM__r.Email != null){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new List<String>{ account.Responsible_RM__r.Email });
                    mail.setHTMLBody(eamilBody + fullRecordURL);
                    mail.setSubject(title);
                    mail.setUseSignature(false);
                    allmsg.add(mail);
                }

                account.Responsible_RM__c = null;

            }
        }  

        try {
            Messaging.sendEmail(allmsg,false);
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        update accounts;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('finish');
    }
}