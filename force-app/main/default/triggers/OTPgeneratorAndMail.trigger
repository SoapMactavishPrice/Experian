trigger OTPgeneratorAndMail on Lead (after insert) {
    String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
	Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
	String hexDigest = EncodingUtil.convertToHex(hash);
	system.debug('########## hexDigest--> ' + hexDigest );
}