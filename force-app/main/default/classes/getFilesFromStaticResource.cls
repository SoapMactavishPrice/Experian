public class getFilesFromStaticResource {
    
    public static List<Messaging.EmailFileAttachment> getFiles(){
        
        List<Messaging.EmailFileAttachment> emcclist = new List<Messaging.EmailFileAttachment>();
        
        List<string> fileName = new List<string>();
        //fileName.add('OLM_Suppression_Demographic_Correction');
        //fileName.add('Data_Correction_Formats');
        
        fileName.add('How_to_get_ERN_or_CIR_Number_of_Experian');
        fileName.add('Annexure_4_OLM_Commercial_Format'); 
        fileName.add('ECICI_SOP_Circular_72_and_73');
        fileName.add('Annexure_2_Columns_to_be_ensured_in_response_sheet'); 
        fileName.add('Annexure_1_Complaint_Reject_Reason');
        fileName.add('Annexure_3_OLM_Consumer_Format'); 
        
        list<StaticResource> objPDFList = [Select body,ContentType, name from StaticResource where name IN: fileName];
        
        for(StaticResource objPDF:objPDFList){
            
            Messaging.EmailFileAttachment objPDFAttachment = new Messaging.EmailFileAttachment();
            
            /* if(objPDF.name =='OLM_Suppression_Demographic_Correction'){
objPDFAttachment.setBody(objPDF.Body);
objPDFAttachment.setFileName(objPDF.name + '.pdf');
emcclist.add(objPDFAttachment);
}else if(objPDF.name =='Data_Correction_Formats'){
objPDFAttachment.setBody(objPDF.Body);
objPDFAttachment.setFileName(objPDF.name + '.xlsb');
emcclist.add(objPDFAttachment);
} */
            if(objPDF.name =='How_to_get_ERN_or_CIR_Number_of_Experian'){
                objPDFAttachment.setBody(objPDF.Body);
                objPDFAttachment.setFileName(objPDF.name + '.png');
                emcclist.add(objPDFAttachment);
            }else if(objPDF.name =='Annexure_4_OLM_Commercial_Format'){
                objPDFAttachment.setBody(objPDF.Body);
                objPDFAttachment.setFileName(objPDF.name + '.xlsx');
                emcclist.add(objPDFAttachment);
            }else if(objPDF.name =='ECICI_SOP_Circular_72_and_73'){
                objPDFAttachment.setBody(objPDF.Body);
                objPDFAttachment.setFileName(objPDF.name + '.pdf');
                emcclist.add(objPDFAttachment);
            }else if(objPDF.name =='Annexure_2_Columns_to_be_ensured_in_response_sheet'){
                objPDFAttachment.setBody(objPDF.Body);
                objPDFAttachment.setFileName(objPDF.name + '.xlsx');
                emcclist.add(objPDFAttachment);
            }else if(objPDF.name =='Annexure_1_Complaint_Reject_Reason'){
                objPDFAttachment.setBody(objPDF.Body);
                objPDFAttachment.setFileName(objPDF.name + '.xlsx');
                emcclist.add(objPDFAttachment);
            }else if(objPDF.name =='Annexure_3_OLM_Consumer_Format'){
                objPDFAttachment.setBody(objPDF.Body);
                objPDFAttachment.setFileName(objPDF.name + '.xlsx');
                emcclist.add(objPDFAttachment);
            }
        }
        return emcclist;
    }
    
    public static List<Messaging.EmailFileAttachment> getFilesv2(){
        
        List<Messaging.EmailFileAttachment> emcclist = new List<Messaging.EmailFileAttachment>();
        
        List<string> fileName = new List<string>();
        //fileName.add('OLM_Suppression_Demographic_Correction');
        //fileName.add('Data_Correction_Formats');
        
        fileName.add('OLM_Consumer_Format1');
        fileName.add('OLM_Guide_V1_0_Mar_2024'); 
        fileName.add('ECICI_SOP_Circular_72_73');
        fileName.add('Complaint_Reject_Reason'); 
        fileName.add('Columns_to_be_added_in_reponse_sheet');
        
        list<StaticResource> objPDFList = [Select body,ContentType, name from StaticResource where name IN: fileName];
        
        for(StaticResource objPDF:objPDFList){
            
            Messaging.EmailFileAttachment objPDFAttachment = new Messaging.EmailFileAttachment();
            
            if(objPDF.name =='OLM_Consumer_Format1'){
                objPDFAttachment.setBody(objPDF.Body);
                objPDFAttachment.setFileName(objPDF.name + '.xlsb');
                emcclist.add(objPDFAttachment);
            }else if(objPDF.name =='OLM_Guide_V1_0_Mar_2024'){
                objPDFAttachment.setBody(objPDF.Body);
                objPDFAttachment.setFileName(objPDF.name + '.docx');
                emcclist.add(objPDFAttachment);
            }else if(objPDF.name =='ECICI_SOP_Circular_72_73'){
                objPDFAttachment.setBody(objPDF.Body);
                objPDFAttachment.setFileName(objPDF.name + '.docx');
                emcclist.add(objPDFAttachment);
            }else if(objPDF.name =='Complaint_Reject_Reason'){
                objPDFAttachment.setBody(objPDF.Body);
                objPDFAttachment.setFileName(objPDF.name + '.xlsx');
                emcclist.add(objPDFAttachment);
            }else if(objPDF.name =='Columns_to_be_added_in_reponse_sheet'){
                objPDFAttachment.setBody(objPDF.Body);
                objPDFAttachment.setFileName(objPDF.name + '.xlsx');
                emcclist.add(objPDFAttachment);
            }
        }
        return emcclist;
    }
}