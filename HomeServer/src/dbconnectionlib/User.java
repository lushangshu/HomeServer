package dbconnectionlib;
import java.io.Serializable;

public class User implements Serializable{
	
	private static final long serialVersionUID = 1L;
	private String username=null;
	private int id;
	private int auth;
	
	public User(String username,int id,int auth){
		this.username=username;
		this.id=id;
		this.auth=auth;
	}
	
	public void setUserName(String userName) {
		this.username=username;
	}
	
	public String getUserName(){
		return this.username;
	}
	
	public void setId(int newId) {
		this.id=newId;
	}
	
	public int getId() {
		return this.id;
	}
	
	public void setAuth(int newRole) {
		this.auth=newRole;
	}
	
	public int getauth() {
		return this.auth;
	}
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		String result = "User: "+this.username+"Auth: "+this.auth;
		return result;
	}
}	
