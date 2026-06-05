public class MyClass {

    /*@InvocableMethod
    public static void mmethod(List<String> LeadIds){

        System.debug('STARTED PROCESS BUILDER MY CLASS OTP GENERATION');

        System.debug('LeadIds'+ LeadIds);
        
        // String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        // Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        // String hexDigest = EncodingUtil.convertToHex(hash);

        final integer STRING_LENGTH = 4;
        String aleaNumberN = String.valueOf(Math.Round(Math.Random() * ((Math.pow(10,STRING_LENGTH) - 1)-Math.pow(10,STRING_LENGTH -1)) + Math.pow(10,STRING_LENGTH -1)));

        
        System.debug('GENERATED PROCESS BUILDER MY CLASS OTP GENERATION');
        system.debug('##########' + aleaNumberN );
        //added by shashank to put encryption on otp
        Blob cryptoKey = Crypto.generateAesKey(128);
        // Generate the data to be encrypted.
         Blob data = Blob.valueOf(aleaNumberN);
        // Encrypt the data and have Salesforce.com generate the initialization vector
        Blob encryptedData = Crypto.generateDigest('MD5', data);
		String otpEnc=EncodingUtil.convertToHex(encryptedData);
        try {
            Lead Ld = [SELECT Id,OTP__c,Name,Email FROM Lead WHERE Id =: LeadIds ];
            System.debug('LD'+ Ld);
           // Ld.OTP__c = aleaNumberN;
            Ld.OTP__c = otpEnc;
            
            update Ld;
            System.debug('Updated LD'+ Ld);
            List<Messaging.Email> allMails = new List<Messaging.Email>();
            if(string.isNotBlank(ld.Email)){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] {ld.Email};
                message.subject = 'Experian MemberOnboarding OTP verification';
                string emailbody ='';
                emailbody+='Dear '+ld.Name+',</br></br>';
                emailbody+='Your OTP for completing the verification is : '+aleaNumberN+'</br></br>';
                emailbody+='Thanks & Regards,</br>';
                emailbody+='Experian Customer support</br>';
                message.htmlbody = emailbody;
                message.setUseSignature(false);
                allMails.add(message);
                List<Messaging.sendEmailResult> results = Messaging.sendEmail(allMails);
                
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: '
                                 + results[0].errors[0].message);
                }

            }
            

        } catch (Exception e) {
            System.debug('EXCEPTION IN');

        }
    }
*/
    @InvocableMethod
    public static void mmethod(List<String> LeadIds){

        System.debug('STARTED PROCESS BUILDER MY CLASS OTP GENERATION');

        System.debug('LeadIds'+ LeadIds);
        
        // String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        // Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        // String hexDigest = EncodingUtil.convertToHex(hash);

        final integer STRING_LENGTH = 4;
        String aleaNumberN = String.valueOf(Math.Round(Math.Random() * ((Math.pow(10,STRING_LENGTH) - 1)-Math.pow(10,STRING_LENGTH -1)) + Math.pow(10,STRING_LENGTH -1)));

        
        System.debug('GENERATED PROCESS BUILDER MY CLASS OTP GENERATION');
        system.debug('##########' + aleaNumberN );
        //added by shashank to put encryption on otp
        Blob cryptoKey = Crypto.generateAesKey(128);
        // Generate the data to be encrypted.
         Blob data = Blob.valueOf(aleaNumberN);
        // Encrypt the data and have Salesforce.com generate the initialization vector
        Blob encryptedData = Crypto.generateDigest('MD5', data);
		String otpEnc=EncodingUtil.convertToHex(encryptedData);
        try {
            Lead Ld = [SELECT Id,OTP__c,Resend_OTP__c,Name,Email FROM Lead WHERE Id =: LeadIds ];
            System.debug('LD'+ Ld);
           // Ld.OTP__c = aleaNumberN;
            Ld.Resend_OTP__c = false;
            Ld.OTP__c = otpEnc;
            
            update Ld;
            System.debug('Updated LD'+ Ld);
            List<Messaging.Email> allMails = new List<Messaging.Email>();
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'consumer.support@in.experian.com'];// To send from Org wide address

            if(string.isNotBlank(ld.Email)){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] {ld.Email};
                message.subject = 'Experian OTP verification';
                string emailbody ='';
                emailbody+='Dear '+ld.Name+',</br></br>';
                emailbody+='Your OTP for completing the verification is : '+aleaNumberN+'</br></br>';
                emailbody+='Thanks & Regards,</br>';
                emailbody+='Experian Customer support</br>';
                message.htmlbody = emailbody;
                if ( owea.size() > 0 ) {
                        message.setOrgWideEmailAddressId(owea.get(0).Id);
                 }
                message.setUseSignature(false);
                allMails.add(message);
                List<Messaging.sendEmailResult> results = Messaging.sendEmail(allMails);
                
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: '
                                 + results[0].errors[0].message);
                }

            }
            

        } catch (Exception e) {
            System.debug('EXCEPTION IN'+e.getMessage() +'line'+e.getLineNumber());

        }
    }

}