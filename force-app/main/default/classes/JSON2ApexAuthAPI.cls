public class JSON2ApexAuthAPI {

	public String id;
	public Integer ttl;
	public String created;
	public String userId;


	
	public static JSON2ApexAuthAPI parse(String json) {
		return (JSON2ApexAuthAPI) System.JSON.deserialize(json, JSON2ApexAuthAPI.class);
	}
    
}