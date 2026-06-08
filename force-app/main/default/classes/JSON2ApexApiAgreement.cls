public class JSON2ApexApiAgreement {

    
                public String status {get;set;}

                public String reference_id {get;set;}

                public String content {get;set;}

 

                public JSON2ApexAPiAgreement(JSONParser parser) {

                                while (parser.nextToken() != System.JSONToken.END_OBJECT) {

                                                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {

                                                                String text = parser.getText();

                                                                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {

                                                                                if (text == 'status') {

                                                                                                status = parser.getText();

                                                                                } else if (text == 'reference_id') {

                                                                                                reference_id = parser.getText();

                                                                                } else if (text == 'content') {

                                                                                                content = parser.getText();

                                                                                } else {

                                                                                                System.debug(LoggingLevel.WARN, 'JSON2ApexAPiAgreement consuming unrecognized property: '+text);

                                                                                                consumeObject(parser);

                                                                                }

                                                                }

                                                }

                                }

                }

               

               

                public static JSON2ApexAPiAgreement parse(String json) {

                                System.JSONParser parser = System.JSON.createParser(json);

                                return new JSON2ApexAPiAgreement(parser);

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
}