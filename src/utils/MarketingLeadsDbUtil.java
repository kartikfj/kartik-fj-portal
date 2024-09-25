package utils;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import beans.ConsultantLeads;
import beans.ConsultantVisits;
import beans.EmailConfig;
import beans.MarketingLeads;
import beans.MktSalesLeads;
import beans.MysqlDBConnectionPool;
import beans.OrclDBConnectionPool;

public class MarketingLeadsDbUtil {

	private String byEVM;

	public void insertNewMarketingLeads(MarketingLeads theMLData) throws SQLException {

		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		try {
			myCon = con.getMysqlConn();

			String sql = "INSERT INTO marketing(oprtunity, status, location, leads, contact, product, remark, main_contractor, mep_contractor, updated_year, updated_by, week, created_date, updated_date, marketing_location, client) "
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, sysdate(), sysdate(), ?, ?)";

			// Prepare the statement
			myStmt = myCon.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

			// Set the parameter values in the correct order
			myStmt.setString(1, theMLData.getOpt()); // Opportunity
			myStmt.setString(2, theMLData.getStatus()); // Status
			myStmt.setString(3, theMLData.getLocation()); // Location
			myStmt.setString(4, theMLData.getLeads()); // Leads
			myStmt.setString(5, theMLData.getContactDtls()); // Contact
			myStmt.setString(6, theMLData.getProducts()); // Product (mapped to divisions)
			myStmt.setString(7, theMLData.getRemarks()); // Remark
			myStmt.setString(8, theMLData.getMainContractor());// Main Contractor
			myStmt.setString(9, theMLData.getMepContractor()); // MEP Contractor
			myStmt.setString(10, theMLData.getUpdatedYr()); // Updated Year
			myStmt.setString(11, theMLData.getUpdatedBy()); // Updated By (Employee ID)
			myStmt.setString(12, theMLData.getUpdtdWeek()); // Week
			myStmt.setString(13, theMLData.getLocation()); // Marketing Location
			myStmt.setString(14, theMLData.getClient()); // Client

			// Execute the SQL query
			myStmt.execute();
			// get lead id dynamically
			myRes = myStmt.getGeneratedKeys();
			if (myRes.next()) {
				int leadId = myRes.getInt(1); // Retrieve the generated lead ID
				System.out.println("Inserted lead with ID: " + leadId);

				// Send the approval email with the dynamic lead ID
				sendMarketingLeadApprovalEmail(theMLData, leadId);
			} else {
				System.out.println("Failed to retrieve the generated lead ID.");
			}
			// sendMarketingLeadApprovalEmail(theMLData);
		} finally {
			// Close JDBC objects
			close(myStmt, myRes);
			con.closeConnection();
		}
	}

	private void sendMarketingLeadApprovalEmail(MarketingLeads theMLData, int id) {
		try {
			EmailConfig sslMail = new EmailConfig();

			// Generate approval and rejection URLs dynamically
			String approvalLink = "http://10.10.4.198:8080/FJPORTAL_DEV/MajorProjectApproval?leadId=" + id;
			// String rejectionLink = "http://10.10.5.143:8080/FJPORTAL_DEV/reject?leadId="
			// + id;

			System.out.println("Approval Link: " + approvalLink);
			String message = "Dear Krikor,<br><br>" + "Please check The Detail of New Major Project<br>" + "<br><br>";
			// Email message with styled buttons
			String msg = "<!DOCTYPE html><html><head>" + "<style>"
					+ "body { font-family: Arial, sans-serif; margin: 0; padding: 0; }"
					+ "table { border-collapse: collapse; width: 100%; max-width: 600px; margin: 0 auto; background-color: #fff; }"
					+ "th, td { padding: 8px; text-align: left; border: 1px solid #ddd; }"
					+ "th { background-color: #f4f4f4; }" + "p { font-size: 16px; color: #333; margin: 0 0 16px; }"
					+ ".column1 { width: 30%; font-weight: bold; }" + // Column for labels with bold text
					".column2 { width: 70%; }" + // Column for details
					"</style>" + "</head>" + "<body>" + "<p>" + message + "</p>" + "<table>" + "<tr>"
					+ "<td class='column1'>Major Project</td>" + "<td class='column2'>" + theMLData.getOpt() + "</td>"
					+ "</tr>" + "<tr>" + "<td class='column1'>Status</td>" + "<td class='column2'>"
					+ theMLData.getStatus() + "</td>" + "</tr>" + "<tr>" + "<td class='column1'>Location</td>"
					+ "<td class='column2'>" + theMLData.getLocation() + "</td>" + "</tr>" + "<tr>"
					+ "<td class='column1'>Division</td>" + "<td class='column2'>" + theMLData.getProducts() + "</td>"
					+ "</tr>" + "<tr>" + "<td class='column1'>Main Contractor</td>" + "<td class='column2'>"
					+ theMLData.getMainContractor() + "</td>" + "</tr>" + "<tr>" + "<td class='column1'>Client</td>"
					+ "<td class='column2'>" + theMLData.getClient() + "</td>" + "</tr>" + "</table>"
					+ "<p>Please review and take action:</p>" + "<p><a href='" + approvalLink
					+ "' style='padding: 10px 15px; background-color: green; color: white; text-decoration: none; border-radius: 5px;'>Approve Project</a></p>"
					+ "</body></html>";

			// Send the email
			int emailStatus = sslMail.sendMail1(msg); // Modify with your SMTP settings

			if (emailStatus != 1) {
				System.out.println("Failed to send approval email.");
			} else {
				System.out.println("Approval email sent successfully.");
			}

		} catch (Exception e) {
			System.out.println("Error sending approval email.");
			e.printStackTrace();
		}
	}

	public List<MarketingLeads> getMarketingLeadsDetails(String currYear) throws SQLException {
		int currentYear = Integer.parseInt(currYear);
		int prevYear = currentYear - 1;
		List<MarketingLeads> marketLeadsList = new ArrayList<>();
		String oppStatus = "";
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		try {

			// Get Connection
			myCon = con.getMysqlConn();

			// Execute sql stamt
			String sql = "SELECT * from marketing where YEAR(created_date) in (?,?) order by updated_date desc ";
			myStmt = myCon.prepareStatement(sql);

			// set the param values for the student
			myStmt.setInt(1, prevYear);
			myStmt.setInt(2, currentYear);
			// Execute a SQL query
			myRes = myStmt.executeQuery();

			// Process the result set
			while (myRes.next()) {
				String mktid = myRes.getString(1);
				String opt_temp = myRes.getString(2);
				String status_temp = myRes.getString(3);
				String location_temp = myRes.getString(4);
				String leads_temp = myRes.getString(5);
				String contact_temp = myRes.getString(6);
				String product_temp = myRes.getString(7);
				String remark_temp = myRes.getString(8);
				String main_contra_temp = myRes.getString(9);
				String mep_contra_temp = myRes.getString(10);
				String update_year_temp = myRes.getString(11);
				String updateby_temp = myRes.getString(12);
				String updateWeek_tmp = myRes.getString(13);
				String created_date_temp = myRes.getString(14);
				String updatedate_temp = myRes.getString(15);
				String client = myRes.getString(17);
				String approved = myRes.getString(18);
				try {
					oppStatus = dateDiffStatus(updatedate_temp, created_date_temp);

					// System.out.println(oppStatus);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				MarketingLeads tempmarketLeadsList = new MarketingLeads(mktid, opt_temp, status_temp, location_temp,
						leads_temp, contact_temp, product_temp, remark_temp, main_contra_temp, mep_contra_temp,
						update_year_temp, updateby_temp, updateWeek_tmp, created_date_temp, updatedate_temp, oppStatus,
						client, approved);
				// System.out.println("goal_list"+goal_id);
				// add this to a array list of AppraisalHr
				marketLeadsList.add(tempmarketLeadsList);

			}
			return marketLeadsList;

		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			con.closeConnection();

		}
	}

	public List<MarketingLeads> getMarketingLeadsDetailsFltr(String currYear) throws SQLException {
		int currentYear = Integer.parseInt(currYear);
		int prevYear = currentYear - 1;
		List<MarketingLeads> marketLeadsList = new ArrayList<>();
		String oppStatus = "";
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		try {

			// Get Connection
			myCon = con.getMysqlConn();

			// Execute sql stamt
			String sql = "SELECT * from marketing where YEAR(created_date) in (?,?)  AND isApproved = 'yes'  order by updated_date desc ";
			myStmt = myCon.prepareStatement(sql);

			// set the param values for the student
			myStmt.setInt(1, prevYear);
			myStmt.setInt(2, currentYear);
			// Execute a SQL query
			myRes = myStmt.executeQuery();

			// Process the result set
			while (myRes.next()) {
				String mktid = myRes.getString(1);
				String opt_temp = myRes.getString(2);
				String status_temp = myRes.getString(3);
				String location_temp = myRes.getString(4);
				String leads_temp = myRes.getString(5);
				String contact_temp = myRes.getString(6);
				String product_temp = myRes.getString(7);
				String remark_temp = myRes.getString(8);
				String main_contra_temp = myRes.getString(9);
				String mep_contra_temp = myRes.getString(10);
				String update_year_temp = myRes.getString(11);
				String updateby_temp = myRes.getString(12);
				String updateWeek_tmp = myRes.getString(13);
				String created_date_temp = myRes.getString(14);
				String updatedate_temp = myRes.getString(15);
				String client = myRes.getString(17);
				String approved = myRes.getString(18);
				try {
					oppStatus = dateDiffStatus(updatedate_temp, created_date_temp);

					// System.out.println(oppStatus);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				MarketingLeads tempmarketLeadsList = new MarketingLeads(mktid, opt_temp, status_temp, location_temp,
						leads_temp, contact_temp, product_temp, remark_temp, main_contra_temp, mep_contra_temp,
						update_year_temp, updateby_temp, updateWeek_tmp, created_date_temp, updatedate_temp, oppStatus,
						client, approved);
				// System.out.println("goal_list"+goal_id);
				// add this to a array list of AppraisalHr
				marketLeadsList.add(tempmarketLeadsList);

			}
			return marketLeadsList;

		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			con.closeConnection();

		}
	}

	public List<MarketingLeads> getAllMarketingLeadsDetailsforSalesEng(String currYear, String companyCode,
			String divnCode) throws SQLException {
		int currentYear = Integer.parseInt(currYear);
		int prevYear = currentYear - 1;
		List<MarketingLeads> marketLeadsList = new ArrayList<>();
		String oppStatus = "";
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		try {

			// Get Connection
			myCon = con.getMysqlConn();

			// Execute sql stamt
			String sql = "SELECT * from marketing where YEAR(created_date) in(?,?) and product in(?,?,'AD')  order by updated_date desc ";
			myStmt = myCon.prepareStatement(sql);

			// set the param values for the student
			myStmt.setInt(1, prevYear);
			myStmt.setInt(2, currentYear);
			myStmt.setString(3, companyCode);
			myStmt.setString(4, divnCode);
			// Execute a SQL query
			myRes = myStmt.executeQuery();

			// Process the result set
			while (myRes.next()) {
				String mktid = myRes.getString(1);
				String opt_temp = myRes.getString(2);
				String status_temp = myRes.getString(3);
				String location_temp = myRes.getString(4);
				String leads_temp = myRes.getString(5);
				String contact_temp = myRes.getString(6);
				String product_temp = myRes.getString(7);
				String remark_temp = myRes.getString(8);
				String main_contra_temp = myRes.getString(9);
				String mep_contra_temp = myRes.getString(10);
				String update_year_temp = myRes.getString(11);
				String updateby_temp = myRes.getString(12);
				String updateWeek_tmp = myRes.getString(13);
				String created_date_temp = myRes.getString(14);
				String updatedate_temp = myRes.getString(15);
				String client = myRes.getString(17);
				String approved = myRes.getString(18);
				try {
					oppStatus = dateDiffStatus(updatedate_temp, created_date_temp);

					// System.out.println(oppStatus);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				MarketingLeads tempmarketLeadsList = new MarketingLeads(mktid, opt_temp, status_temp, location_temp,
						leads_temp, contact_temp, product_temp, remark_temp, main_contra_temp, mep_contra_temp,
						update_year_temp, updateby_temp, updateWeek_tmp, created_date_temp, updatedate_temp, oppStatus,
						client, approved);
				// System.out.println("goal_list"+goal_id);
				// add this to a array list of AppraisalHr
				marketLeadsList.add(tempmarketLeadsList);

			}
			return marketLeadsList;

		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			con.closeConnection();

		}
	}

	public List<MarketingLeads> getMarketingLeadsforLast2Week(String currentYear) throws SQLException {
		List<MarketingLeads> marketLeadsList = new ArrayList<>();
		String oppStatus = "";

		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		try {

			// Get Connection
			myCon = con.getMysqlConn();

			// Execute sql stamt
			String sql = " SELECT * FROM marketing  "
					+ " WHERE week BETWEEN (select max(week) from  newfjtco.marketing  "
					+ " where updated_year=YEAR(sysdate()))-3 AND (select max(week) from  newfjtco.marketing  "
					+ " where updated_year=YEAR(sysdate()))  " + " and updated_year= ? "
					+ " order by updated_date desc ";
			myStmt = myCon.prepareStatement(sql);

			// set the param values for the student
			myStmt.setString(1, currentYear);
			// Execute a SQL query
			myRes = myStmt.executeQuery();

			// Process the result set
			while (myRes.next()) {
				String mktid = myRes.getString(1);
				String opt_temp = myRes.getString(2);
				String status_temp = myRes.getString(3);
				String location_temp = myRes.getString(4);
				String leads_temp = myRes.getString(5);
				String contact_temp = myRes.getString(6);
				String product_temp = myRes.getString(7);
				String remark_temp = myRes.getString(8);
				String main_contra_temp = myRes.getString(9);
				String mep_contra_temp = myRes.getString(10);
				String update_year_temp = myRes.getString(11);
				String updateby_temp = myRes.getString(12);
				String updateWeek_tmp = myRes.getString(13);
				String created_date_temp = myRes.getString(14);
				String updatedate_temp = myRes.getString(15);
				String client = myRes.getString(17);
				String approved = myRes.getString(18);
				try {
					oppStatus = dateDiffStatus(updatedate_temp, created_date_temp);

					// System.out.println(oppStatus);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				MarketingLeads tempmarketLeadsList = new MarketingLeads(mktid, opt_temp, status_temp, location_temp,
						leads_temp, contact_temp, product_temp, remark_temp, main_contra_temp, mep_contra_temp,
						update_year_temp, updateby_temp, updateWeek_tmp, created_date_temp, updatedate_temp, oppStatus,
						client, approved);

				marketLeadsList.add(tempmarketLeadsList);

			}
			return marketLeadsList;

		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			con.closeConnection();

		}
	}

	public List<MarketingLeads> getMarketingLeadsforLast2WeekFlterData(String currentYear) throws SQLException {
		List<MarketingLeads> marketLeadsList = new ArrayList<>();
		String oppStatus = "";

		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		try {

			// Get Connection
			myCon = con.getMysqlConn();

			// Execute sql stamt
			String sql = " SELECT * FROM marketing  "
					+ " WHERE week BETWEEN (select max(week) from  newfjtco.marketing  "
					+ " where updated_year=YEAR(sysdate()))-3 AND (select max(week) from  newfjtco.marketing  "
					+ " where updated_year=YEAR(sysdate()))  " + " and updated_year= ? " + " AND isApproved = 'yes' "
					+ " order by updated_date desc ";
			myStmt = myCon.prepareStatement(sql);

			// set the param values for the student
			myStmt.setString(1, currentYear);
			// Execute a SQL query
			myRes = myStmt.executeQuery();

			// Process the result set
			while (myRes.next()) {
				String mktid = myRes.getString(1);
				String opt_temp = myRes.getString(2);
				String status_temp = myRes.getString(3);
				String location_temp = myRes.getString(4);
				String leads_temp = myRes.getString(5);
				String contact_temp = myRes.getString(6);
				String product_temp = myRes.getString(7);
				String remark_temp = myRes.getString(8);
				String main_contra_temp = myRes.getString(9);
				String mep_contra_temp = myRes.getString(10);
				String update_year_temp = myRes.getString(11);
				String updateby_temp = myRes.getString(12);
				String updateWeek_tmp = myRes.getString(13);
				String created_date_temp = myRes.getString(14);
				String updatedate_temp = myRes.getString(15);
				String client = myRes.getString(17);
				String approved = myRes.getString(18);
				try {
					oppStatus = dateDiffStatus(updatedate_temp, created_date_temp);

					// System.out.println(oppStatus);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				MarketingLeads tempmarketLeadsList = new MarketingLeads(mktid, opt_temp, status_temp, location_temp,
						leads_temp, contact_temp, product_temp, remark_temp, main_contra_temp, mep_contra_temp,
						update_year_temp, updateby_temp, updateWeek_tmp, created_date_temp, updatedate_temp, oppStatus,
						client, approved);

				marketLeadsList.add(tempmarketLeadsList);

			}
			return marketLeadsList;

		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			con.closeConnection();

		}
	}

	public List<MarketingLeads> getMarketingLeadsforLast2Week_Sales_Eng(String currentYear, String companyCode,
			String divnCode) throws SQLException {
		List<MarketingLeads> marketLeadsList = new ArrayList<>();
		String oppStatus = "";

		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		try {

			// Get Connection
			myCon = con.getMysqlConn();

			// Execute sql stamt
			String sql = " SELECT * FROM marketing  "
					+ " WHERE week BETWEEN (select max(week) from  newfjtco.marketing  "
					+ " where updated_year=YEAR(sysdate()))-3 AND (select max(week) from  newfjtco.marketing  "
					+ " where updated_year=YEAR(sysdate()))  " + " and  updated_year= ?  and product in(?,?,'AD')  "
					+ " order by updated_date desc ";
			myStmt = myCon.prepareStatement(sql);

			// set the param values for the student
			myStmt.setString(1, currentYear);
			myStmt.setString(2, companyCode);
			myStmt.setString(3, divnCode);
			// Execute a SQL query
			myRes = myStmt.executeQuery();

			// Process the result set
			while (myRes.next()) {
				String mktid = myRes.getString(1);
				String opt_temp = myRes.getString(2);
				String status_temp = myRes.getString(3);
				String location_temp = myRes.getString(4);
				String leads_temp = myRes.getString(5);
				String contact_temp = myRes.getString(6);
				String product_temp = myRes.getString(7);
				String remark_temp = myRes.getString(8);
				String main_contra_temp = myRes.getString(9);
				String mep_contra_temp = myRes.getString(10);
				String update_year_temp = myRes.getString(11);
				String updateby_temp = myRes.getString(12);
				String updateWeek_tmp = myRes.getString(13);
				String created_date_temp = myRes.getString(14);
				String updatedate_temp = myRes.getString(15);
				String client = myRes.getString(17);
				String approved = myRes.getString(18);
				try {
					oppStatus = dateDiffStatus(updatedate_temp, created_date_temp);

					// System.out.println(oppStatus);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				MarketingLeads tempmarketLeadsList = new MarketingLeads(mktid, opt_temp, status_temp, location_temp,
						leads_temp, contact_temp, product_temp, remark_temp, main_contra_temp, mep_contra_temp,
						update_year_temp, updateby_temp, updateWeek_tmp, created_date_temp, updatedate_temp, oppStatus,
						client, approved);

				marketLeadsList.add(tempmarketLeadsList);

			}
			return marketLeadsList;

		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			con.closeConnection();

		}
	}

	private void close(Statement myStmt, ResultSet myRes) {
		try {
			if (myRes != null) {
				myRes.close();
			}
			if (myStmt != null) {
				myStmt.close();
			}
		} catch (Exception exc) {
			exc.printStackTrace();
		}
	}

	public void editUpdateMarketingLeads(MarketingLeads theMLData) throws SQLException {
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		EmailConfig sslMail = new EmailConfig();
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		try {
			myCon = con.getMysqlConn();

			String sql = "update marketing set oprtunity = ?, status =?, location =?, leads =?, contact =?, product =?, remark =?, main_contractor = ?, mep_contractor = ?, updated_year =?, updated_by =?, week=?, updated_date = sysdate(),client=? "
					+ " where id = ? ";

			// very important
			myStmt = myCon.prepareStatement(sql);

			// set the param values for the student
			myStmt.setString(1, theMLData.getOpt());
			myStmt.setString(2, theMLData.getStatus());
			myStmt.setString(3, theMLData.getLocation());
			myStmt.setString(4, theMLData.getLeads());
			myStmt.setString(5, theMLData.getContactDtls());
			myStmt.setString(6, theMLData.getProducts());
			myStmt.setString(7, theMLData.getRemarks());
			myStmt.setString(8, theMLData.getMainContractor());
			myStmt.setString(9, theMLData.getMepContractor());
			myStmt.setString(10, theMLData.getUpdatedYr());
			myStmt.setString(11, theMLData.getUpdatedBy());
			myStmt.setString(12, theMLData.getUpdtdWeek());
			myStmt.setString(13, theMLData.getClient());
			myStmt.setString(14, theMLData.getId());
			// execute sql query
			myStmt.execute();
			// int emailStatus = sslMail.sendMail(); // Modify with your SMTP
			// settings
			// sendMarketingLeadApprovalEmail(theMLData, 1);

			System.out.println("Failed to send approval email.");

			System.out.println("Approval email sent successfully.");

		} finally {
			// close jdbc objects

			close(myStmt, myRes);
			con.closeConnection();

		}
	}

	public void deleteUpdateMarketingLeads(String mlId) throws SQLException {
		Connection myCon = null;
		PreparedStatement myStmt = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		try {
			myCon = con.getMysqlConn();

			String sql = "delete from  marketing  " + " where  id =? ";

			myStmt = myCon.prepareStatement(sql);
			myStmt.setString(1, mlId);
			myStmt.execute();

		} finally {
			// close jdbc objects

			close(myStmt, null);
			con.closeConnection();

		}

	}

	public boolean updateApproveMarketingLeads(String mlId) throws SQLException {
		Connection myCon = null;
		PreparedStatement myStmt = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		EmailConfig ssl = new EmailConfig();
		MarketingLeads leadData = getMarketingLeadById(mlId);
		try {
			myCon = con.getMysqlConn();
			String sql = "update marketing set isApproved=?" + " where id = ? ";

			myStmt = myCon.prepareStatement(sql);
			myStmt.setString(1, "yes");
			myStmt.setString(2, mlId);
			myStmt.execute();

		} catch (SQLException e) {
			// Log the error for debugging
			System.out.println("SQL Exception: " + e.getMessage());
			e.printStackTrace();
			return false;

		}

		finally {
			// close jdbc objects

			close(myStmt, null);
			con.closeConnection();

		}
		if (leadData != null) {
			String message = "Dear Marketing and Sales Team,<br><br>"
					+ "New Major Project is Approved By Krikor Ohanian.<br>"
					+ "Full Detail of the project is available in FJPORTAL (Major Project Page)<br><br>";

			String leadDetails = "<!DOCTYPE html><html><head>" + "<style>"
					+ "body { font-family: Arial, sans-serif; margin: 0; padding: 0; }"
					+ "table { border-collapse: collapse; width: 100%; max-width: 600px; margin: 0 auto; background-color: #fff; }"
					+ "th, td { padding: 8px; text-align: left; border: 1px solid #ddd; }"
					+ "th { background-color: #f4f4f4; }" + "p { font-size: 16px; color: #333; margin: 0 0 16px; }"
					+ ".column1 { width: 20%; vertical-align: top; font-weight: bold; }" + ".column2 { width: 80%; }"
					+ "</style>" + "</head>" + "<body>" + "<p>" + message + "</p>" + "<table>" + "<tr>"
					+ "<td class='column1'>Lead ID</td>" + "<td class='column2'>" + leadData.getId() + "</td>" + "</tr>"
					+ "<tr>" + "<td class='column1'>Major Project</td>" + "<td class='column2'>" + leadData.getOpt()
					+ "</td>" + "</tr>" + "<tr>" + "<td class='column1'>Status</td>" + "<td class='column2'>"
					+ leadData.getStatus() + "</td>" + "</tr>" + "<tr>" + "<td class='column1'>Location</td>"
					+ "<td class='column2'>" + leadData.getLocation() + "</td>" + "</tr>" + "</table>"
					+ "</body></html>";

			// Add other details as needed
			List<String> recipients = Arrays.asList("rajakumari.ch@fjtco.com", "kartik.p@fjtco.com");
			ssl.sendEmail2(recipients, leadDetails);
		}
		return true;

	}

	public MarketingLeads getMarketingLeadById(String leadId) throws SQLException {
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRs = null;
		MarketingLeads marketingLeadData = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();

		try {
			myCon = con.getMysqlConn();
			String sql = "SELECT * FROM marketing WHERE id = ?";
			myStmt = myCon.prepareStatement(sql);
			myStmt.setString(1, leadId);

			myRs = myStmt.executeQuery();

			if (myRs.next()) {
				// Using the constructor to set values from the database
				marketingLeadData = new MarketingLeads(myRs.getString("id"), myRs.getString("oprtunity"),
						myRs.getString("status"), myRs.getString("location"), myRs.getString("leads"),
						myRs.getString("contact"), myRs.getString("product"), myRs.getString("remark"),
						myRs.getString("main_contractor"), myRs.getString("mep_contractor"),
						myRs.getString("updated_year"), myRs.getString("updated_by"), myRs.getString("week"),
						myRs.getString("created_date"), myRs.getString("updated_date"), "Some Status", // Set this value
																										// appropriately,
																										// based on your
																										// business
																										// logic
						myRs.getString("client"), myRs.getString("isApproved") // Assuming this field exists for
																				// approval
				);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(myStmt, myRs);
			con.closeConnection();
		}

		return marketingLeadData;
	}

	/*
	 * public int createnewConsultantLeads(ConsultantLeads consultant_Leads_Dtls)
	 * throws SQLException {
	 * 
	 * Connection myCon = null; PreparedStatement myStmt = null; ResultSet myRes =
	 * null; MysqlDBConnectionPool con = new MysqlDBConnectionPool(); int logType =
	 * 0; try { myCon = con.getMysqlConn();
	 * 
	 * String sql =
	 * "insert into consultant_leads(consultant,product,cnslt_status,division,remarks,create_year,created_by,created_date,updated_date,contact_details,byBDM) values(?,?,?,?,?,?,?,sysdate(),sysdate(),?,?)"
	 * ;
	 * 
	 * // very important myStmt = myCon.prepareStatement(sql);
	 * 
	 * // set the param values for the student myStmt.setString(1,
	 * consultant_Leads_Dtls.getConslt_name()); myStmt.setString(2,
	 * consultant_Leads_Dtls.getProduct()); myStmt.setString(3,
	 * consultant_Leads_Dtls.getStatus()); myStmt.setString(4,
	 * consultant_Leads_Dtls.getDivision()); myStmt.setString(5,
	 * consultant_Leads_Dtls.getRemarks()); myStmt.setString(6,
	 * consultant_Leads_Dtls.getCyr()); myStmt.setString(7,
	 * consultant_Leads_Dtls.getCby()); myStmt.setString(8,
	 * consultant_Leads_Dtls.getContactDetails()); myStmt.setString(9,
	 * consultant_Leads_Dtls.getIsUpdateByBDM()); // execute sql query logType =
	 * myStmt.executeUpdate();
	 * 
	 * } finally { // close jdbc objects
	 * 
	 * close(myStmt, myRes); con.closeConnection();
	 * 
	 * }
	 * 
	 * return logType; }
	 */

	/*
	 * public List<ConsultantLeads> getFilteredConsultantList(String[]
	 * selectedTypes) throws SQLException { List<ConsultantLeads>
	 * filteredConsultants = new ArrayList<>(); String frz_value = "CONSULT"; String
	 * query = ""; // Check if selectedTypes is not null and not empty if
	 * (selectedTypes == null || selectedTypes.length == 0) {
	 * 
	 * System.out.println("No consultant types provided for filtering."); return
	 * filteredConsultants;
	 * 
	 * 
	 * query =
	 * "SELECT VSSV_CODE, VSSV_NAME, VSSV_BL_SHORT_NAME FROM IM_VS_STATIC_VALUE WHERE VSSV_VS_CODE = ? AND VSSV_BL_SHORT_NAME IS NULL"
	 * ;
	 * 
	 * } boolean isNotAnyTypeSelected = (selectedTypes != null &&
	 * selectedTypes.length == 1 && selectedTypes[0].trim().equals("PA"));
	 * System.out.println(selectedTypes[0]); if (isNotAnyTypeSelected) {
	 * System.out.println("i inter"); // If "Not Any Type" is selected, query for
	 * rows where VSSV_BL_SHORT_NAME is // NULL
	 * 
	 * query =
	 * "SELECT VSSV_CODE, VSSV_NAME, VSSV_BL_SHORT_NAME FROM IM_VS_STATIC_VALUE WHERE VSSV_VS_CODE = ? AND VSSV_BL_SHORT_NAME IS NULL"
	 * ;
	 * 
	 * query =
	 * "SELECT VSSV_CODE, VSSV_NAME, VSSV_BL_SHORT_NAME FROM IM_VS_STATIC_VALUE WHERE VSSV_VS_CODE = ? AND (VSSV_BL_SHORT_NAME IS NULL OR VSSV_BL_SHORT_NAME = ' ')"
	 * ; } else {
	 * 
	 * // Prepare the base SQL query with a placeholder for VSSV_VS_CODE and dynamic
	 * // placeholders for selected types query =
	 * "SELECT VSSV_CODE, VSSV_NAME, VSSV_BL_SHORT_NAME FROM IM_VS_STATIC_VALUE WHERE VSSV_VS_CODE = ? AND VSSV_BL_SHORT_NAME IN ("
	 * ; StringBuilder typePlaceholders = new StringBuilder();
	 * 
	 * // Dynamically build the placeholders for the query for (int i = 0; i <
	 * selectedTypes.length; i++) { typePlaceholders.append("?"); if (i <
	 * selectedTypes.length - 1) { typePlaceholders.append(", "); } } query +=
	 * typePlaceholders.toString() + ")"; } // Log the final query for debugging
	 * System.out.println("Executing Query: " + query);
	 * 
	 * // Open the database connection try (Connection conn = new
	 * OrclDBConnectionPool().getOrclConn(); PreparedStatement stmt =
	 * conn.prepareStatement(query)) {
	 * 
	 * // Set the value for the VSSV_VS_CODE placeholder (first parameter)
	 * stmt.setString(1, frz_value); System.out.println("Setting parameter 1: " +
	 * frz_value);
	 * 
	 * // Set the values for the placeholders for consultant types and log them for
	 * // debugging for (int i = 0; i < selectedTypes.length; i++) {
	 * stmt.setString(i + 2, selectedTypes[i]); // Starts from index 2 because index
	 * 1 is already used System.out.println("Setting parameter " + (i + 2) + ": " +
	 * selectedTypes[i]); }
	 * 
	 * // Execute the query and process the result set try (ResultSet rs =
	 * stmt.executeQuery()) { // Get and print column names from the ResultSet
	 * metadata ResultSetMetaData rsmd = rs.getMetaData(); int columnCount =
	 * rsmd.getColumnCount(); System.out.print("Column names in the result set: ");
	 * for (int i = 1; i <= columnCount; i++) {
	 * System.out.print(rsmd.getColumnName(i) + " "); } System.out.println();
	 * 
	 * // Process the result set while (rs.next()) { // Fetch only the required
	 * columns String consultant = rs.getString("VSSV_NAME"); String consultantType
	 * = rs.getString("VSSV_BL_SHORT_NAME");
	 * 
	 * // Create a new ConsultantLeads object (adjust the constructor to match your
	 * // class structure) ConsultantLeads consultantLead = new
	 * ConsultantLeads(consultant, consultantType, "");
	 * filteredConsultants.add(consultantLead); } } } catch (SQLException e) { //
	 * Log the error for debugging System.out.println("SQL Exception: " +
	 * e.getMessage()); e.printStackTrace(); throw e; }
	 * 
	 * // Log the result for debugging System.out.println("Filtered Consultants: " +
	 * filteredConsultants.size());
	 * 
	 * for (ConsultantLeads consultant : filteredConsultants) {
	 * System.out.println("Consultant: " + consultant + ", Type: " +
	 * consultant.getType()); }
	 * 
	 * return filteredConsultants; }
	 */

	public List<ConsultantLeads> getFilteredConsultantList(String[] selectedTypes) throws SQLException {
		List<ConsultantLeads> filteredConsultants = new ArrayList<>();
		String frz_value = "CONSULT";
		String query;

		// Check if selectedTypes contains a single entry that is "PA", indicating "Not
		// Any Type"
		boolean isNotAnyTypeSelected = (selectedTypes != null && selectedTypes.length == 1
				&& selectedTypes[0].trim().equals("PA"));

		if (isNotAnyTypeSelected) {
			// If "Not Any Type" is selected, query for rows where VSSV_BL_SHORT_NAME is
			// NULL or empty or space
			query = "SELECT VSSV_CODE, VSSV_NAME, VSSV_BL_SHORT_NAME FROM IM_VS_STATIC_VALUE WHERE VSSV_VS_CODE = ? AND (VSSV_BL_SHORT_NAME IS NULL OR VSSV_BL_SHORT_NAME = ' ' OR VSSV_BL_SHORT_NAME = '')";
		} else {
			// Build the query with IN clause for provided types
			StringBuilder typePlaceholders = new StringBuilder();
			for (int i = 0; i < selectedTypes.length; i++) {
				typePlaceholders.append("?");
				if (i < selectedTypes.length - 1) {
					typePlaceholders.append(", ");
				}
			}
			query = "SELECT VSSV_CODE, VSSV_NAME, VSSV_BL_SHORT_NAME FROM IM_VS_STATIC_VALUE WHERE VSSV_VS_CODE = ? AND VSSV_BL_SHORT_NAME IN ("
					+ typePlaceholders.toString() + ")";
		}

		// Log the final query for debugging
		System.out.println("Executing Query: " + query);

		// Open the database connection and prepare the statement
		try (Connection conn = new OrclDBConnectionPool().getOrclConn();
				PreparedStatement stmt = conn.prepareStatement(query)) {

			// Set the value for the VSSV_VS_CODE placeholder (first parameter)
			stmt.setString(1, frz_value);
			System.out.println("Setting parameter 1: " + frz_value);

			// Set the values for the placeholders for consultant types, if they exist
			if (!isNotAnyTypeSelected) {
				for (int i = 0; i < selectedTypes.length; i++) {
					stmt.setString(i + 2, selectedTypes[i].trim()); // Starts from index 2 because index 1 is already
																	// used
					System.out.println("Setting parameter " + (i + 2) + ": " + selectedTypes[i].trim());
				}
			}

			// Execute the query and process the result set
			try (ResultSet rs = stmt.executeQuery()) {
				// Process the result set
				while (rs.next()) {
					// Fetch only the required columns
					String consultantCode = rs.getString("VSSV_CODE");
					String consultantName = rs.getString("VSSV_NAME");
					String consultantType = rs.getString("VSSV_BL_SHORT_NAME");

					// Create a new ConsultantLeads object (adjust the constructor to match your
					// class structure)
					ConsultantLeads consultantLead = new ConsultantLeads(consultantName, consultantType,
							consultantCode);
					filteredConsultants.add(consultantLead);
				}
			}
		} catch (SQLException e) {
			// Log the error for debugging
			System.out.println("SQL Exception: " + e.getMessage());
			e.printStackTrace();
			throw e;
		}

		// Log the result for debugging
		System.out.println("Filtered Consultants: " + filteredConsultants.size());
		return filteredConsultants;
	}

	/*
	 * 
	 * public List<ConsultantLeads> getFilteredConsultantList(String[]
	 * selectedTypes) throws SQLException { List<ConsultantLeads>
	 * filteredConsultants = new ArrayList<>();
	 * 
	 * // Check if selectedTypes is not null and not empty if (selectedTypes == null
	 * || selectedTypes.length == 0) {
	 * System.out.println("No consultant types provided for filtering."); return
	 * filteredConsultants; } String frz_value = "CONSULT"; // Prepare the base SQL
	 * query String query =
	 * "SELECT VSSV_CODE, VSSV_NAME, VSSV_BL_SHORT_NAME FROM IM_VS_STATIC_VALUE WHERE VSSV_VS_CODE = ? AND VSSV_BL_SHORT_NAME IN ("
	 * ; StringBuilder typePlaceholders = new StringBuilder();
	 * 
	 * // Dynamically build the placeholders for the query for (int i = 0; i <
	 * selectedTypes.length; i++) { typePlaceholders.append("?"); if (i <
	 * selectedTypes.length - 1) { typePlaceholders.append(","); } } query +=
	 * typePlaceholders.toString() + ")";
	 * 
	 * // Log the final query for debugging System.out.println("Executing Query: " +
	 * query);
	 * 
	 * // Open the database connection try (Connection conn = new
	 * OrclDBConnectionPool().getOrclConn(); PreparedStatement stmt =
	 * conn.prepareStatement(query)) {
	 * 
	 * // Set the values for the placeholders and log them for debugging for (int i
	 * = 0; i < selectedTypes.length; i++) { stmt.setString(i + 1,
	 * selectedTypes[i]); System.out.println("Setting parameter " + (i + 1) + ": " +
	 * selectedTypes[i]); }
	 * 
	 * // Execute the query and process the result set try (ResultSet rs =
	 * stmt.executeQuery()) { // Get and print column names from the ResultSet
	 * metadata ResultSetMetaData rsmd = rs.getMetaData(); int columnCount =
	 * rsmd.getColumnCount(); System.out.print("Column names in the result set: ");
	 * for (int i = 1; i <= columnCount; i++) {
	 * System.out.print(rsmd.getColumnName(i) + " "); } System.out.println();
	 * 
	 * // Process the result set while (rs.next()) { // Fetch only the required
	 * columns String consultant = rs.getString("VSSV_NAME"); String consultantType
	 * = rs.getString("VSSV_BL_SHORT_NAME");
	 * 
	 * // Create a new ConsultantLeads object (adjust the constructor to match your
	 * // class structure) ConsultantLeads consultantLead = new
	 * ConsultantLeads(consultant, consultantType, "");
	 * filteredConsultants.add(consultantLead); } } } catch (SQLException e) { //
	 * Log the error for debugging System.out.println("SQL Exception: " +
	 * e.getMessage()); e.printStackTrace(); throw e; }
	 * 
	 * // Log the result for debugging System.out.println("Filtered Consultants: " +
	 * filteredConsultants.size());
	 * 
	 * for (ConsultantLeads consultant : filteredConsultants) {
	 * System.out.println("Consultant: " + consultant + ", Type: " +
	 * consultant.getType()); }
	 * 
	 * return filteredConsultants; }
	 */

	public int createnewConsultantLeads(ConsultantLeads consultant_Leads_Dtls) throws SQLException {

		int logType = 0;
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		try {
			myCon = orcl.getOrclConn();

			String sql = "insert into CONSULTANT_LEADS(consultant,product,cnslt_status,division,remarks,create_year,created_by,created_date,updated_date,contact_details,byBDM,CONSULTANT_TYPE,EOA) values(?,?,?,?,?,?,?,SYSDATE,SYSDATE,?,?,?,?)";

			// very important
			myStmt = myCon.prepareStatement(sql);

			// set the param values for the student
			myStmt.setString(1, consultant_Leads_Dtls.getConslt_name());
			myStmt.setString(2, consultant_Leads_Dtls.getProduct());
			myStmt.setString(3, consultant_Leads_Dtls.getStatus());
			myStmt.setString(4, consultant_Leads_Dtls.getDivision());
			myStmt.setString(5, consultant_Leads_Dtls.getRemarks());
			myStmt.setString(6, consultant_Leads_Dtls.getCyr());
			myStmt.setString(7, consultant_Leads_Dtls.getCby());
			myStmt.setString(8, consultant_Leads_Dtls.getContactDetails());
			myStmt.setString(9, consultant_Leads_Dtls.getIsUpdateByBDM());
			myStmt.setString(10, consultant_Leads_Dtls.getConsultantType());
			myStmt.setString(11, consultant_Leads_Dtls.getIsUpdateByEVM());
			// execute sql query
			logType = myStmt.executeUpdate();

		} finally {
			// close jdbc objects

			close(myStmt, myRes);
			orcl.closeConnection();

		}

		return logType;
	}

	/*
	 * public List<ConsultantLeads> getAllConsultantLeadsDetails(String currYear)
	 * throws SQLException { int currentYear = Integer.parseInt(currYear); int
	 * prevYear = currentYear - 1; String oppStatus = ""; List<ConsultantLeads>
	 * consultantLeads = new ArrayList<>();
	 * 
	 * Connection myCon = null; // PreparedStatement myStmt = null; Statement myStmt
	 * = null; ResultSet myRes = null; MysqlDBConnectionPool con = new
	 * MysqlDBConnectionPool(); try {
	 * 
	 * // Get Connection myCon = con.getMysqlConn();
	 * 
	 * // Execute sql stamt String sql =
	 * " SELECT id,consultant,product,cnslt_status,division,remarks,created_date,updated_date,contact_details,byBDM FROM consultant_leads  order by updated_date desc "
	 * ; myStmt = myCon.createStatement(); // Execute a SQL query myRes =
	 * myStmt.executeQuery(sql);
	 * 
	 * // Process the result set while (myRes.next()) { String cnsltid =
	 * myRes.getString(1); String cnslt_name_temp = myRes.getString(2); //
	 * System.out.println("consultant debug : "+cnslt_name_temp); String
	 * product_temp = myRes.getString(3); String status_temp = myRes.getString(4);
	 * String division_temp = myRes.getString(5); ArrayList<String> productList =
	 * this.getProductListForSelDivn(division_temp); HashMap<String,
	 * ArrayList<String>> hashmap = new HashMap<String, ArrayList<String>>();
	 * hashmap.put(division_temp, productList); String remarks_temp =
	 * myRes.getString(6); String created_date_temp = myRes.getString(7); String
	 * updated_date_temp = myRes.getString(8); String contact_details =
	 * myRes.getString(9); String byBDM = myRes.getString(10); try { oppStatus =
	 * dateDiffStatus(updated_date_temp, created_date_temp);
	 * 
	 * // System.out.println(oppStatus); } catch (ParseException e) { // TODO
	 * Auto-generated catch block e.printStackTrace(); }
	 * 
	 * ConsultantLeads tempConsultantLeadsList = new ConsultantLeads(cnsltid,
	 * cnslt_name_temp, product_temp, status_temp, division_temp, remarks_temp,
	 * created_date_temp, updated_date_temp, oppStatus, hashmap, contact_details,
	 * byBDM);
	 * 
	 * consultantLeads.add(tempConsultantLeadsList);
	 * 
	 * } return consultantLeads;
	 * 
	 * } finally { // close jdbc objects close(myStmt, myRes);
	 * con.closeConnection();
	 * 
	 * } }
	 */
	public List<ConsultantLeads> getAllConsultantLeadsDetails(String currYear) throws SQLException {
		int currentYear = Integer.parseInt(currYear);
		int prevYear = currentYear - 1;
		String oppStatus = "";
		List<ConsultantLeads> consultantLeads = new ArrayList<>();

		Connection myCon = null;
		PreparedStatement myStmt = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();

		ResultSet myRes = null;
		try {

			// Get Connection
			myCon = orcl.getOrclConn();

			// Execute sql stamt
			String sql = " SELECT id,consultant,product,cnslt_status,division,remarks,created_date,updated_date,contact_details,byBDM,(select EMP_NAME from FJPORTAL.PM_EMP_KEY where EMP_CODE = CREATED_BY and EMP_END_OF_SERVICE_DT is null) AS CREATED_BY,CONSULTANT_TYPE,EOA FROM CONSULTANT_LEADS  order by updated_date desc ";
			myStmt = myCon.prepareStatement(sql);
			// Execute a SQL query
			myRes = myStmt.executeQuery(sql);

			// Process the result set
			while (myRes.next()) {
				String cnsltid = myRes.getString(1);
				String cnslt_name_temp = myRes.getString(2);
				// System.out.println("consultant debug : "+cnslt_name_temp);
				String product_temp = myRes.getString(3);
				String status_temp = myRes.getString(4);
				String division_temp = myRes.getString(5);
				ArrayList<String> productList = this.getProductListForSelDivn(division_temp);
				HashMap<String, ArrayList<String>> hashmap = new HashMap<String, ArrayList<String>>();
				hashmap.put(division_temp, productList);
				String remarks_temp = myRes.getString(6);
				String created_date_temp = myRes.getString(7);
				String updated_date_temp = myRes.getString(8);
				String contact_details = myRes.getString(9);
				String byBDM = myRes.getString(10);
				String createdBy = myRes.getString(11);
				String consultantType = myRes.getString(12);
				String byEOA = myRes.getString(13);
				try {
					oppStatus = dateDiffStatus(updated_date_temp, created_date_temp);

					// System.out.println(oppStatus);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				ConsultantLeads tempConsultantLeadsList = new ConsultantLeads(cnsltid, cnslt_name_temp, product_temp,
						status_temp, division_temp, remarks_temp, created_date_temp, updated_date_temp, oppStatus,
						hashmap, contact_details, byBDM, byEOA, createdBy, consultantType);

				consultantLeads.add(tempConsultantLeadsList);

			}
			return consultantLeads;

		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			orcl.closeConnection();

		}
	}

	public List<ConsultantLeads> getAllConsultantLeadsDetailsForSalesEng(String currYear, String companyCode,
			String divnCode) throws SQLException {
		int currentYear = Integer.parseInt(currYear);
		int prevYear = currentYear - 1;
		String oppStatus = "";
		List<ConsultantLeads> consultantLeads = new ArrayList<>();

		Connection myCon = null;
		PreparedStatement myStmt = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();

		ResultSet myRes = null;
		try {

			// Get Connection
			myCon = orcl.getOrclConn();

			// Execute sql stamt
			String sql = " SELECT id,consultant,product,cnslt_status,division,remarks,created_date,updated_date FROM CONSULTANT_LEADS where create_year in (?,?) and division in(?,?,'AD') order by updated_date desc ";
			myStmt = myCon.prepareStatement(sql);

			myStmt.setInt(1, prevYear);
			myStmt.setInt(2, currentYear);
			myStmt.setString(3, companyCode);
			myStmt.setString(4, divnCode);
			// Execute a SQL query
			myRes = myStmt.executeQuery();

			// Process the result set
			while (myRes.next()) {
				String cnsltid = myRes.getString(1);
				String cnslt_name_temp = myRes.getString(2);
				// System.out.println("consultant debug : "+cnslt_name_temp);
				String product_temp = myRes.getString(3);
				String status_temp = myRes.getString(4);
				String division_temp = myRes.getString(5);
				String remarks_temp = myRes.getString(6);
				String created_date_temp = myRes.getString(7);
				String updated_date_temp = myRes.getString(8);
				try {
					oppStatus = dateDiffStatus(updated_date_temp, created_date_temp);

					// System.out.println(oppStatus);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				ConsultantLeads tempConsultantLeadsList = new ConsultantLeads(cnsltid, cnslt_name_temp, product_temp,
						status_temp, division_temp, remarks_temp, created_date_temp, updated_date_temp, oppStatus);

				consultantLeads.add(tempConsultantLeadsList);

			}
			return consultantLeads;

		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			orcl.closeConnection();

		}
	}

	public List<ConsultantLeads> getAllDivisionList() throws SQLException {

		List<ConsultantLeads> divisionList = new ArrayList<>();
		String frz_value = "N";

		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		try {

			// Get Connection
			myCon = con.getMysqlConn();

			// Execute sql stamt
			String sql = " SELECT distinct division,divn_name,displayorder FROM  mkt_products  "
					+ "  WHERE frz_status = ?  order by  displayorder asc";
			myStmt = myCon.prepareStatement(sql);

			myStmt.setString(1, frz_value);
			myRes = myStmt.executeQuery();
			// Process the result set
			while (myRes.next()) {
				String dvn_code_tmp = myRes.getString(1);
				String dvn_name_temp = myRes.getString(2);

				ConsultantLeads tempdivisionList = new ConsultantLeads(dvn_code_tmp, dvn_name_temp);

				divisionList.add(tempdivisionList);

			}
			return divisionList;

		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			con.closeConnection();

		}
	}

	public void editUpdateConsultantLeads(ConsultantLeads updatedtls) throws SQLException {
		Connection myCon = null;
		PreparedStatement myStmt = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		System.out.print(updatedtls.getIsUpdateByEVM());
		ResultSet myRes = null;
		try {
			myCon = orcl.getOrclConn();

			String sql = "update CONSULTANT_LEADS set  cnslt_status =?, remarks=?, updated_date = SYSDATE,contact_details=?,product=?,eoa=?"
					+ " where id = ? ";

			// very important
			myStmt = myCon.prepareStatement(sql);

			myStmt.setString(1, updatedtls.getStatus());
			myStmt.setString(2, updatedtls.getRemarks());
			myStmt.setString(3, updatedtls.getContactDetails());
			myStmt.setString(4, updatedtls.getProduct());
			myStmt.setString(5, updatedtls.getIsUpdateByEVM());
			myStmt.setString(6, updatedtls.getCnslt_id());

			// execute sql query
			myStmt.execute();

		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			orcl.closeConnection();

		}
	}

	public void deleteUpdateConsultantLeads(String cid) throws SQLException {
		Connection myCon = null;
		PreparedStatement myStmt = null;
		OrclDBConnectionPool con = new OrclDBConnectionPool();
		try {
			myCon = con.getOrclConn();

			String sql = "delete from  consultant_leads  " + " where  id =? ";

			myStmt = myCon.prepareStatement(sql);
			myStmt.setString(1, cid);
			myStmt.execute();

		} finally {
			// close jdbc objects

			close(myStmt, null);
			con.closeConnection();

		}

	}

	public List<ConsultantLeads> getSerachResultConsultantleads(String search_word, String year) throws SQLException {
		// System.out.println("consultant debug : entered to vie all db");
		String oppStatus = "";
		List<ConsultantLeads> consultantLeads = new ArrayList<>();

		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		OrclDBConnectionPool con = new OrclDBConnectionPool();
		try {

			// Get Connection
			myCon = con.getOrclConn();

			// Execute sql stamt
			String sql = " SELECT id,consultant,product,cnslt_status,division,remarks,created_date,updated_date "
					+ " FROM CONSULTANT_LEADS where create_year = ? and consultant like ? ";
			myStmt = myCon.prepareStatement(sql);

			myStmt.setString(1, year);
			myStmt.setString(2, "%" + search_word + "%");
			// Execute a SQL query
			myRes = myStmt.executeQuery();

			// Process the result set
			while (myRes.next()) {
				String cnsltid = myRes.getString(1);
				String cnslt_name_temp = myRes.getString(2);
				// System.out.println("consultant debug : "+cnslt_name_temp);
				String product_temp = myRes.getString(3);
				String status_temp = myRes.getString(4);
				String division_temp = myRes.getString(5);
				String remarks_temp = myRes.getString(6);
				String created_date_temp = myRes.getString(7);
				String updated_date_temp = myRes.getString(8);
				try {
					oppStatus = dateDiffStatus(updated_date_temp, created_date_temp);

					// System.out.println(oppStatus);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				ConsultantLeads tempConsultantLeadsList = new ConsultantLeads(cnsltid, cnslt_name_temp, product_temp,
						status_temp, division_temp, remarks_temp, created_date_temp, updated_date_temp, oppStatus);

				consultantLeads.add(tempConsultantLeadsList);

			}
			return consultantLeads;

		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			con.closeConnection();

		}
	}

	public String dateDiffStatus(String updatedate, String createddate) throws ParseException {
		Calendar cal = Calendar.getInstance();
		String status = "";
		long diffD1 = 0, diffD2 = 0;
		SimpleDateFormat sdformat = new SimpleDateFormat("yyyy-MM-dd");
		java.util.Date d1 = sdformat.parse(updatedate);
		java.util.Date d2 = sdformat.parse(createddate);
		java.util.Date now = cal.getTime();
		diffD1 = (now.getTime() - d1.getTime()) / (1000 * 60 * 60 * 24);
		diffD2 = (now.getTime() - d2.getTime()) / (1000 * 60 * 60 * 24);
		// System.out.print(" d1d2comp "+d1.compareTo(d2)+" nowd1: "+(diffD1)+" nowd2:
		// "+diffD2);
		if ((d1.compareTo(d2) == 0) && (diffD2 <= 7)) {
			status = "(New)";
		} else if ((d1.compareTo(d2) > 0) && (diffD1 <= 7)) {
			status = "(Updated)";
		} else if (((d1.compareTo(d2) > 0) && (diffD2 > 7)) || ((d1.compareTo(d2) == 0) && (diffD2 > 7))) {
			status = " ";
		}
		return status;

	}

	public List<ConsultantLeads> getAllConsultantList() throws SQLException {

		List<ConsultantLeads> consultantsList = new ArrayList<>();
		String frz_value = "CONSULT";

		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		try {
			myCon = orcl.getOrclConn();
			String sql = " SELECT VSSV_CODE,VSSV_NAME FROM IM_VS_STATIC_VALUE WHERE VSSV_VS_CODE=? ORDER BY VSSV_NAME ";
			myStmt = myCon.prepareStatement(sql);
			myStmt.setString(1, frz_value);
			myRes = myStmt.executeQuery();
			while (myRes.next()) {
				String consultant_code_tmp = myRes.getString(1);
				String consultant_name_temp = myRes.getString(2);
				ConsultantLeads tempdivisionList = new ConsultantLeads(consultant_code_tmp, consultant_name_temp, "");
				consultantsList.add(tempdivisionList);
			}
			return consultantsList;

		} finally {
			close(myStmt, myRes);
			orcl.closeConnection();

		}
	}

	/*
	 * public List<ConsultantLeads> getConsultantProductreport(String[] emplList,
	 * String[] leave_type_list) throws SQLException {
	 * 
	 * List<ConsultantLeads> consultantLeads = new ArrayList<>(); Connection myCon =
	 * null; PreparedStatement myStmt = null; ResultSet myRes = null;
	 * 
	 * MysqlDBConnectionPool con = new MysqlDBConnectionPool(); try { StringBuilder
	 * sql = new StringBuilder("SELECT  * FROM   consultant_leads WHERE (");
	 * 
	 * myCon = con.getMysqlConn(); if (emplList.length > 0) { for (int i = 0; i <=
	 * emplList.length - 1; i++) { sql.append("FIND_IN_SET('" + emplList[i] +
	 * "', consultant)"); if (i < emplList.length - 1) { sql.append(" OR "); } } }
	 * if (leave_type_list.length > 0) { sql.append(") AND ("); for (int i = 0; i <=
	 * leave_type_list.length - 1; i++) { sql.append("FIND_IN_SET(" +
	 * leave_type_list[i] + ", product)"); if (i < leave_type_list.length - 1) {
	 * sql.append(" OR "); } } sql.append(") "); }
	 * System.out.println("query for the report " + sql); myStmt =
	 * myCon.prepareStatement(sql.toString()); myRes = myStmt.executeQuery();
	 * 
	 * // Process the result set while (myRes.next()) { String cnsltid =
	 * myRes.getString(1); String cnslt_name_temp = myRes.getString(2); String
	 * product_temp = myRes.getString(3); String status_temp = myRes.getString(4);
	 * String division_temp = myRes.getString(5); String remarks_temp =
	 * myRes.getString(6); ConsultantLeads tempConsultantLeadsList = new
	 * ConsultantLeads(cnslt_name_temp, product_temp, status_temp, division_temp,
	 * remarks_temp);
	 * 
	 * consultantLeads.add(tempConsultantLeadsList);
	 * 
	 * } return consultantLeads;
	 * 
	 * } finally { // close jdbc objects close(myStmt, myRes);
	 * con.closeConnection();
	 * 
	 * } }
	 */

	public List<MktSalesLeads> getProductList() throws SQLException {
		List<MktSalesLeads> productList = new ArrayList<>();

		Connection myCon = null;
		Statement myStmt = null;
		ResultSet myRes = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		try {
			myCon = con.getMysqlConn();

			String sql = "SELECT prduct from mkt_products  order by displayorder,division,prduct ";
			myStmt = myCon.createStatement();
			myRes = myStmt.executeQuery(sql);
			while (myRes.next()) {
				String product_tmp = myRes.getString(1);
				MktSalesLeads tempproductList = new MktSalesLeads(product_tmp);
				productList.add(tempproductList);
			}
			return productList;
		} finally {
			close(myStmt, myRes);
			con.closeConnection();
		}
	}

	public ArrayList<String> getDivisionNameForProducts(String products) throws SQLException {
		ArrayList<String> productList = new ArrayList<>();

		Connection myCon = null;
		Statement myStmt = null;
		ResultSet myRes = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		try {
			myCon = con.getMysqlConn();

			String sql = "SELECT divn_name from mkt_products where prduct IN (" + products
					+ ") order by displayorder,division,prduct ";
			System.out.println("sql in division name " + sql);
			myStmt = myCon.createStatement();
			myRes = myStmt.executeQuery(sql);
			while (myRes.next()) {
				String product_tmp = myRes.getString(1);
				productList.add(product_tmp);
			}
			return productList;
		} finally {
			close(myStmt, myRes);
			con.closeConnection();
		}
	}

	public ArrayList<String> getProductListForSelDivn(String divisionCode) throws SQLException {
		ArrayList<String> productList = new ArrayList<>();
		if (divisionCode.equals("AD")) {
			Connection myCon = null;
			Statement myStmt = null;
			ResultSet myRes = null;
			MysqlDBConnectionPool con = new MysqlDBConnectionPool();
			try {
				myCon = con.getMysqlConn();
				String sql = "SELECT distinct prduct from mkt_products  order by 1 asc ";
				myStmt = myCon.createStatement();
				myRes = myStmt.executeQuery(sql);
				while (myRes.next()) {
					String product_tmp = myRes.getString(1);
					productList.add(product_tmp);
				}
				return productList;
			} finally {
				close(myStmt, myRes);
				con.closeConnection();
			}
		} else {
			Connection myCon = null;
			PreparedStatement myStmt = null;
			ResultSet myRes = null;
			MysqlDBConnectionPool con = new MysqlDBConnectionPool();
			try {
				myCon = con.getMysqlConn();
				String sql = "SELECT prduct from mkt_products where division = ? order by 1 asc ";
				myStmt = myCon.prepareStatement(sql);
				myStmt.setString(1, divisionCode);
				myRes = myStmt.executeQuery();
				while (myRes.next()) {
					String product_tmp = myRes.getString(1);
					productList.add(product_tmp);
				}
				return productList;
			} finally {
				close(myStmt, myRes);
				con.closeConnection();
			}
		}

	}

	/*
	 * public String[][] getConsultantProductReport(String consulList, String
	 * productList, String[] consultantListUI, String[] prodListUI) throws
	 * SQLException {
	 * 
	 * Connection myCon = null; PreparedStatement myStmt = null; ResultSet myRes =
	 * null; String[][] consultantProduct = new String[consultantListUI.length +
	 * 2][prodListUI.length + 1]; OrclDBConnectionPool con = new
	 * OrclDBConnectionPool(); System.out.println("products" + productList);
	 * System.out.println("consulList" + consulList); try { String sql =
	 * "SELECT  * FROM   CONSULTANT_LEADS WHERE " + consulList;
	 * System.out.println("sql query " + sql); myCon = con.getOrclConn(); myStmt =
	 * myCon.prepareStatement(sql); myRes = myStmt.executeQuery(); int consCtr = 0;
	 * String cnslt_name_temp, cnslt_product_temp, EOA;
	 * 
	 * ArrayList<String> divisionListDB = getDivisionNameForProducts(productList);
	 * 
	 * String[] dbProductsStringArry = divisionListDB.toArray(new String[0]);
	 * 
	 * for (int i = 0; i < consultantListUI.length; i++) { consultantProduct[i +
	 * 2][0] = consultantListUI[i]; } for (int j = 0; j < prodListUI.length; j++) {
	 * consultantProduct[0][j + 1] = dbProductsStringArry[j]; consultantProduct[1][j
	 * + 1] = prodListUI[j]; }
	 * 
	 * while (myRes.next()) { consCtr = -1; cnslt_name_temp = myRes.getString(2);
	 * cnslt_product_temp = myRes.getString(3); EOA = myRes.getString(16);
	 * System.out.println("EPA" + EOA); for (int i = 0; i <
	 * consultantProduct.length; i++) {
	 * 
	 * System.out.println("DB Consultant" + cnslt_name_temp +
	 * " For loop consultant:" + i + " : " + consultantProduct[i][0]); if
	 * (cnslt_name_temp.equalsIgnoreCase(consultantProduct[i][0])) { consCtr = i;
	 * break; } }
	 * 
	 * ArrayList<String> consPrdlistDB = new
	 * ArrayList<>(Arrays.asList(cnslt_product_temp.split(","))); for (int j = 0; j
	 * < prodListUI.length; j++) { if (EOA == "Yes") {
	 * System.out.println("prodList:" + j + ":" + prodListUI[j]); if
	 * (consPrdlistDB.contains(prodListUI[j])) { consultantProduct[consCtr][j + 1] =
	 * "Yes+EOA"; } else { consultantProduct[consCtr][j + 1] = "Yes"; }
	 * 
	 * } } }
	 * 
	 * for (int i = 0; i < consultantListUI.length + 1; i++) { for (int j = 0; j <
	 * prodListUI.length + 1; j++) { System.out.println("prodList in for loop:" + j
	 * + ":" + consultantProduct[i][j]); if (i != 0 && (j != 0 || j != 1)) if
	 * (consultantProduct[i][j] == null) { consultantProduct[i][j] = ""; }
	 * 
	 * } } return consultantProduct;
	 * 
	 * } finally { // close jdbc objects close(myStmt, myRes);
	 * con.closeConnection();
	 * 
	 * } }
	 */
	public String[][] getConsultantProductReport(String consulList, String productList, String[] consultantListUI,

			String[] prodListUI) throws SQLException {

		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;

		String[][] consultantProduct = new String[consultantListUI.length + 2][prodListUI.length + 1];
		OrclDBConnectionPool con = new OrclDBConnectionPool();
		System.out.println("products" + productList);
		System.out.println("consulList" + consulList);

		try {
			String sql = "SELECT  CONSULTANT,PRODUCT,EOA FROM   CONSULTANT_LEADS WHERE " + consulList;
			System.out.println("sql query " + sql);
			myCon = con.getOrclConn();
			myStmt = myCon.prepareStatement(sql);
			myRes = myStmt.executeQuery();
			int consCtr = 0;
			String cnslt_name_temp, cnslt_product_temp, eoa, eoaString;

			ArrayList<String> divisionListDB = getDivisionNameForProducts(productList);
			String[] dbProductsStringArry = divisionListDB.toArray(new String[0]);

			for (int i = 0; i < consultantListUI.length; i++) {
				consultantProduct[i + 2][0] = consultantListUI[i];
			}

			for (int j = 0; j < prodListUI.length; j++) {
				consultantProduct[0][j + 1] = dbProductsStringArry[j];
				consultantProduct[1][j + 1] = prodListUI[j];
			}

			while (myRes.next()) {
				consCtr = -1;
				cnslt_name_temp = myRes.getString(1);
				cnslt_product_temp = myRes.getString(2);
				eoa = myRes.getString(3);

				if (eoa != null && eoa.equals("Yes")) {
					eoaString = " + EA";
				} else if (eoa != null && eoa.equals("No")) {
					eoaString = " + NEA";
				} else {
					eoaString = "";
				}

				for (int i = 0; i < consultantProduct.length; i++) {
					System.out.println("DB Consultant" + cnslt_name_temp + " For loop consultant:" + i + " : "
							+ consultantProduct[i][0]);
					if (cnslt_name_temp.equalsIgnoreCase(consultantProduct[i][0])) {
						consCtr = i;
						break;
					}
				}

				ArrayList<String> consPrdlistDB = new ArrayList<>(Arrays.asList(cnslt_product_temp.split(",")));
				for (int j = 0; j < prodListUI.length; j++) {
					System.out.println("prodList:" + j + ":" + prodListUI[j]);
					if (consPrdlistDB.contains(prodListUI[j])) {
						consultantProduct[consCtr][j + 1] = "Yes" + eoaString;
					}
				}

			}

			for (int i = 0; i < consultantListUI.length + 1; i++) {
				for (int j = 0; j < prodListUI.length + 1; j++) {
					System.out.println("prodList in for loop:" + j + ":" + consultantProduct[i][j]);
					if (i != 0 && (j != 0 || j != 1))
						if (consultantProduct[i][j] == null) {
							consultantProduct[i][j] = "";
						}
				}
			}

			return consultantProduct;

		} finally {
			// close jdbc objects

			close(myStmt, myRes);
			con.closeConnection();

		}

	}

	public List<ConsultantVisits> getAllConsultantVisitDetails(String currYear) throws SQLException {

		List<ConsultantVisits> consultantVisits = new ArrayList<>();

		Connection myCon = null;
		// PreparedStatement myStmt = null;
		Statement myStmt = null;
		ResultSet myRes = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		try {

			// Get Connection
			myCon = con.getMysqlConn();

			// Execute sql stamt
			String sql = " SELECT * FROM consultant_visits ";
			myStmt = myCon.createStatement();
			// Execute a SQL query
			myRes = myStmt.executeQuery(sql);

			// Process the result set
			while (myRes.next()) {
				String cnslt_name_temp = myRes.getString(1);
				Date visit_date = myRes.getDate(2);
				String visit_reason = myRes.getString(3);
				int noof_attendees = myRes.getInt(4);
				String meetingperson_details = myRes.getString(5);
				String meeting_notes = myRes.getString(6);
				String empcode = myRes.getString(8);
				String division = myRes.getString(9);
				String product = myRes.getString(10);
				String consultantType = myRes.getString(11);
				ConsultantVisits tempConsultantVisitssList = new ConsultantVisits(cnslt_name_temp, visit_reason,
						visit_date, noof_attendees, meetingperson_details, meeting_notes, empcode, division, product,
						consultantType);
				consultantVisits.add(tempConsultantVisitssList);

			}
			return consultantVisits;

		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			con.closeConnection();

		}
	}

	public int createnewConsultantVisits(ConsultantVisits consultant_Visits_Dtls) throws SQLException {

		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		int logType = 0;
		try {
			myCon = con.getMysqlConn();

			String sql = "insert into consultant_visits(consultant,visit_date,visit_reason,noof_attendees,meetingperson_details,meeting_notes,empid,created_on,division,product,consultantType) values(?,?,?,?,?,?,?,sysdate(),?,?,?)";

			// very important
			myStmt = myCon.prepareStatement(sql);

			// set the param values for the student
			myStmt.setString(1, consultant_Visits_Dtls.getConslt_name());
			myStmt.setDate(2, consultant_Visits_Dtls.getDate());
			myStmt.setString(3, consultant_Visits_Dtls.getVisit_reason());
			myStmt.setInt(4, consultant_Visits_Dtls.getNoofattendees());
			myStmt.setString(5, consultant_Visits_Dtls.getMeetingperson_details());
			myStmt.setString(6, consultant_Visits_Dtls.getMeeting_notes());
			myStmt.setString(7, consultant_Visits_Dtls.getEmployee_Code());
			myStmt.setString(8, consultant_Visits_Dtls.getDivision());
			myStmt.setString(9, consultant_Visits_Dtls.getProduct());
			myStmt.setString(10, consultant_Visits_Dtls.getConsultantType());
			// execute sql query
			logType = myStmt.executeUpdate();

		} catch (SQLIntegrityConstraintViolationException ex) {
			logType = -1;
		} catch (Exception e) {
			System.out.println("Exception " + e);
		} finally {
			// close jdbc objects

			close(myStmt, myRes);
			con.closeConnection();

		}

		return logType;
	}

	public MktSalesLeads getConsultantType(String consultant) throws SQLException {

		MktSalesLeads consultantType = null;
		String frz_value = "CONSULT";
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();

		try {
			myCon = orcl.getOrclConn();
			String sql = " SELECT VSSV_BL_SHORT_NAME FROM IM_VS_STATIC_VALUE WHERE VSSV_VS_CODE=? AND VSSV_NAME=? ORDER BY VSSV_NAME ";
			myStmt = myCon.prepareStatement(sql);
			myStmt.setString(1, frz_value);
			myStmt.setString(2, consultant);
			myRes = myStmt.executeQuery();
			while (myRes.next()) {
				String product_tmp = myRes.getString(1);
				System.out.println("product_tmp== " + product_tmp);
				consultantType = new MktSalesLeads(product_tmp);
			}
			return consultantType;

		} finally {
			close(myStmt, myRes);
			orcl.closeConnection();
		}

	}
}
