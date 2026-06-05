@isTest
public class CompareStrings_Test {
    @isTest
    public static void comparewords(){
        String str1 = 'Thank you for your response ack:1234567890';
        List<String> str1Words = str1.split('[^A-Za-z0-9]');
        System.debug(str1Words);
        
        String str2 = 'Thank you for your response acknowledge:0987654321';
        
        System.debug('Compared -> '+new CompareStrings(str1, str2).compare()+'%');
        System.debug('Compared -> '+new CompareStrings(str1, str2, true).compare()+'%');
        System.debug('Compared -> '+new CompareStrings(str1, str2, false).compare()+'%');
        System.debug('Compared Word-> '+new CompareStrings(str1, str2, true, 'Word').compare()+'%');
        System.debug('Compared Word -> '+new CompareStrings(str1, str2, false, 'Word').compare()+'%');
        
      //  CompareStrings cs = new CompareStrings();
    }
}