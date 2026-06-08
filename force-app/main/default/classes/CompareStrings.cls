public class CompareStrings {
    
    private final String str1;
    private final String str2;
    private final Boolean isCaseSensiveOrNot;
    private final String compareCharOrWord;
    
    public CompareStrings(String str1, String str2) {
        this.str1 = str1.trim();
        this.str2 = str2.trim();
        this.isCaseSensiveOrNot = false;
        this.compareCharOrWord = 'Char';
    }
    
    public CompareStrings(String str1, String str2, Boolean isCaseSensiveOrNot) {
        this.str1 = str1.trim();
        this.str2 = str2.trim();
        this.isCaseSensiveOrNot = isCaseSensiveOrNot;
    }
    
    public CompareStrings(String str1, String str2, String compareCharOrWord) {
        this.str1 = str1.trim();
        this.str2 = str2.trim();
        this.compareCharOrWord = compareCharOrWord;
    }
    
    public CompareStrings(String str1, String str2, Boolean isCaseSensiveOrNot, String compareCharOrWord) {
        this.str1 = str1.trim();
        this.str2 = str2.trim();
        this.isCaseSensiveOrNot = isCaseSensiveOrNot;
        this.compareCharOrWord = compareCharOrWord;
    }
    
    public Decimal compare() {
        if(isCaseSensiveOrNot) {
            if(compareCharOrWord == 'Word') {
                return compareWordWise(str1, str2);
            } else {
                return CompareCharWise(str1, str2);
            }
        } else {
            if(compareCharOrWord == 'Word') {
                return compareWordWise(str1.toLowerCase(), str2.toLowerCase());
            } else {
                return compareCharWise(str1.toLowerCase(), str2.toLowerCase());
            }
        }
    }
    
    private Decimal compareCharWise(String str1, String str2) {
        Integer str1Len = str1.length();
        Integer str2Len = str2.length();
        
        Decimal percentage = 0;
        Decimal percenStep;
        Integer lmt = 0;
        
        if(str1Len < str2Len) {
            percenStep = 100 / str2Len;
            lmt = str1Len;
        }
        else if(str1Len >= str2Len) {
            percenStep = 100 / str1Len;
            lmt = str2Len;
        }
        
        for(Integer i = 0; i < lmt; i++) {
            if(str1.charAt(i) == str2.charAt(i)) {
                percentage += percenStep;
            }
        }
        return percentage;
    }
    
    public Decimal compareWordWise(String str1, String str2) {
        List<String> str1Words = str1.split('[^A-Za-z0-9]');
        List<String> str2Words = str2.split('[^A-Za-z0-9]');
        
        Decimal percentage = 0;
        Decimal percenStep;
        Integer lmt = 0;
        
        if(str1Words.size() < str2Words.size()) {
            percenStep = 100 / str2Words.size();
            lmt = str1Words.size();
        }
        else if(str1Words.size() >= str2Words.size()) {
            percenStep = 100 / str1Words.size();
            lmt = str2Words.size();
        }
        
        for(Integer i = 0; i < lmt; i++) {
            if(str1Words[i] == str2Words[i]) {
                percentage += percenStep;
            }
        }
        return percentage;
    }
}

/*
String str1 = 'Thank you for your response ack:1234567890';
List<String> str1Words = str1.split('[^A-Za-z0-9]');
System.debug(str1Words);

String str2 = 'Thank you for your response ack:0987654321';

System.debug('Compared -> '+new CompareStrings(str1, str2).compare()+'%');
System.debug('Compared -> '+new CompareStrings(str1, str2, true).compare()+'%');
System.debug('Compared -> '+new CompareStrings(str1, str2, false).compare()+'%');
System.debug('Compared -> '+new CompareStrings(str1, str2, true, 'Word').compare()+'%');
System.debug('Compared -> '+new CompareStrings(str1, str2, false, 'Word').compare()+'%');
*/