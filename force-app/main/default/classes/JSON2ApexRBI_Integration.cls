public class JSON2ApexRBI_Integration {
    public Essentials essentials {get;set;} 
	public String id {get;set;} 
	public String patronId {get;set;} 
	public String task {get;set;} 
	public Result result {get;set;} 

	public JSON2ApexRBI_Integration(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'essentials') {
						essentials = new Essentials(parser);
					} else if (text == 'id') {
						id = parser.getText();
					} else if (text == 'patronId') {
						patronId = parser.getText();
					} else if (text == 'task') {
						task = parser.getText();
					} else if (text == 'result') {
						result = new Result(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2ApexRBI_Integration consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class NbfcBlacklisted {

		public NbfcBlacklisted(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'NbfcBlacklisted consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Essentials {
		public String name {get;set;} 
		public String type_Z {get;set;} // in json: type
		public String matchScoreThreshold {get;set;} 
		public String identificationNumber {get;set;} 
		public String dateOfBirthOrIncorporation {get;set;} 
		public String zipcode {get;set;} 
		public String country {get;set;} 
		public List<String> category {get;set;} 
		public List<String> databaseList {get;set;} 
		public List<String> searchText {get;set;} 
		public List<String> aliasArray {get;set;} 

		public Essentials(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'type') {
							type_Z = parser.getText();
						} else if (text == 'matchScoreThreshold') {
							matchScoreThreshold = parser.getText();
						} else if (text == 'identificationNumber') {
							identificationNumber = parser.getText();
						} else if (text == 'dateOfBirthOrIncorporation') {
							dateOfBirthOrIncorporation = parser.getText();
						} else if (text == 'zipcode') {
							zipcode = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'category') {
							category = arrayOfString(parser);
						} else if (text == 'databaseList') {
							databaseList = arrayOfString(parser);
						} else if (text == 'searchText') {
							searchText = arrayOfString(parser);
						} else if (text == 'aliasArray') {
							aliasArray = arrayOfString(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Essentials consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Result {
		public List<NbfcBlacklisted> nbfcBlacklisted {get;set;} 

		public Result(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'nbfcBlacklisted') {
							nbfcBlacklisted = arrayOfNbfcBlacklisted(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Result consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static JSON2ApexRBI_Integration parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new JSON2ApexRBI_Integration(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	


    private static List<NbfcBlacklisted> arrayOfNbfcBlacklisted(System.JSONParser p) {
        List<NbfcBlacklisted> res = new List<NbfcBlacklisted>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new NbfcBlacklisted(p));
        }
        return res;
    }


    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }


}