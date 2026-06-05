public class DeleteControlUtil {
    
    public static Boolean allowDelete(){
        if(Test.isRunningTest()){
            return false; // force block in test
        }
        return System.Label.Allow_Delete == 'true';
    }
}