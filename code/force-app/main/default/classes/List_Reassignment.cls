public with sharing class List_Reassignment {
    @InvocableMethod(callout=true label='List Reassignment')

    public static List<OutputVariables> listReassign(InputVariables[] inputVariables){

        Id campaignId = (inputVariables.get(0).campaignId != null) ? Id.valueOf(inputVariables.get(0).campaignId) : null;
        List<Id> selectedRMId = inputVariables.get(0).selectedRMId != null ? inputVariables.get(0).selectedRMId : new List<Id>();
        List<Id> selectedRMPersonnelId = inputVariables.get(0).selectedRMPersonnelId != null ? inputVariables.get(0).selectedRMPersonnelId : new List<Id>();
        Integer maxCount = Integer.valueOf(inputVariables.get(0).maxCount);
        List<String> resetRule = inputVariables.get(0).resetRule;
        List<String> ruleOrder = inputVariables.get(0).ruleOrder;
        List<String> range = inputVariables.get(0).range;
        String orderBy;
        
        if (!resetRule.isEmpty() && !ruleOrder.isEmpty() && ruleOrder.size() > 0) {
            String resetRule1 = resetRule[0];
            String resetRule2 = (resetRule.size() > 1) ? resetRule[1] : '';
            String resetRule3 = (resetRule.size() > 2) ? resetRule[2] : '';
            String resetRule4 = (resetRule.size() > 3) ? resetRule[3] : '';
            String ruleOrder1 = (ruleOrder[0].equals('DESC')) ? 'DESC' : 'ASC';
            String ruleOrder2 = (ruleOrder.size() > 1 && ruleOrder[1].equals('DESC')) ? 'DESC' : 'ASC';
            String ruleOrder3 = (ruleOrder.size() > 2 && ruleOrder[2].equals('DESC')) ? 'DESC' : 'ASC';
            String ruleOrder4 = (ruleOrder.size() > 3 && ruleOrder[3].equals('DESC')) ? 'DESC' : 'ASC';
        
            orderBy =  resetRule1 + ' ' + ruleOrder1;
            orderBy += (resetRule2 != '' && ruleOrder2 != '') ? ', ' + resetRule2 + ' ' + ruleOrder2 : '';
            orderBy += (resetRule3 != '' && ruleOrder3 != '') ? ', ' + resetRule3 + ' ' + ruleOrder3 : '';
            orderBy += (resetRule4 != '' && ruleOrder4 != '') ? ', ' + resetRule4 + ' ' + ruleOrder4 : '';
        }
        

        Map<String, Integer> rmLeadCount = getRMLeadCount(selectedRMId, campaignId);     

        String filterLeads = 'SELECT Id, Dist_User__c FROM Staging_Lead__c WHERE Related_Campaign__c = :campaignId AND Dist_User__c IN :selectedRMId ';
        if (!String.isEmpty(orderBy)) {
            filterLeads += ' ORDER BY ' + orderBy;
        }

        List<Staging_Lead__c> leads = Database.query(filterLeads);

        Integer leadCount = 0;
        List<Staging_Lead__c> updateLeads = new List<Staging_Lead__c>();
        if(leads.size() > 0){
            for (Staging_Lead__c lead : leads) {
                String userId = lead.Dist_User__c;
                Integer userRecordCount = rmLeadCount.get(userId);
                if (userRecordCount > maxCount  && leadCount >= maxCount) {
                    lead.Dist_User__c = null;
                    updateLeads.add(lead);
                }else{
                    lead.Reallocated__c = true;
                    updateLeads.add(lead);
                }
                leadCount++;
                
                if((userRecordCount - maxCount) == (leadCount - maxCount)){
                    leadCount = 0;
                }
            }
            
            update updateLeads;
        }

        
        String range1 = range[0];
        String range2 = range.size() > 1 ? range[1] : null;
        String range3 = range.size() > 2 ? range[2] : null;
        String range4 = range.size() > 3 ? range[3] : null;
        
        //-------------------------------------range1-------------------------------------

        List<Personnel__c> firstRangePersonnelList =  getRangePersonnel('', selectedRMId, '');
        List<Staging_Lead__c> stagingLeads = getAllStagingLead(orderBy, campaignId);
        Map<String, Integer> renewLeadCount = getRMLeadCount(selectedRMId, campaignId);    
        if(stagingLeads.size() > 0){
            List<Staging_Lead__c> updateLead = distributeLead(stagingLeads, range1, firstRangePersonnelList, selectedRMId, maxCount, renewLeadCount, orderBy, campaignId);
        }

        //-------------------------------------range2-------------------------------------  
        if(range2 != null){

            List<Staging_Lead__c> stagingLeads2 = getAllStagingLead(orderBy, campaignId);  
            Map<String, Integer> renewLeadCount2 = getRMLeadCount(selectedRMId, campaignId);           
            
            if(stagingLeads2.size() > 0){
                List<Staging_Lead__c> updateLead2 = distributeLead(stagingLeads2, range2, firstRangePersonnelList, selectedRMId, maxCount, renewLeadCount2, orderBy, campaignId);
            }


            
            
        }
            //-------------------------------------range3-------------------------------------   
        if(range3 != null){

            List<Staging_Lead__c> stagingLeads3 = getAllStagingLead(orderBy, campaignId);  
            Map<String, Integer> renewLeadCount3 = getRMLeadCount(selectedRMId, campaignId);           
            if(stagingLeads3.size() > 0){
                List<Staging_Lead__c> updateLead3 = distributeLead(stagingLeads3, range3, firstRangePersonnelList, selectedRMId, maxCount, renewLeadCount3, orderBy, campaignId);
            }
        }
        //-------------------------------------range4-------------------------------------               
        if(range4 != null){

            List<Staging_Lead__c> stagingLeads4 = getAllStagingLead(orderBy, campaignId);  
            Map<String, Integer> renewLeadCount4 = getRMLeadCount(selectedRMId, campaignId);         
            if(stagingLeads4.size() > 0){
                List<Staging_Lead__c> updateLead4 = distributeLead(stagingLeads4, range4, firstRangePersonnelList, selectedRMId, maxCount, renewLeadCount4, orderBy, campaignId);
            }
        }
        //----------------------------------outputVariables-------------------------------------------------
        List<Staging_Lead__c> toUpdateLeads = new List<Staging_Lead__c>();
        List<Staging_Lead__c> finishStagingLeads = getAllStagingLead(orderBy, campaignId); 
        if(finishStagingLeads.size() > 0){
            for(Staging_Lead__c lead : finishStagingLeads){
                if(lead.Dist_User__c == null){
                    lead.Lead_Invalid__c = true;
                    lead.Invalid_Reason__c = '重分配後剩餘';
                    lead.Reallocated__c = true;
                    toUpdateLeads.add(lead);
                }
            }
            update toUpdateLeads;
        }

        List<Personnel__c> personnelList = getRangePersonnel('', selectedRMId, '');
        Map<String, Integer> getRMLeadCount = getRMLeadCount(selectedRMId, campaignId);
        for(Personnel__c person : personnelList){
            person.dispatch_case__c = getRMLeadCount.get(person.Name__c);
        }
        update personnelList;
        List<OutputVariables> outputVariables = new List<OutputVariables>();
        OutputVariables output = new OutputVariables();
        output.personnels = personnelList;
        outputVariables.add(output); 
            
        return outputVariables;
    }

    public class OutputVariables{
        @InvocableVariable
        Public List<Personnel__c> personnels;
    }
        
    public class InputVariables{
        @InvocableVariable
        Public Id campaignId;
                
        @InvocableVariable
        Public String maxCount;

        @InvocableVariable
        Public List<Id> selectedRMId;

        @InvocableVariable
        Public List<Id> selectedRMPersonnelId;
            
        @InvocableVariable
        Public List<String> resetRule;

        @InvocableVariable
        Public List<String> ruleOrder;

        @InvocableVariable
        Public List<String> range;
    }

    public static List<Personnel__c> getRangePersonnel(String range, List<Id> selectedUserIds,String leadRange) {
        List<Personnel__c> Personnels = new List<Personnel__c>();
        String baseQuery = 'SELECT Id, Name__c, Emp_No__c, Cust_Group__c, Geo_Area__c, Unit__c, Dept__c, Prim_Corr_Branch__c, Sec_Corr_Branch__c, dispatch_case__c FROM Personnel__c WHERE Name__c IN :selectedUserIds ORDER BY dispatch_case__c';
    
        switch on range {
            when '派發大地理區' {
                baseQuery += ' AND Geo_Area__c = :leadRange';
            }
            when '派發區部' {
                baseQuery += ' AND Unit__c = :leadRange';
            }
            when '派發科別' {
                baseQuery += ' AND Dept__c = :leadRange';
            }
            when '建議派發分行' {
                baseQuery += ' AND (Prim_Corr_Branch__c = :leadRange OR Sec_Corr_Branch__c = :leadRange) ORDER BY Prim_Corr_Branch__c DESC';
            }
            when else {
                baseQuery += '';
            }
        }
    
        try {
            Personnels = Database.query(baseQuery);
        } catch(Exception e) {
            // Handle any exceptions
        }
    
        return Personnels;
    }

    public static void updateDistributeCount(Map<String, Integer> stagingLeadMap){
        List<String> personnelNames = new List<String>(stagingLeadMap.keySet());
        List<Personnel__c> personnelToUpdate = [SELECT Id, Name__c, dispatch_case__c FROM Personnel__c WHERE Name__c IN :personnelNames];
        for (Personnel__c person : personnelToUpdate) {
            Integer leadCount = stagingLeadMap.get(person.Name__c);
            person.dispatch_case__c = leadCount;
            
        }
        update personnelToUpdate;
    }
    

    public static Map<String, Integer> getRMLeadCount(List<Id> userIds, ID campaignId){
        Map<String, Integer> rmLeadCount = new Map<String, Integer>();
        for (Id userId : userIds) {
            rmLeadCount.put((String) userId, 0);
        }
        List<Staging_Lead__c> stagingLeadList = [SELECT Dist_User__c FROM Staging_Lead__c WHERE Related_Campaign__c = :campaignId AND Dist_User__c IN :userIds];
        if(stagingLeadList.size() > 0){
            for (AggregateResult result : [
                SELECT Dist_User__c, COUNT(Id) recordsCount
                FROM Staging_Lead__c
                WHERE Related_Campaign__c = :campaignId 
                AND Dist_User__c IN :userIds
                GROUP BY Dist_User__c
                ]){
                    String distUserId = (String) result.get('Dist_User__c');
                    Integer leadCount = (Integer) result.get('recordsCount');
                    rmLeadCount.put(distUserId, leadCount);

                }     
        }
        // else{
        //     for (Id userId : userIds) {
        //         rmLeadCount.put((String) userId, 0);
        //     }
        // }

        updateDistributeCount(rmLeadCount);
        return rmLeadCount;
    }

    public static String matchRange(String range){
        switch on range {
            when '派發大地理區' {
                return '派發大地理區';
            }
            when '派發區部' {
                return '派發區部';
            }
            when '派發科別' {
                return '派發科別';
            }
            when '建議派發分行' {
                return '建議派發分行';
            }
            when else {
                return '沒有range';
            }
        }
    }
    
    public static String matchLeadRange(String range, Staging_Lead__c lead){
        String selectedValue;
        switch on range {
            when '派發大地理區' {
                selectedValue = lead.Distribute_Bsn_District__c;
            }
            when '派發區部' {
                selectedValue = lead.Distribute_Division__c;
            }
            when '派發科別' {
                selectedValue = lead.Distribute_Team_Cbsm__c;
            }
            when '建議派發分行' {
            selectedValue = lead.Suggest_Disp_Branch__c;
            }
            when else {
            }
        }
        return selectedValue;
    }

    public static List<String> matchPersonnelRange(String range, Personnel__c person){
        List<String> selectedValue = new List<String>();
        switch on range {
            when '派發大地理區' {
                selectedValue.add(person.Geo_Area__c);
            }
            when '派發區部' {
                selectedValue.add(person.Unit__c);
            }
            when '派發科別' {
                selectedValue.add(person.Dept__c);
            }
            when '建議派發分行' {
                selectedValue.add(person.Prim_Corr_Branch__c);
                selectedValue.add(person.Sec_Corr_Branch__c);
            }
            when else {
            }
        }
        return selectedValue;
    }

    public static Boolean checkRMLeadCount(List<Id> selectedRMId,Integer maxCount,Map<String, Integer> rmLeadCounts){
        Boolean allRMAtMax = true;
        for (Id rmId : selectedRMId) {
            Integer leadCount = rmLeadCounts.get(rmId);
            if (leadCount == null || leadCount < maxCount) {
                allRMAtMax = false;
                break;
            }
        }
        return allRMAtMax;
    }

    public static List<Staging_Lead__c> getAllStagingLead(String orderBy, Id campaignId){
        String sortQuery = 'SELECT Id, Name, Dist_User__c, Reallocated__c, Distribute_Bsn_District__c, Distribute_Team_Cbsm__c, Distribute_Division__c, Suggest_Disp_Branch__c, Deposit_Avg__c, Total_Capital_Amt__c, Special_List_Order__c, Tier__c FROM Staging_Lead__c WHERE Related_Campaign__c = :campaignId AND Dist_User__c = null AND Lead_Invalid__c = false AND Reallocated__c = false ';
        if (!String.isEmpty(orderBy)) {
            sortQuery += ' ORDER BY ' + orderBy;
        }
        return Database.query(sortQuery);
    }


    public static List<Staging_Lead__c> distributeLead(List<Staging_Lead__c> stagingLeads, String range,List<Personnel__c> firstRangePersonnelList, List<Id> selectedRMId, Integer maxCount, Map<String,Integer> renewLeadCount, String orderBy, ID campaignId){
        Integer personIndex = -1;
        List<String> personRangeValue;
        List<Staging_Lead__c> updateLead = new List<Staging_Lead__c>();
        for(Staging_Lead__c lead : stagingLeads){
            String rangeValue = matchLeadRange(range, lead);
            
            if(!firstRangePersonnelList.isEmpty() && !checkRMLeadCount(selectedRMId, maxCount, renewLeadCount)){ 
                
                if(personIndex + 1 >= firstRangePersonnelList.size()) {
                    personIndex = 0;
                }else{
                    personIndex++;
                }

                Personnel__c currentPerson = firstRangePersonnelList[personIndex];
                while(renewLeadCount.get(currentPerson.Name__c) >= maxCount) {
                    
                    personIndex++;
                    if(personIndex >= firstRangePersonnelList.size()) {
                        personIndex = 0;
                    }
                    currentPerson = firstRangePersonnelList[personIndex];
                    if(currentPerson != null &&  renewLeadCount.get(currentPerson.Name__c) < maxCount || checkRMLeadCount(selectedRMId, maxCount,renewLeadCount)){
                        break;
                    }
                    
                    
                }
                boolean target = false;
                Integer index,loopCount = 0;
                index = personIndex;
                while(!target){
                    if(rangeValue != null){
                        personRangeValue = matchPersonnelRange(range, currentPerson);
                        if(rangeValue.equals(personRangeValue[0]) && renewLeadCount.get(currentPerson.Name__c) < maxCount){
                            
                            lead.Dist_User__c = currentPerson.Name__c;
                            lead.Reallocated__c = true;
                            Integer count = renewLeadCount.get(currentPerson.Name__c);
                            renewLeadCount.put(currentPerson.Name__c, count + 1);
                            updateLead.add(lead);
                            target = true;
                            personIndex = index;
                        }else{
                            loopCount++;
                            index++;
                            if(loopCount == firstRangePersonnelList.size()){
                                target = true;
                            }
                            if(index >= firstRangePersonnelList.size()){
                                index -= firstRangePersonnelList.size();
                            }
                            currentPerson = firstRangePersonnelList[index];
                        }
                    }else{
                        target = true;
                    }
                }
                
                
            }

        }
        update updateLead;

        if(matchRange(range).equals('建議派發分行')){
            personIndex = -1;
            Map<String, Integer> secLeadCount = getRMLeadCount(selectedRMId, campaignId);
            List<Staging_Lead__c> updateLead2 = new List<Staging_Lead__c>();
            List<Staging_Lead__c> secStagingLead = getAllStagingLead(orderBy, campaignId);
            for(Staging_Lead__c lead : secStagingLead){
                String rangeValue = matchLeadRange(range, lead);
                
                if(!firstRangePersonnelList.isEmpty() && !checkRMLeadCount(selectedRMId, maxCount, renewLeadCount)){ 
                    
                    if(personIndex + 1 >= firstRangePersonnelList.size()) {
                        personIndex = 0;
                    }else{
                        personIndex++;
                    }
    
                    Personnel__c currentPerson = firstRangePersonnelList[personIndex];
                    while(renewLeadCount.get(currentPerson.Name__c) >= maxCount) {
                        
                        personIndex++;
                        if(personIndex >= firstRangePersonnelList.size()) {
                            personIndex = 0;
                        }
                        currentPerson = firstRangePersonnelList[personIndex];
                        if(currentPerson != null &&  renewLeadCount.get(currentPerson.Name__c) < maxCount || checkRMLeadCount(selectedRMId, maxCount,renewLeadCount)){
                            break;
                        }
                        
                        
                    }
                    boolean target = false;
                    Integer index,loopCount = 0;
                    index = personIndex;
                    while(!target){
                        if(rangeValue != null){
                            currentPerson = firstRangePersonnelList[index];
                            personRangeValue = matchPersonnelRange(range, currentPerson);
                            if(rangeValue.equals(personRangeValue[1]) && renewLeadCount.get(currentPerson.Name__c) < maxCount){
                                
                                lead.Dist_User__c = currentPerson.Name__c;
                                lead.Reallocated__c = true;
                                Integer count = renewLeadCount.get(currentPerson.Name__c);
                                renewLeadCount.put(currentPerson.Name__c, count + 1);
                                updateLead2.add(lead);
                                target = true;
                                personIndex = index;
                            }else{
                                loopCount++;
                                index++;
                                if(loopCount == firstRangePersonnelList.size()){
                                    target = true;
                                }
                                if(index >= firstRangePersonnelList.size()){
                                    index -= firstRangePersonnelList.size();
                                }
                                currentPerson = firstRangePersonnelList[index];
                            }
                        }else{
                            target = true;
                        }
                    }
                    
                    
                }
    
            }
            update updateLead2;
        }
        return updateLead;
    }
}