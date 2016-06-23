
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import dbconnectionlib.Dbconnection;
import dbconnectionlib.User;
/**
 * Servlet implementation class login
 */
@WebServlet(name="login", urlPatterns = { "/login" })
public class login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public login() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Servlet#init(ServletConfig)
	 */

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("doGet");
		this.doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		//RequestDispatcher rd = getServletContext().getRequestDispatcher("/homepage.jsp");
		System.out.println("doPost");  
        System.out.println("用户名 : "+request.getParameter("username"));  
        System.out.println("密码: "+request.getParameter("password"));  

        String userName = request.getParameter("username");
        String passWord = request.getParameter("password");
        String errorMessage = null;
        if (userName.equals("")||userName==null) {
			errorMessage="userName is empty";
		}
		if (passWord.equals("")||passWord==null) {
			errorMessage="password is empty";
		}
		if (errorMessage!=null) {
			
			RequestDispatcher rd = getServletContext().getRequestDispatcher("/login.jsp");
            PrintWriter out= response.getWriter();
            out.println("<font color=red>"+errorMessage+"</font>");
            rd.include(request, response);
			
		}
		else {
			
			Dbconnection db=null;
			try {
				db = new Dbconnection();
			} catch (ClassNotFoundException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			Connection con = db.getConnection();
			
			if (con==null) {
				System.out.println("it's closed!");
			}
			else{
				System.out.println("successful");
			}
			
			PreparedStatement ps = null;
			ResultSet rs =null;
			try {
				
				ps=con.prepareStatement("select * from sys.userlist where username=? and password=? limit 1");
				ps.setString(1, userName);
				ps.setString(2, passWord);
				rs = ps.executeQuery();
				
				if (rs!=null&&rs.next()) {
					//User u = new User();
					User u = new User(rs.getString("username"),rs.getInt("id"),rs.getInt("auth"));
					log(u.toString());
					HttpSession session = request.getSession();
					session.setAttribute("User",u);
					int id = rs.getInt("id");
        		//response.sendRedirect("http://localhost:8080/JavaEE/index.jsp");
				response.sendRedirect("http://localhost:8080/HomeServer/homepage.jsp");	
					
				} else {
					RequestDispatcher rd = getServletContext().getRequestDispatcher("/homepage.jsp");
	                PrintWriter out= response.getWriter();
	                out.println("<font color=red>User name and password didn't match,please try again. </font>");
	                out.println("<p>Don't have an account? Register here:<a href=\"http://localhost:8080/HomeServer/page1.jsp\">click me</a></p>");
	                rd.include(request, response);
				}
				} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally{
				try {
					rs.close();
					ps.close();
					System.out.println("db closed");
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
			

		}
	}





























}
