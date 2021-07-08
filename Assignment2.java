

//We need to remove the package cscc43A2Java later before we submit the assignment

package cscc43A2Java;

import java.sql.*;
import java.util.Scanner;

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
	 return successful;
	}

	/*
	 * Closes the connection in this object instance. Returns true if the
	 * closure was successful. Returns false if this object instance previously
	 * had no active connections.
	 */
	public boolean disconnectDB() {
		boolean successful = false;
		try  {
		  this.connection.close();
		  successful = true;
		} catch (SQLException e) {
		  System.out.println("Error, could not close db connection");
		}
		return successful;
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
		throw new RuntimeException("Function Not Implemented");
	}

	/*
	 * Returns the number of students in department dname. Returns -1 if the
	 * department does not exist.
	 */
	public int getStudentsCount(String dname) {
		throw new RuntimeException("Function Not Implemented");
	}

	/*
	 * Returns a string with student information of student with student id sid.
	 * The output must be formatted as
	 * "firstName:lastName:sex:age:yearOfStudy:department". Returns an empty
	 * string "" if the student does not exist.
	 */
	public String getStudentInfo(int sid) {
		throw new RuntimeException("Function Not Implemented");
	}

	/*
	 * Changes a department's name. Returns true if the change was successful,
	 * false otherwise.
	 */
	public boolean chgDept(String dcode, String newName) {
		throw new RuntimeException("Function Not Implemented");
	}

	/*
	 * Deletes a department. Returns true if the deletion was successful, false
	 * otherwise.
	 */
	public boolean deleteDept(String dcode) {
		throw new RuntimeException("Function Not Implemented");
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
		throw new RuntimeException("Function Not Implemented");
	}

	/*
	 * Increases the grades of all the students who took a course in the course
	 * section identified by csid by 10%. Returns true if the update was
	 * successful, false otherwise. Do not not allow grades to go over 100%.
	 */
	public boolean updateGrades(int csid) {
		throw new RuntimeException("Function Not Implemented");
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
		throw new RuntimeException("Function Not Implemented");
	}
	
	public static void main(String[] args) {
	  Assignment2 as2 = new Assignment2();
	}
}
