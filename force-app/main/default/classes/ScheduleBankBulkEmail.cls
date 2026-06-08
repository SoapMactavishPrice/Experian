global class ScheduleBankBulkEmail implements schedulable
{
    global void execute(SchedulableContext sc)
    {
    ScheduleCaseForEmail sch = new ScheduleCaseForEmail(); //ur batch class
      database.executebatch(sch,50);
    }
}