import java.sql.*;
import java.util.Scanner;
import java.io.*;

public class Assignment2 {
	// A connection to the database.
	// This variable is kept public.
	public Connection connection;
	
	// Statement to run queries
    public Statement sql;

    //Prepared Statement
    public PreparedStatement ps;

    //Resultset for the query
    public ResultSet rs;
    


	/*
	 * Constructor for Assignment2. Identifies the PostgreSQL driver using
	 * Class.forName() method.
	 */
	public Assignment2() {
	  try {
	      // Load JDBC driver
	      Class.forName("org.postgresql.Driver");

	  } catch (ClassNotFoundException e) {
	      //Failed to load the JDBC driver
	      System.out.println("Error, could  not load the driver");
	      e.printStackTrace();
	      return;
	  }
	}

	/*
	 * Using the String input parameters which are the URL, username, and
	 * password, establish the connection to be used for this object instance.
	 * If a connection already exists, it will be closed. Return true if a new
	 * connection instance was successfully established.
	 */
	public boolean connectDB(String URL, String username, String password) throws SQLException {
	  boolean successful = false;
	  if (this.connection != null) disconnectDB();
	  try {
         this.connection = DriverManager.getConnection(URL, username, password);
         successful = true;
     } catch (SQLException e) {
         System.out.println("Error, could not connect to the db");
         e.printStackTrace();
     }

	//////////////////////------------------------------------- Remove me before submission \/
	try{
			//Create a Statement for executing SQL queries
			sql = connection.createStatement(); 
			String sqlQ;


			// Open the DDL file
			FileInputStream fstream = new FileInputStream("a2DDL.sql");
			BufferedReader br = new BufferedReader(new InputStreamReader(fstream));
			String strLine;
			while ((strLine = br.readLine()) != null)   {
				sql.executeUpdate(strLine);
			}
			fstream.close();

			// Open the DATA file
			fstream = new FileInputStream("a2DATA.sql");
			br = new BufferedReader(new InputStreamReader(fstream));
			while ((strLine = br.readLine()) != null)   {
				sql.executeUpdate(strLine);
			}
			fstream.close();
	} catch (Exception e) {
		System.out.println("Error, could not connect to the db");
        e.printStackTrace();
	}
	//////////////////////------------------------------------- Remove me before submission /\


	 return successful;
	}

	/*
	 * Closes the connection in this object instance. Returns true if the
	 * closure was successful. Returns false if this object instance previously
	 * had no active connections.
	 */
	public boolean disconnectDB() {
		boolean successful = false;
		if (connection != null) {
			try  {
				this.connection.close();
			  } catch (SQLException e) {
				System.out.println("Error, could not close db connection");
				return false;
			  }
		}
		return true;
	}

	/*
	 * Inserts a row into the student table.
	 * 
	 * dcodeis the code of the department.
	 * 
	 * Inputs and constraints must be validated.
	 * 
	 * You must check if the department exists, if the sex is one of the two
	 * values ('M' or 'F'), and if the year of study is a valid number ( > 0 &&
	 * < 6 ). Returns true if the insertion was successful, false otherwise.
	 */
	public boolean insertStudent(int sid, String lastName, String firstName,
			String sex, int age, String dcode, int yearOfStudy) {
	  if (!isStudentAttrValid(dcode, sex, yearOfStudy)) return false;
	  
	   String sqlQ = "INSERT INTO student VALUES (?,?,?,?,?,?,?)";
	   PreparedStatement st = null;
	   
	   try {
	     st = connection.prepareStatement(sqlQ);
	     st.setInt(1, sid);
	     st.setNString(2, lastName);
	     st.setNString(3, firstName);
	     st.setNString(4, sex);
	     st.setInt(5, age);
	     st.setNString(6, dcode);
	     st.setInt(7, yearOfStudy);
	     st.executeUpdate();
	   } catch(SQLException e) {
	     System.out.println(e.getMessage());
	     return false;
	   }
	   return true;
	}
	
	private boolean isStudentAttrValid(String dcode, String sex, int yearOfStudy) {
	  String sqlQ = "SELECT dcode FROM department", dcodeInDB = "";
      PreparedStatement st = null;
      ResultSet result = null;
      
	  try {
	    st = connection.prepareStatement(sqlQ);
	    result = st.executeQuery();
	    while(result.next()) {
	      String curr = result.getString("dcode");
	      if (curr.equals(dcode)) dcodeInDB = curr;
	    }
	  } catch(SQLException e) {
	    System.out.println(e.getMessage());
	    return false;
	  }
	  return dcodeInDB.equals(dcode) && (sex.equals("M") || sex.equals("F")) && 
	      yearOfStudy > 0 && yearOfStudy < 6;
	}

	/*
	 * Returns the number of students in department dname. Returns -1 if the
	 * department does not exist.
	 */
	public int getStudentsCount(String dname) {
        int answer = 0;
        PreparedStatement st=null;
        ResultSet result = null;
        String query = "";
        
		try {
			query = "SELECT count(sid) FROM student, department WHERE student.dcode = department.dcode AND department.dname=?";
	   		st = connection.prepareStatement(query);
	   		st.setString(1, dname);		
	   		result = st.executeQuery();
	   		while(result.next()) {
	   			answer = result.getInt("count");
	   		}
	   		return answer;
    	   
       }catch(SQLException e) {
    	   System.out.println(e.getMessage());
    	   return -1;
       }
	}

	/*
	 * Returns a string with student information of student with student id sid.
	 * The output must be formatted as
	 * "firstName:lastName:sex:age:yearOfStudy:department". Returns an empty
	 * string "" if the student does not exist.
	 */
	public String getStudentInfo(int sid) {
		try {
			String sqlQ = "SELECT sfirstname, slastname, sex, age, yearofstudy, dcode " +
						"FROM student " +
						"WHERE sid = ?";
			ps = connection.prepareStatement(sqlQ);
			ps.setInt(1, sid);
			rs = ps.executeQuery();
			boolean resultIsEmpty = !rs.next();
			if (resultIsEmpty) {
				return "";
			}
			return String.format("%s:%s:%s:%s:%s:%s", rs.getString("sfirstname").trim(), rs.getString("slastname").trim(), rs.getString("sex").trim(), rs.getString("age").trim(), rs.getString("yearofstudy").trim(), rs.getString("dcode").trim());
		} catch (SQLException e) {
			return "";
		}
	}

	/*
	 * Changes a department's name. Returns true if the change was successful,
	 * false otherwise.
	 */
	public boolean chgDept(String dcode, String newName) {
		
	  
	  
	  
	  return true;
	}

	/*
	 * Deletes a department. Returns true if the deletion was successful, false
	 * otherwise.
	 */
	public boolean deleteDept(String dcode) {
        PreparedStatement st=null;
        String query = "";
        
		try {
			query = "DELETE FROM department WHERE dcode=?";
	   		st = connection.prepareStatement(query);
	   		st.setString(1, dcode);		
	   		int rowsAffected = st.executeUpdate();
	   		if(rowsAffected == 0) {
	   			return false;
	   		}
			return true;
		}catch(SQLException e) {
			System.out.println(e.getMessage());
			return false;
		}
	}

	/*
	 * Returns a string with all the courses a student with student id sid has
	 * taken. Each course will be in a separate line.
	 * 
	 * Eg. "courseName1:department:semester:year:grade
	 * courseName2:department:semester:year:grade"
	 * 
	 * Returns an empty string "" if the student does not exist.
	 */
	public String listCourses(int sid) {
		try {
			String sqlQ = "SELECT c.cname, c.dcode, cs.semester, cs.year, sc.grade " +
					"FROM studentcourse sc " +
					"INNER JOIN coursesection cs ON sc.csid = cs.csid " +
					"INNER JOIN course c ON cs.cid = c.cid " +
					"WHERE sc.sid = ?";
			ps = connection.prepareStatement(sqlQ);
			ps.setInt(1, sid);
			rs = ps.executeQuery();
			String result = "";
			boolean first = true;

			while(rs.next()) {
				if (!first) {
					result += "\n";
				}
				result = result + String.format("%s:%s:%s:%s:%s", rs.getString("cname").trim(), rs.getString("dcode").trim(), rs.getString("semester").trim(), rs.getString("year").trim(), rs.getString("grade").trim());
				first = false;
			}
			return result;
		} catch (SQLException e) {
			return "";
		}
	}

	/*
	 * Increases the grades of all the students who took a course in the course
	 * section identified by csid by 10%. Returns true if the update was
	 * successful, false otherwise. Do not not allow grades to go over 100%.
	 */
	public boolean updateGrades(int csid) {
		try {
			String sqlQ = "UPDATE studentcourse " +
					"SET grade = LEAST(grade + 10, 100) " +
					"WHERE csid = ?";
			ps = connection.prepareStatement(sqlQ);
			ps.setInt(1, csid);
			ps.executeUpdate();
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	/*
	 * Create a table containing all the female students in "Computer Science"
	 * department who are in their fourth year of study.
	 * 
	 * The name of the table is femaleStudents and the attributes are:
	 * - sid INTEGER (student id)
	 * - fname CHAR (20) (first name)
	 * - lname CHAR (20) (last name)
	 * 
	 * Returns false and does not nothing if the table already exists. Returns
	 * true if the database was successfully created, false otherwise.
	 */
	public boolean updateDB() {
		PreparedStatement st=null;
        String query = "";
        String query1 = "";
		ResultSet result = null;
		
        try {
			query1="SELECT sid, sfirstname, slastname "
					+ "FROM student, department "
					+ "WHERE student.dcode = department.dcode AND "
					+ "sex=? AND dname=? AND yearofstudy=?";
	   		st = connection.prepareStatement(query1);
	   		st.setString(1, "F");	
	   		st.setString(2, "Computer Science");
	   		st.setInt(3, 8);
	   		result = st.executeQuery();
	   		
			query = "CREATE TABLE femaleStudents(sid INTEGER, fname CHAR(20), lname CHAR(20)"
					+ ")";
	   		st = connection.prepareStatement(query);
	   		int returnval = st.executeUpdate();
	   		
	   		while(result.next()) {
	   			System.out.println("Sid: "+ result.getInt("sid")+" Fname: "+ result.getString("sfirstname"));
	   			query = "INSERT INTO femaleStudents VALUES (?, ?, ?)";
	   			st = connection.prepareStatement(query);
		   		st.setInt(1, result.getInt("sid"));
		   		st.setString(2, result.getString("sfirstname"));
		   		st.setString(3, result.getString("slastname"));
	   			int inserted = st.executeUpdate();
	   			if(inserted != 1) {
	   				return false;
	   			}
	   		}
	   		return true;
	   		
		}catch(SQLException e) {
			System.out.println(e.getMessage());
			return false;
		}
	}
	
	public static void main(String[] args) {
	  Assignment2 as2 = new Assignment2();
	}
}
