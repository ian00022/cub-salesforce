public class InverseAARCreationAction {
    @InvocableMethod(label='creation inverse AAR' description='creation inverse AAR ')
    public static List<Results> creationInverseAAR(List<Requests> requestList) {
        List<Results> results = new List<Results>();
        for (Requests request : requestList) {
            List<SObject> inputCollection = request.inputCollection;
            SObject outputMember = inputCollection[0];
            
            //Create a Results object to hold the return values
            Results result = new Results();
            
            //Add the return values to the Results object
            result.outputMember = outputMember;
            
            //Add Result to the results List at the same position as the request is in the requests List
            results.add(result);
        }
        return results;
    }
    
    public class Requests {
        @InvocableVariable(label='Records for Input' description='yourDescription' required=true)
        public List<SObject> inputCollection;
    }
    
    public class Results {
        @InvocableVariable(label='Records for Output' description='yourDescription' required=true)
        public SObject outputMember;
    }
}