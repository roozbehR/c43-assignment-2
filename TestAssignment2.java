public class TestAssignment2 {
    public static void main(String[] args) {
        Assignment2 a2 = new Assignment2();
        try {
            if (args.length != 3) {
            System.err.println("Invalid arguments!");
            System.exit(1);
            }

            a2.connectDB(args[0], args[1], args[2]);

            System.out.println(a2.getStudentInfo(10));
        } catch (Exception ex) {
            System.out.println(ex);
        } finally {
            a2.disconnectDB();
        }
    }
}