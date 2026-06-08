public with sharing class AgreementAPICheck {
    public String id{get;set;}
    public AgreementAPICheck() {
		id = ApexPages.currentPage().getParameters().get('id');
    }

	public class Signer_position {
		public String appearance;
	}

	public class Signers_info {
		public String document_to_be_signed;
		public Signer_position signer_position;
		public String signer_ref_id;
		public String signer_email;
		public String signer_name;
		public String sequence;
		public String page_number;
		public String esign_type;
		public String signer_mobile;
		public Signer_validation_inputs signer_validation_inputs;
		public String signature_type;
		public String access_type;
	}

	public class Documents {
		public String reference_doc_id;
		public String content_type;
		public String content;
		public String signature_sequence;
	}

	public class Signer_validation_inputs {
		public String year_of_birth;
		public String gender;
		public String name_as_per_aadhaar;
	}

	public class Widget_configuration {
		public String widget_title;
		public String background_color;
		public String button_color;
		public String button_font_color;
		public String font_family;
		public String esign_with_otp_button_text;
		public String esign_with_biometric_button_text;
		public String user_instruction;
		public String remark_field_label;
		public String usb_signature_title;
	}

	public class ESignRequest_API {
		public String reference_id;
		public String docket_title;
		public String remarks;
		public String enable_email_notification;
		public List<Documents> documents;
		public List<Signers_info> signers_info;
		public Widget_configuration widget_configuration;
	}

	
	public static ESignRequest_API parse(String json) {
		return (ESignRequest_API ) System.JSON.deserialize(json, ESignRequest_API.class);
	}


    public PageReference Cancel() {
        
        PageReference pageRef = new PageReference('/' + id);
        pageRef.setRedirect(true);
        return pageRef;      
    } 
}