package dbconnectionlib;
import java.sql.*;

public class Dbconnection {

	private Connection connection;
	
	public Dbconnection() throws ClassNotFoundException, SQLException{
		
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			System.out.println("Driver found");
			
		} catch (ClassNotFoundException e) {
			System.out.println("Driver not found " + e);
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		//String DB="jdbc:mysql://localhost:3306/HomeServer?user=root&password=1234";
		connection = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/sys","root","1234");
	
	}
	
	public  Connection getConnection() {
		return this.connection;
	}
}