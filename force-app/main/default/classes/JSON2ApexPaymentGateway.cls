public class JSON2ApexPaymentGateway {

	public class RPPRequired {
		public String Token;
		public Integer UniqueID;
		public String Hashcode;
		public String RequestType;
		public String TxnType;
		public Object MerchantMID;
		public Integer MerchantID;
		public String MerchantName;
		public String MerchantEmailMobile;
		public Object Aspid;
		public Integer AspMasterID;
		public Object ChannelName;
		public Object ChannelTypeName;
		public Object IPAddress;
	}

	public class RPPData {
		public String CustomerName;
		public String CustomerEmailMobile;
		public String CustomerAlternateEmailMobile;
		public Double Amount;
		public String NoteFromMerchant;
		public String InvoiceNo;
		public String DistributerIdentifier;
		public Object AgentName;
		public String AgentMobileNo;
		public String CustomerIdentifier;
		public String ProductIdentifier;
		public String CartDetails;
		public Object InvoiceAmount;
		public Object InvoiceDiscountAmount;
		public Object InvoiceSurchargeAmount;
		public Boolean AutoDebit;
		public Object AccountHolderName;
		public Object StartDate;
		public Object EndDate;
		public Object MaxAmount;
		public Object Frequency;
		public Object AmountType;
		public Object AccountType;
		public Object BillDate;
		public Object ConsumerCD;
		public Object IFSCCode;
		public Object BankCode;
		public Object AccountNo;
		public Object ResendNotificationFlag;
		public String RequestID;
		public Object MerchantTXNID;
		public String ImageName;
		public String Image;
		public Object NotificationTemplateName;
		public String TranStatusDescription;
		public String additionalParameter1;
		public String additionalParameter2;
		public String additionalParameter3;
		public String additionalParameter4;
		public String additionalParameter5;
	}

	public class RPPResponse {
		public String ErrorCode;
		public String ErrorDescription;
		public String URLtoPay;
	}

	public RPPRequired RPPRequired;
	public RPPResponse RPPResponse;
	public List<RPPData> RPPData;

	
	public static JSON2ApexPaymentGateway parse(String json) {
		return (JSON2ApexPaymentGateway) System.JSON.deserialize(json, JSON2ApexPaymentGateway.class);
	}
}