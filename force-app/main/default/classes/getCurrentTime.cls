public with sharing class getCurrentTime {
     
    public static Datetime  getTime(Datetime timeNow){
        string[] iTime = new string[]{'3','9','15','21'};
        Datetime tempCheck = timeNow;
        Datetime beforeTime = null;
        integer hr = tempCheck.hour();
        system.debug('current hour'+hr);
        system.debug('current tempCheck'+tempCheck);

        for(Integer i =0; i< iTime.size(); i++){
            switch on Integer.valueOf(iTime[i]) {
               when 3 {
                    if(hr < 3){
                        beforeTime = Datetime.newInstance(System.today().year(), System.today().month(),System.today().day()-1,21,0, 0);
                        break;
                    }
                }	
                when 9 {
                    if(hr < 9){
                        beforeTime = Datetime.newInstance(System.today().year(), System.today().month(),System.today().day(),3,0, 0);
                        break;
                    }
                }
                when 15 {
                    if(hr < 15){
                        beforeTime = Datetime.newInstance(System.today().year(), System.today().month(),System.today().day(),9,0, 0);
                        break;
                    }
                }
                when 21 {
                    if(hr < 21){
                        beforeTime = Datetime.newInstance(System.today().year(), System.today().month(),System.today().day(),15,0, 0);
                        break;
                        
                    }else  if(hr >= 21) {
                        beforeTime = Datetime.newInstance(System.today().year(), System.today().month(),System.today().day(),21,0, 0);
                    }
                    
                } 
                
            }
        }
        
        string str = ' Data Before '+beforeTime.format()+' current time '+tempCheck.format();
        return beforeTime;
    }

}