@isTest
public class getCurrentTimeTest {
    
    @isTest
    public static void validate(){
        Datetime todayAt12AM = Datetime.newInstance(System.today().year(), System.today().month(),System.today().day(),5,0, 0);
          getCurrentTime.getTime(todayAt12AM);
        todayAt12AM = Datetime.newInstance(System.today().year(), System.today().month(),System.today().day(),11,0, 0);
          getCurrentTime.getTime(todayAt12AM);
        todayAt12AM = Datetime.newInstance(System.today().year(), System.today().month(),System.today().day(),16,0, 0);
          getCurrentTime.getTime(todayAt12AM);
        todayAt12AM = Datetime.newInstance(System.today().year(), System.today().month(),System.today().day(),1,0, 0);
          getCurrentTime.getTime(todayAt12AM);
        todayAt12AM = Datetime.newInstance(System.today().year(), System.today().month(),System.today().day(),22,0, 0);
          getCurrentTime.getTime(todayAt12AM);
    }
        

}