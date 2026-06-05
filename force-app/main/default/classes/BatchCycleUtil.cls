public class BatchCycleUtil {

    public static Datetime getCycleCutoff() {

        Datetime nowDT = System.now();
        Integer hour = nowDT.hour();
        Date today = Date.today();

        List<Integer> cycleHours = new List<Integer>{2,6,10,14,18,22};

        Integer selectedHour;

        // Find LAST completed cycle
        for(Integer i = cycleHours.size()-1; i >= 0; i--){
            if(hour >= cycleHours[i]){
                selectedHour = cycleHours[i];
                break;
            }
        }

        // If before 2 AM → use yesterday 10 PM which is between 00:00 to 01:59 am
        if(selectedHour == null){
            selectedHour = 22;
            today = today.addDays(-1);
        }

        return Datetime.newInstance(today, Time.newInstance(selectedHour, 0, 0, 0));
    }

    public static Datetime getStartTime(Datetime cutoff){
        return Datetime.newInstance(
            cutoff.date().addDays(-1),
            Time.newInstance(0,0,0,0)
        );
    }
}