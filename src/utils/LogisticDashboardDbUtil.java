package utils;

//import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
//import java.util.Calendar;
import java.util.List;
//import java.util.Random; 

import beans.EmailLogistic;
import beans.Logistic;
import beans.MysqlDBConnectionPool;
import beans.OrclDBConnectionPool;
//import sun.misc.BASE64Decoder;
//import sun.misc.BASE64Encoder;  

public class LogisticDashboardDbUtil {

	public Logistic getDivsionEmployeeAccessStatus(String empCode) throws SQLException {
		Logistic permissionData = new Logistic(0, "");
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		try {
			myCon = orcl.getOrclConn();
			String sql = "  SELECT * FROM ( " + "    SELECT PO_CODE \"CODE\", EMP_CODE, DM_CODE FROM  LOG_DB_DIVN_EMP  "
					+ "    UNION " + "    SELECT INV_CODE \"CODE\", EMP_CODE, DM_CODE FROM  DEL_DB_DIVN_EMP " + ") "
					+ " WHERE EMP_CODE = ? AND ROWNUM=1 ";
			myStmt = myCon.prepareStatement(sql);
			myStmt.setString(1, empCode);
			myRes = myStmt.executeQuery();
			if (myRes.next()) {
				String txnCode = myRes.getString(1);
				permissionData = new Logistic(1, txnCode);
			}
			return permissionData;
		} finally {
			close(myStmt, myRes);
			orcl.closeConnection();
		}

	}

	public List<Logistic> getCompleteLiveOrders(String divnCode) throws SQLException {
		String orderCodition = "EX_FAC_DATE DESC";
		List<Logistic> poList = new ArrayList<>();
		Connection myCon = null;
		Statement myStmt = null;
		ResultSet myRes = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		try {
			myCon = orcl.getOrclConn();
			String sql = "SELECT PH_SYS_ID,COMP,PONO,PO_DATE,SUPPLIER,PMT_TERMS,TERMS_SHIP,MODE_SHIP,CONTAINER,EX_FAC_DATE,CONT_DET,PICK_LOCN,DIVN_REMARKS, "
					+ " DIVN_UPD_BY, (SELECT EMP_NAME FROM FJPORTAL.PM_EMP_KEY WHERE EMP_CODE = DIVN_UPD_BY AND ROWNUM = 1 ) DIV_EMP_NAME,DIVN_UPD_DT,  "
					+ " PAYMENT_STAT,FIN_REMARKS, "
					+ " FIN_UPD_BY,  (SELECT EMP_NAME FROM FJPORTAL.PM_EMP_KEY WHERE EMP_CODE = FIN_UPD_BY AND ROWNUM = 1 ) FIN_EMP_NAME,FIN_UPD_DT, "
					+ " ETD,ETA,LOG_REMARKS, "
					+ " LOG_UPD_BY,  (SELECT EMP_NAME FROM FJPORTAL.PM_EMP_KEY WHERE EMP_CODE = LOG_UPD_BY AND ROWNUM = 1 ) LOG_EMP_NAME,LOG_UPD_DT, "
					+ " FULLGRN, REFERENCE, FINAL_DEST, SHIP_DOC_STAT, RE_EXPORT,DELIVERY_STATUS "
					+ " FROM FJPORTAL.LOG_DB_TXN WHERE NVL(FULLGRN,'N')='Y'  ORDER BY LINE_NO , " + orderCodition
					+ ", PONO DESC";
			myStmt = myCon.createStatement();
			myRes = myStmt.executeQuery(sql);
			while (myRes.next()) {
				String id = encrypt(myRes.getString(1));
				String company = myRes.getString(2);
				String poNumber = myRes.getString(3);
				String poDate = myRes.getString(4);
				String supplier = myRes.getString(5);
				String paymentTerms = myRes.getString(6);
				String shipmentTerm = myRes.getString(7);
				String shipmentMode = myRes.getString(8);
				int noOfContainers = myRes.getInt(9);
				String exFactoryDate = myRes.getString(10);
				String contactDetails = myRes.getString(11);
				String pickLocation = myRes.getString(12);
				String divnRemarks = myRes.getString(13);
				String divnUpdatedBy = myRes.getString(14);
				String divnEmpName = myRes.getString(15);
				String divnUpdatedDate = myRes.getString(16);
				String paymentStatus = myRes.getString(17);
				String finRemarks = myRes.getString(18);
				String finUpdatedBy = myRes.getString(19);
				String finEmpName = myRes.getString(20);
				String finUpdatedDate = myRes.getString(21);
				String expTimeDeparture = myRes.getString(22);
				String expTimeArrival = myRes.getString(23);
				String logisticRemark = myRes.getString(24);
				String logisticUpdBy = myRes.getString(25);
				String logEmpName = myRes.getString(26);
				String logisticUpdDate = myRes.getString(27);
				String fullGrn = myRes.getString(28);
				String reference = myRes.getString(29);
				String finalDestination = myRes.getString(30);
				String shipDocsStatus = myRes.getString(31);
				String reExport = myRes.getString(32);
				String deliveryStatus = myRes.getString(33);
				Logistic tempPoList = new Logistic(id, company, poNumber, poDate, supplier, paymentTerms, shipmentTerm,
						shipmentMode, noOfContainers, exFactoryDate, contactDetails, pickLocation, divnRemarks,
						divnUpdatedBy, divnEmpName, divnUpdatedDate, paymentStatus, finRemarks, finUpdatedBy,
						finEmpName, finUpdatedDate, expTimeDeparture, expTimeArrival, logisticRemark, logisticUpdBy,
						logEmpName, logisticUpdDate, fullGrn, reference, finalDestination, shipDocsStatus, reExport,
						deliveryStatus);
				poList.add(tempPoList);
			}
			return poList;
		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			orcl.closeConnection();
		}
	}

	public List<Logistic> getCompletePODetails(String divnCode) throws SQLException {

		List<Logistic> poList = new ArrayList<>();
		Connection myCon = null;
		Statement myStmt = null;
		ResultSet myRes = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		try {
			myCon = orcl.getOrclConn();
			String sql = "SELECT PH_SYS_ID,COMP,PONO,PO_DATE,SUPPLIER,PMT_TERMS,TERMS_SHIP,MODE_SHIP,CONTAINER,EX_FAC_DATE,CONT_DET,PICK_LOCN,DIVN_REMARKS, "
					+ " DIVN_UPD_BY, (SELECT EMP_NAME FROM FJPORTAL.PM_EMP_KEY WHERE EMP_CODE = DIVN_UPD_BY AND ROWNUM = 1 ) DIV_EMP_NAME,DIVN_UPD_DT,  "
					+ " PAYMENT_STAT,FIN_REMARKS, "
					+ " FIN_UPD_BY,  (SELECT EMP_NAME FROM FJPORTAL.PM_EMP_KEY WHERE EMP_CODE = FIN_UPD_BY AND ROWNUM = 1 ) FIN_EMP_NAME,FIN_UPD_DT, "
					+ " ETD,ETA,LOG_REMARKS, "
					+ " LOG_UPD_BY,  (SELECT EMP_NAME FROM FJPORTAL.PM_EMP_KEY WHERE EMP_CODE = LOG_UPD_BY AND ROWNUM = 1 ) LOG_EMP_NAME,LOG_UPD_DT, "
					+ " FULLGRN, REFERENCE, FINAL_DEST, SHIP_DOC_STAT, RE_EXPORT,DELIVERY_STATUS,NOMINATED_ON,FREIGHT_AMT,INSURANCE_AMT,FORWARDER_NAME,CURRENCY,LINE_NO  "
					+ " FROM FJPORTAL.LOG_DB_TXN WHERE NVL(FULLGRN,'N')='N' AND EX_FAC_DATE IS NOT NULL ORDER BY "
					+ " PONO , LINE_NO,  EX_FAC_DATE ASC";
			myStmt = myCon.createStatement();
			myRes = myStmt.executeQuery(sql);
			while (myRes.next()) {
				String id = encrypt(myRes.getString(1));
				String company = myRes.getString(2);
				String poNumber = myRes.getString(3);
				String poDate = myRes.getString(4);
				String supplier = myRes.getString(5);
				String paymentTerms = myRes.getString(6);
				String shipmentTerm = myRes.getString(7);
				String shipmentMode = myRes.getString(8);
				int noOfContainers = myRes.getInt(9);
				String exFactoryDate = myRes.getString(10);
				String contactDetails = myRes.getString(11);
				String pickLocation = myRes.getString(12);
				String divnRemarks = myRes.getString(13);
				String divnUpdatedBy = myRes.getString(14);
				String divnEmpName = myRes.getString(15);
				String divnUpdatedDate = myRes.getString(16);
				String paymentStatus = myRes.getString(17);
				String finRemarks = myRes.getString(18);
				String finUpdatedBy = myRes.getString(19);
				String finEmpName = myRes.getString(20);
				String finUpdatedDate = myRes.getString(21);
				String expTimeDeparture = myRes.getString(22);
				String expTimeArrival = myRes.getString(23);
				String logisticRemark = myRes.getString(24);
				String logisticUpdBy = myRes.getString(25);
				String logEmpName = myRes.getString(26);
				String logisticUpdDate = myRes.getString(27);
				String fullGrn = myRes.getString(28);
				String reference = myRes.getString(29);
				String finalDestination = myRes.getString(30);
				String shipDocsStatus = myRes.getString(31);
				String reExport = myRes.getString(32);
				String deliverystatus = myRes.getString(33);
				String nominatedOn = myRes.getString(34);
				int freightCharges = myRes.getInt(35);
				int insuranceCharges = myRes.getInt(36);
				String forwardedName = myRes.getString(37);
				String currencyType = myRes.getString(38);
				int lineNo = myRes.getInt(39);
				Logistic tempPoList = new Logistic(id, company, poNumber, poDate, supplier, paymentTerms, shipmentTerm,
						shipmentMode, noOfContainers, exFactoryDate, contactDetails, pickLocation, divnRemarks,
						divnUpdatedBy, divnEmpName, divnUpdatedDate, paymentStatus, finRemarks, finUpdatedBy,
						finEmpName, finUpdatedDate, expTimeDeparture, expTimeArrival, logisticRemark, logisticUpdBy,
						logEmpName, logisticUpdDate, fullGrn, reference, finalDestination, shipDocsStatus, reExport,
						deliverystatus, nominatedOn, currencyType, freightCharges, insuranceCharges, forwardedName,
						lineNo);
				poList.add(tempPoList);
			}
			return poList;
		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			orcl.closeConnection();
		}
	}

	public List<Logistic> getPODetailsforTXNCode(String empCode) throws SQLException {
		List<Logistic> poList = new ArrayList<>();
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		try {
			myCon = orcl.getOrclConn();
			String sql = "SELECT PH_SYS_ID, COMP, PONO, PO_DATE, SUPPLIER, PMT_TERMS, TERMS_SHIP, MODE_SHIP, CONTAINER, EX_FAC_DATE, CONT_DET, PICK_LOCN, DIVN_REMARKS, "
					+ " DIVN_UPD_BY, (SELECT EMP_NAME FROM FJPORTAL.PM_EMP_KEY WHERE EMP_CODE = DIVN_UPD_BY AND ROWNUM = 1 ) DIV_EMP_NAME,DIVN_UPD_DT,  "
					+ " PAYMENT_STAT, FIN_REMARKS, "
					+ " FIN_UPD_BY,  (SELECT EMP_NAME FROM FJPORTAL.PM_EMP_KEY WHERE EMP_CODE = FIN_UPD_BY AND ROWNUM = 1 ) FIN_EMP_NAME, FIN_UPD_DT, "
					+ " ETD,ETA, LOG_REMARKS, "
					+ " LOG_UPD_BY,  (SELECT EMP_NAME FROM FJPORTAL.PM_EMP_KEY WHERE EMP_CODE = LOG_UPD_BY AND ROWNUM = 1 ) LOG_EMP_NAME,LOG_UPD_DT, "
					+ " FULLGRN, REFERENCE, FINAL_DEST, SHIP_DOC_STAT, RE_EXPORT, DELIVERY_STATUS, NOMINATED_ON,FREIGHT_AMT,INSURANCE_AMT,FORWARDER_NAME,CURRENCY,LINE_NO "
					+ " FROM FJPORTAL.LOG_DB_TXN WHERE "
					+ " REGEXP_LIKE (PONO, (SELECT LISTAGG(PO_CODE,'|') WITHIN GROUP (ORDER BY PO_CODE) list"
					+ "  FROM LOG_DB_DIVN_EMP  WHERE EMP_CODE = ?  ), 'i') " + " AND  NVL(FULLGRN,'N')='N' ORDER BY  "
					+ " PONO , LINE_NO, EX_FAC_DATE ASC";
			myStmt = myCon.prepareStatement(sql);
			myStmt.setString(1, empCode);
			myRes = myStmt.executeQuery();
			while (myRes.next()) {
				String id = encrypt(myRes.getString(1));
				String company = myRes.getString(2);
				String poNumber = myRes.getString(3);
				String poDate = myRes.getString(4);
				String supplier = myRes.getString(5);
				String paymentTerms = myRes.getString(6);
				String shipmentTerm = myRes.getString(7);
				String shipmentMode = myRes.getString(8);
				int noOfContainers = myRes.getInt(9);
				String exFactoryDate = myRes.getString(10);
				String contactDetails = myRes.getString(11);
				String pickLocation = myRes.getString(12);
				String divnRemarks = myRes.getString(13);
				String divnUpdatedBy = myRes.getString(14);
				String divnEmpName = myRes.getString(15);
				String divnUpdatedDate = myRes.getString(16);
				String paymentStatus = myRes.getString(17);
				String finRemarks = myRes.getString(18);
				String finUpdatedBy = myRes.getString(19);
				String finEmpName = myRes.getString(20);
				String finUpdatedDate = myRes.getString(21);
				String expTimeDeparture = myRes.getString(22);
				String expTimeArrival = myRes.getString(23);
				String logisticRemark = myRes.getString(24);
				String logisticUpdBy = myRes.getString(25);
				String logEmpName = myRes.getString(26);
				String logisticUpdDate = myRes.getString(27);
				String fullGrn = myRes.getString(28);
				String reference = myRes.getString(29);
				String finalDestination = myRes.getString(30);
				String shipDocsStatus = myRes.getString(31);
				String reExport = myRes.getString(32);
				String deliveryStatus = myRes.getString(33);
				String nominatedOn = myRes.getString(34);
				int freightCharges = myRes.getInt(35);
				int insuranceCharges = myRes.getInt(36);
				String forwardedName = myRes.getString(37);
				String currencyType = myRes.getString(38);
				int lineNo = myRes.getInt(39);
				Logistic tempPoList = new Logistic(id, company, poNumber, poDate, supplier, paymentTerms, shipmentTerm,
						shipmentMode, noOfContainers, exFactoryDate, contactDetails, pickLocation, divnRemarks,
						divnUpdatedBy, divnEmpName, divnUpdatedDate, paymentStatus, finRemarks, finUpdatedBy,
						finEmpName, finUpdatedDate, expTimeDeparture, expTimeArrival, logisticRemark, logisticUpdBy,
						logEmpName, logisticUpdDate, fullGrn, reference, finalDestination, shipDocsStatus, reExport,
						deliveryStatus, nominatedOn, currencyType, freightCharges, insuranceCharges, forwardedName,
						lineNo);
				poList.add(tempPoList);
			}
			return poList;
		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			orcl.closeConnection();
		}
	}

	public List<Logistic> getPODetailsforTXNCodeForDM(String dmCode) throws SQLException {

		List<Logistic> poList = new ArrayList<>();
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		try {
			myCon = orcl.getOrclConn();
			String sql = "SELECT PH_SYS_ID, COMP, PONO, PO_DATE, SUPPLIER, PMT_TERMS, TERMS_SHIP, MODE_SHIP, CONTAINER, EX_FAC_DATE, CONT_DET, PICK_LOCN, DIVN_REMARKS, "
					+ "  DIVN_UPD_BY, (SELECT EMP_NAME FROM FJPORTAL.PM_EMP_KEY WHERE EMP_CODE = DIVN_UPD_BY AND ROWNUM = 1 ) DIV_EMP_NAME,DIVN_UPD_DT,  "
					+ "  PAYMENT_STAT, FIN_REMARKS, "
					+ "  FIN_UPD_BY,  (SELECT EMP_NAME FROM FJPORTAL.PM_EMP_KEY WHERE EMP_CODE = FIN_UPD_BY AND ROWNUM = 1 ) FIN_EMP_NAME, FIN_UPD_DT, "
					+ " ETD,ETA, LOG_REMARKS, "
					+ " LOG_UPD_BY,  (SELECT EMP_NAME FROM FJPORTAL.PM_EMP_KEY WHERE EMP_CODE = LOG_UPD_BY AND ROWNUM = 1 ) LOG_EMP_NAME,LOG_UPD_DT, "
					+ " FULLGRN, REFERENCE, FINAL_DEST, SHIP_DOC_STAT, RE_EXPORT, DELIVERY_STATUS, NOMINATED_ON,FREIGHT_AMT,INSURANCE_AMT,FORWARDER_NAME,CURRENCY  "
					+ " FROM FJPORTAL.LOG_DB_TXN WHERE "
					+ " REGEXP_LIKE (PONO, (SELECT LISTAGG(PO_CODE,'|') WITHIN GROUP (ORDER BY PO_CODE) list"
					+ "  FROM LOG_DB_DIVN_EMP  WHERE DM_CODE = ?  ), 'i') " + " AND  NVL(FULLGRN,'N')='N' ORDER BY   "
					+ " PONO , LINE_NO, EX_FAC_DATE ASC";
			myStmt = myCon.prepareStatement(sql);
			myStmt.setString(1, dmCode);
			myRes = myStmt.executeQuery();
			while (myRes.next()) {
				String id = encrypt(myRes.getString(1));
				String company = myRes.getString(2);
				String poNumber = myRes.getString(3);
				String poDate = myRes.getString(4);
				String supplier = myRes.getString(5);
				String paymentTerms = myRes.getString(6);
				String shipmentTerm = myRes.getString(7);
				String shipmentMode = myRes.getString(8);
				int noOfContainers = myRes.getInt(9);
				String exFactoryDate = myRes.getString(10);
				String contactDetails = myRes.getString(11);
				String pickLocation = myRes.getString(12);
				String divnRemarks = myRes.getString(13);
				String divnUpdatedBy = myRes.getString(14);
				String divnEmpName = myRes.getString(15);
				String divnUpdatedDate = myRes.getString(16);
				String paymentStatus = myRes.getString(17);
				String finRemarks = myRes.getString(18);
				String finUpdatedBy = myRes.getString(19);
				String finEmpName = myRes.getString(20);
				String finUpdatedDate = myRes.getString(21);
				String expTimeDeparture = myRes.getString(22);
				String expTimeArrival = myRes.getString(23);
				String logisticRemark = myRes.getString(24);
				String logisticUpdBy = myRes.getString(25);
				String logEmpName = myRes.getString(26);
				String logisticUpdDate = myRes.getString(27);
				String fullGrn = myRes.getString(28);
				String reference = myRes.getString(29);
				String finalDestination = myRes.getString(30);
				String shipDocsStatus = myRes.getString(31);
				String reExport = myRes.getString(32);
				String deliveryStatus = myRes.getString(33);
				String nominatedOn = myRes.getString(34);
				int freightCharges = myRes.getInt(35);
				int insuranceCharges = myRes.getInt(36);
				String forwardedName = myRes.getString(37);
				String currencyType = myRes.getString(38);
				Logistic tempPoList = new Logistic(id, company, poNumber, poDate, supplier, paymentTerms, shipmentTerm,
						shipmentMode, noOfContainers, exFactoryDate, contactDetails, pickLocation, divnRemarks,
						divnUpdatedBy, divnEmpName, divnUpdatedDate, paymentStatus, finRemarks, finUpdatedBy,
						finEmpName, finUpdatedDate, expTimeDeparture, expTimeArrival, logisticRemark, logisticUpdBy,
						logEmpName, logisticUpdDate, fullGrn, reference, finalDestination, shipDocsStatus, reExport,
						deliveryStatus, nominatedOn, currencyType, freightCharges, insuranceCharges, forwardedName);
				poList.add(tempPoList);
			}
			return poList;
		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			orcl.closeConnection();
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

	public int updatePODetailsByDivision(Logistic poDetails, String lineNO) {
		int convertLine = Integer.parseInt(lineNO);

		System.out.println(convertLine);
		System.out.println("came");
		String id = decrypt(poDetails.getId());
		System.out.println(id);
		int logType = -2;
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		try {
			myCon = orcl.getOrclConn();
			if (myCon == null)
				return -2;

			String sql = " UPDATE FJPORTAL.LOG_DB_TXN  " + " SET "
			// + "TERMS_SHIP = ?,"
					+ " MODE_SHIP =?, CONTAINER = ?, EX_FAC_DATE = ?, CONT_DET=?, PICK_LOCN=?, DIVN_REMARKS=?, FINAL_DEST = ?,  DIVN_UPD_DT  = SYSDATE, DIVN_UPD_BY = ?,  RE_EXPORT = ?  "
					// + "CFDATE = ? "
					+ " WHERE PH_SYS_ID = ? AND LINE_NO=? AND NVL(FULLGRN,'N')='N'  AND LOG_UPD_BY IS NULL";
			// + "AND FIN_UPD_BY IS NULL AND LOG_UPD_BY IS NULL ";// Removed condition as
			// per mngment dcsn
			myStmt = myCon.prepareStatement(sql);
			System.out.println("come2");
			// myStmt.setString(1, poDetails.getShipmentTerm());
			myStmt.setString(1, poDetails.getShipmentMode());
			myStmt.setInt(2, poDetails.getNoOfContainers());
			myStmt.setDate(3, getSqlDate(poDetails.getExFactoryDate()));
			myStmt.setString(4, poDetails.getContactDetails());
			myStmt.setString(5, poDetails.getPickLocation());
			myStmt.setString(6, poDetails.getDivnRemarks());
			myStmt.setString(7, poDetails.getFinalDestination());
			myStmt.setString(8, poDetails.getDivnUpdatedBy());
			myStmt.setString(9, poDetails.getReExport());
			// myStmt.setDate(11, getSqlDate(poDetails.getCandFETADate()));
			myStmt.setString(10, id);
			myStmt.setInt(11, convertLine);
			logType = myStmt.executeUpdate();
			System.out.println("LOG VALUE : " + logType);
		} catch (SQLException ex) {
			logType = -2;
			System.out.println("Exception in closing DB resources at the time updating division user po details by "
					+ poDetails.getDivnUpdatedBy() + "  for id  " + id + " log = " + logType + "");
			ex.printStackTrace();
		} finally {
			// close jdbc objects
			System.out.println("data is updated");
			close(myStmt, myRes);
			orcl.closeConnection();
			// System.out.println("Updated and closed db Successfully ");
		}
		return logType;
	}

	public int updatePODetailsByFinance(Logistic poDetails) {
		String id = decrypt(poDetails.getId());
		int logType = -2;
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		try {
			myCon = orcl.getOrclConn();
			if (myCon == null)
				return -2;

			String sql = " UPDATE FJPORTAL.LOG_DB_TXN   "
					+ " SET PAYMENT_STAT = ?, FIN_REMARKS = ?, FIN_UPD_DT  = SYSDATE, FIN_UPD_BY = ? "
					+ " WHERE PH_SYS_ID = ? AND NVL(FULLGRN,'N')='N' "
					// + "AND DIVN_UPD_BY IS NOT NULL AND LOG_UPD_BY IS NULL ";// commented as per
					// no checs nooded expect divn entry, added below condition
					+ "  AND DIVN_UPD_BY IS NOT NULL ";
			myStmt = myCon.prepareStatement(sql);
			myStmt.setString(1, poDetails.getPaymentStatus());
			myStmt.setString(2, poDetails.getFinRemarks());
			myStmt.setString(3, poDetails.getFinUpdatedBy());
			myStmt.setString(4, id);

			logType = myStmt.executeUpdate();
			// System.out.println("LOG VALUE : "+logType);
		} catch (SQLException ex) {
			logType = -2;
			System.out.println("Exception in closing DB resources at the time updating finance user po details by "
					+ poDetails.getDivnUpdatedBy() + " for id  " + id + " log = " + logType + "");
			ex.printStackTrace();
		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			orcl.closeConnection();
			// System.out.println("Updated and closed db Successfully ");
		}
		return logType;
	}

	public int updatePODetailsByLogistic(Logistic poDetails, String lineNO) {
		int convertLine = Integer.parseInt(lineNO);

		String id = decrypt(poDetails.getId());
		int logType = -2;
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		try {
			myCon = orcl.getOrclConn();
			if (myCon == null)
				return -2;
			// removed reference number as it is not a editable field and added status of
			// delivery as per logistics team
			String sql = " UPDATE FJPORTAL.LOG_DB_TXN   "
					+ " SET ETD = ?, ETA = ?, LOG_REMARKS=?,   LOG_UPD_DT  = SYSDATE, LOG_UPD_BY = ? , DELIVERY_STATUS=?, SHIP_DOC_STAT = ?, NOMINATED_ON = ?,FREIGHT_AMT = ?,INSURANCE_AMT = ? , FORWARDER_NAME = ?, CURRENCY = ?"
					+ " WHERE PH_SYS_ID = ?  AND LINE_NO=?  AND NVL(FULLGRN,'N')='N' "
					// + "AND FIN_UPD_BY IS NOT NULL AND DIVN_UPD_BY IS NOT NULL "; // commented as
					// per no checs nooded expect divn entry, added below condition
					+ "  AND DIVN_UPD_BY IS NOT NULL ";
			myStmt = myCon.prepareStatement(sql);
			myStmt.setDate(1, getSqlDate(poDetails.getExpTimeDeparture()));
			myStmt.setDate(2, getSqlDate(poDetails.getExpTimeArrival()));
			myStmt.setString(3, poDetails.getLogisticRemark());
			myStmt.setString(4, poDetails.getLogisticUpdBy());
			// myStmt.setString(5, poDetails.getReference());
			myStmt.setString(5, poDetails.getDeliveryStatus());
			myStmt.setString(6, poDetails.getShipDocStatus());
			myStmt.setDate(7, getSqlDate(poDetails.getNominatedOn()));
			myStmt.setInt(8, poDetails.getFreightCharges());
			myStmt.setInt(9, poDetails.getInsuranceCharges());
			myStmt.setString(10, poDetails.getForwardedName());
			myStmt.setString(11, poDetails.getCurrency());
			myStmt.setString(12, id);
			myStmt.setInt(13, convertLine);

			logType = myStmt.executeUpdate();
			System.out.println("updatePODetailsByLogistic LOG VALUE : " + logType);
		} catch (SQLException ex) {
			logType = -2;
			System.out.println("Exception in closing DB resources at the time updating Logistic user po details by "
					+ poDetails.getDivnUpdatedBy() + "  for id  " + id + " log = " + logType + "");
			ex.printStackTrace();
		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			orcl.closeConnection();
			// System.out.println("Updated and closed db Successfully ");
		}
		return logType;
	}

	public Date getSqlDate(String str) {
		if (str == null || str.equals("") || str.isEmpty()) {
			return null;
		} else {
			DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
			Date date;
			java.util.Date dt;
			try {
				dt = formatter.parse(str);
				// System.out.println(dt);
				date = new Date(dt.getTime());
			} catch (ParseException ex) {
				ex.printStackTrace();
				date = null;
			}

			// System.out.println(date);
			return date;
		}
	}

	private String encrypt(String str) {
//	    	 Random rand = new Random();
//	         BASE64Encoder encoder = new BASE64Encoder();	 
//	         byte[] salt = new byte[8];
//	         rand.nextBytes(salt);
//	         return encoder.encode(salt) + encoder.encode(str.getBytes());	  
		return str;
	}

	private String decrypt(String encstr) {
//	    	String decyptedVal = "notValid";
//	    	if (encstr.length() > 12) {	    	 
//	    		String cipher = encstr.substring(12);	    	 
//	    		BASE64Decoder decoder = new BASE64Decoder();	    	 
//	    		try {	    	 
//	    			decyptedVal =  new String(decoder.decodeBuffer(cipher));	    	 
//	    		} catch (IOException e) { 
//	    			decyptedVal = "notValid";
//	    		  	e.printStackTrace(); 
//	    		}	    		   	    	 
//	    	}
//	    	 return decyptedVal;
		return encstr;

	}

	public boolean checkDMLogisticDashbaordAccess(String empCode) {
		boolean logType = false;
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		try {
			myCon = orcl.getOrclConn();
			String sql = " SELECT * FROM FJPORTAL.LOG_DB_DIVN_EMP  " + " WHERE DM_CODE = ? AND ROWNUM=1 ";
			myStmt = myCon.prepareStatement(sql);
			myStmt.setString(1, empCode);
			myRes = myStmt.executeQuery();
			if (myRes.next()) {
				logType = true;
			}
		} catch (SQLException ex) {
			logType = false;
			System.out.println("Exception in closing DB resources at  DM lg db permission check");
			ex.printStackTrace();
		} finally {
			close(myStmt, myRes);
			orcl.closeConnection();
		}
		return logType;
	}

	public String getLogisticTeamMailIds() throws SQLException {

		String mailAddresses = "";
		String type = "LG";

		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		try {
			myCon = con.getMysqlConn();
			String sql = " select emailid from  emailconf where usagetype = ? ";
			myStmt = myCon.prepareStatement(sql);
			myStmt.setString(1, type);
			myRes = myStmt.executeQuery();
			while (myRes.next()) {
				mailAddresses = myRes.getString(1);
			}
			return mailAddresses;

		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			con.closeConnection();

		}
	}

	private String getCurrentDateString() {
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		Date date = new Date(System.currentTimeMillis());
		// System.out.println(" date : "+formatter.format(date));
		return formatter.format(date);
	}

	private String getCurrentDateTimeString() {
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy, hh:mm a");
		Date date = new Date(System.currentTimeMillis());
		// System.out.println(" date time : "+formatter.format(date));
		return formatter.format(date);
	}

//		private java.util.Date currentDay() {
//		    final Calendar cal = Calendar.getInstance();
//		    cal.add(Calendar.DATE, 0);
//		    SimpleDateFormat formatter= new SimpleDateFormat("dd-MM-yyyy 'at' HH:mm:ss z");
//		    Date date = new Date(System.currentTimeMillis());
//		    System.out.println("new date "+formatter.format(date));
//		    return cal.getTime();
//		}	
	public int sendMailToDivisionTeam(Logistic theLData) {
		EmailLogistic sslmail = new EmailLogistic();
		String ccAddress = "";
		String toAddress = "";
		String today = getCurrentDateString();
		String todayTime = getCurrentDateTimeString();
		try {
			ccAddress = getLogisticTeamMailIds();
			toAddress = getEmailIdByEmpcode(theLData.getDivnUpdatedBy());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		System.out.println("Logistic to Division, TO Address : " + toAddress);
		System.out.println("Logistic to Division,  CC Address : " + ccAddress);

		String msg = "<table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"width: 100%;\">  "
				+ "<tr>" + "<td bgcolor=\"#ffffff\" style=\"font-size:14px;padding:1em;font-family: monospace;\">"
				+ "Dear <b> Team,</b><br/>"
				+ "<p>Import Shipment Collection Request updated by logistic team.  <br/><br/> "
				+ "<h4><u>Details</u></h4> " + "<b>PO Number :</b>  <b style=\"color:blue;\">"
				+ checkNullValidation(theLData.getPoNumber()) + "</b><br/>" + "<b>ETD :</b>  <b style=\"color:blue;\">"
				+ checkNullValidation(theLData.getExpTimeDeparture()) + "</b> <br/>"
				+ "<b>ETA :</b>  <b style=\"color:blue;\">" + checkNullValidation(theLData.getExpTimeArrival())
				+ "</b><br/>" + "<b>Reference No. :  </b>   <b style=\"color:blue;\">"
				+ checkNullValidation(theLData.getReference()) + "</b>  <br/>"
				+ "<b>Shipping Doc Status. :  </b>   <b style=\"color:blue;\">"
				+ checkNullValidation(theLData.getShipDocStatus()) + "</b>  <br/>"
				+ "<b>Status of Delivery :  </b>   <b style=\"color:blue;\">"
				+ checkNullValidation(theLData.getDeliveryStatus()) + "</b>  <br/>"
				+ "<b>Updated By :</b>  <b style=\"color:blue;\">" + checkNullValidation(theLData.getLogEmpName())
				+ "</b><br/> " + "<b>Remarks :</b>  <b style=\"color:blue;\">"
				+ checkNullValidation(theLData.getLogisticRemark()) + "</b><br/> "
				+ "<b>UPDATED ON :</b>  <b style=\"color:red;\">" + todayTime + "</b><br/>";

		sslmail.setToaddr(toAddress);
		sslmail.setCcaddr(ccAddress);
		sslmail.setMessageSub("Import Shipment Collection Updates By Logistics Team -" + theLData.getPoNumber()
				+ ", Ref. No: " + checkNullValidation(theLData.getReference()) + ", Dt:" + today);
		sslmail.setMessagebody(msg);
		int status = sslmail.sendMail();
		if (status != 1) {

			System.out
					.print("Error in sending Mail to logistic team : " + theLData.getPoDate() + " status : " + status);
		} else {
			System.out.print(
					"Successfully sent  Mail to logistic team : " + theLData.getPoDate() + " status : " + status);
		}
		return status;

	}

	public int sendmailToLogisticTeam(Logistic theLData, String ccAddress, int actionType, String reference) {
		String today = getCurrentDateString();
		String todayTime = getCurrentDateTimeString();
		String divnActionTxt = "Initiated";
		EmailLogistic sslmail = new EmailLogistic();
		String toAddress = "";
		try {
			toAddress = getLogisticTeamMailIds();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		if (actionType == 1) {
			divnActionTxt = "Updated";
		}
		System.out.println("Division to Logistic,  TO Address : " + toAddress);
		System.out.println("Division to Logistic, CC Address : " + ccAddress);

		String msg = "<table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"width: 100%;\">  "
				+ "<tr>" + "<td bgcolor=\"#ffffff\" style=\"font-size:14px;padding:1em;font-family: monospace;\">"
				+ "Dear <b>Logistics Team,</b>" + "<p> Import Shipment Collection Request " + divnActionTxt
				+ ". Please arrange to collect the shipment,<br/> " + "<h4><u>Details</u></h4> "
				+ "<b>PO Number :</b>  <b style=\"color:blue;\">" + checkNullValidation(theLData.getPoNumber())
				+ "</b><br/>" + "<b>Reference No. :</b>  <b style=\"color:blue;\">" + checkNullValidation(reference)
				+ "</b><br/>" + "<b>PO Date :</b>  " + checkNullValidation(theLData.getPoDate()) + " <br/>"
				+ "<b>Supplier :</b>  " + checkNullValidation(theLData.getSupplier()) + "<br/>" + "<b>" + divnActionTxt
				+ " By :</b>  <b style=\"color:blue;\">" + checkNullValidation(theLData.getDivnEmpName()) + "</b><br/> "
				+ "<b>Shipment Term :</b> <b style=\"color:blue;\"> " + checkNullValidation(theLData.getShipmentTerm())
				+ "</b><br/>" + "<b>C&F ETA Date :</b> <b style=\"color:blue;\"> "
				+ checkNullValidation(theLData.getCandFETADate()) + "</b><br/>"
				+ "<b>Shipment Mode :</b> <b style=\"color:blue;\"> " + checkNullValidation(theLData.getShipmentMode())
				+ "</b><br/>" + "<b>No. Of Containers :</b>   <b style=\"color:blue;\">" + theLData.getNoOfContainers()
				+ "</b><br />  " + "<b>Ex Factory Date :</b> <b style=\"color:blue;\"> " + theLData.getExFactoryDate()
				+ "</b><br/>" + "<b>Re-Export :</b> <b style=\"color:blue;\"> " + theLData.getReExport() + "</b><br/>"
				+ "<b>Contact Details :</b>  <b style=\"color:blue;\">" + theLData.getContactDetails() + "</b><br/>"
				+ "<b>Pick-Up Location :</b> <b style=\"color:blue;\"> " + theLData.getPickLocation() + "</b><br/>"
				+ "<b>Final Destination :</b> <b style=\"color:blue;\"> "
				+ checkNullValidation(theLData.getFinalDestination()) + "</b><br/>"
				+ "<b>Division Remarks :</b>  <b style=\"color:blue;\">"
				+ checkNullValidation(theLData.getDivnRemarks()) + "</b><br/>"
				+ "<b>UPDATED ON :</b>  <b style=\"color:red;\">" + todayTime + "</b><br/>";

		sslmail.setToaddr(toAddress);
		sslmail.setCcaddr(ccAddress);
		sslmail.setMessageSub("Import Shipment Collection Request " + divnActionTxt + " for  -" + theLData.getPoNumber()
				+ ",  Ref. No: " + checkNullValidation(reference) + ",  Dt:" + today);
		sslmail.setMessagebody(msg);
		int status = sslmail.sendMail();
		if (status != 1) {

			System.out
					.print("Error in sending Mail to logistic team : " + theLData.getPoDate() + " status : " + status);
		} else {
			System.out.print(
					"Successfully sent  Mail to logistic team : " + theLData.getPoDate() + " status : " + status);
		}
		return status;

	}

	private String checkNullValidation(String value) {
		String out = "-";
		if (value == null || value.isEmpty() || value.equalsIgnoreCase("undefined")) {
			return out;
		} else {

			return value;
		}

	}

	public String getEmailIdByEmpcode(String newempcode) {
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		Connection con = orcl.getOrclConn();
		if (con == null)
			return null;
		ResultSet rs = null;
		PreparedStatement psmt = null;
		String retval = null;
		String sqlstr = "SELECT TXNFIELD_FLD5 FROM FJPORTAL.PT_TXN_FLEX_FIELDS WHERE TXNFIELD_EMP_CODE = ? AND TXNFIELD_TXN_CODE='EMP' AND TXNFIELD_BLOCK_NUM=1";
		// String sqlstr = "SELECT TXNFIELD_FLD5 FROM ORION.PT_TXN_FLEX_FIELDS WHERE
		// TXNFIELD_EMP_CODE = ? AND TXNFIELD_TXN_CODE='EMP' AND TXNFIELD_BLOCK_NUM=1";
		try {
			psmt = con.prepareStatement(sqlstr);
			psmt.setString(1, newempcode);
			rs = psmt.executeQuery();
			if (rs.next()) {
				retval = rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
			// DB error
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (psmt != null)
					psmt.close();
				orcl.closeConnection();

			} catch (SQLException e) {
				System.out.println("Exception in closing DB resources");
				retval = null;
			}
		}
		return retval;
	}

	public Boolean checkForEntryInDB(Logistic poDetails, String lineNo) throws SQLException {
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		int lineCompare = Integer.parseInt(lineNo);
		Boolean recordExists = false;
		try {
			myCon = orcl.getOrclConn();
			String sql = " SELECT *  FROM LOG_DB_TXN  WHERE PH_SYS_ID = ? AND LINE_NO = ?  AND NVL(FULLGRN,'N')='N'";
			myStmt = myCon.prepareStatement(sql);
			int vals = Integer.parseInt(poDetails.getId());
			System.out.print(vals);
			System.out.print(poDetails.getLineNo());
			myStmt.setInt(1, vals);
			myStmt.setInt(2, lineCompare);

			myRes = myStmt.executeQuery();
			while (myRes.next()) {
				recordExists = true;
			}
			return recordExists;
		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			orcl.closeConnection();
		}
	}

	public int checkForEntryInDBANDGETMAX(Logistic poDetails) throws SQLException {
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		int retval = 0;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		Boolean recordExists = false;
		try {
			myCon = orcl.getOrclConn();
			String sql = " SELECT MAX(LINE_NO) LINE_NO FROM LOG_DB_TXN where PH_SYS_ID = ? AND NVL(FULLGRN,'N')='N'";
			myStmt = myCon.prepareStatement(sql);
			int vals = Integer.parseInt(poDetails.getId());

			System.out.print(poDetails.getLineNo());
			myStmt.setInt(1, vals);
			// myStmt.setInt(2, poDetails.getLineNo());

			myRes = myStmt.executeQuery();
			while (myRes.next()) {
				retval = myRes.getInt(1);
				retval = retval + 1;

			}
			return retval;
		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			orcl.closeConnection();
		}
	}

	public int getMaxLine(String sysId) throws SQLException {
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		int retval = 0;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();
		Boolean recordExists = false;
		try {
			myCon = orcl.getOrclConn();
			String sql = " SELECT MAX(LINE_NO) LINE_NO FROM LOG_DB_TXN where PH_SYS_ID = ? AND NVL(FULLGRN,'N')='N'";
			myStmt = myCon.prepareStatement(sql);
			int vals = Integer.parseInt(sysId);

			myStmt.setInt(1, vals);
			// myStmt.setInt(2, poDetails.getLineNo());

			myRes = myStmt.executeQuery();
			while (myRes.next()) {
				retval = myRes.getInt(1);
				retval = retval + 1;

			}
			return retval;
		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			orcl.closeConnection();
		}
	}

	public int insertPODetailsByDivision(Logistic poDetails, int setMaximumLineNumber) {
		String id = decrypt(poDetails.getId());
		System.out.println(setMaximumLineNumber);
		int logType = -2;
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes1 = null;

		OrclDBConnectionPool orcl = new OrclDBConnectionPool();

		try {
			myCon = orcl.getOrclConn();

			// Second Query: Insert Purchase Order Details
			String sql = "INSERT INTO FJPORTAL.LOG_DB_TXN (PH_SYS_ID, COMP, PONO, PO_DATE, SUPPLIER, PMT_TERMS, "
					+ "TERMS_SHIP, MODE_SHIP, CONTAINER, EX_FAC_DATE, CONT_DET, PICK_LOCN, DIVN_REMARKS, FINAL_DEST, "
					+ "DIVN_UPD_DT, DIVN_UPD_BY, RE_EXPORT, FULLGRN, REFERENCE, LINE_NO) "
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, ?, ?, 'N', ?, ?)";

			myStmt = myCon.prepareStatement(sql);
			myStmt.setString(1, poDetails.getId());
			myStmt.setString(2, poDetails.getCompany());
			myStmt.setString(3, poDetails.getPoNumber());
			myStmt.setDate(4, getSqlDate(poDetails.getPoDate()));
			myStmt.setString(5, poDetails.getSupplier());
			myStmt.setString(6, poDetails.getPaymentTerms());
			myStmt.setString(7, poDetails.getShipmentTerm());
			myStmt.setString(8, poDetails.getShipmentMode());
			myStmt.setInt(9, poDetails.getNoOfContainers());
			myStmt.setDate(10, getSqlDate(poDetails.getExFactoryDate()));
			myStmt.setString(11, poDetails.getContactDetails());
			myStmt.setString(12, poDetails.getPickLocation());
			myStmt.setString(13, poDetails.getDivnRemarks());
			myStmt.setString(14, poDetails.getFinalDestination());
			myStmt.setString(15, poDetails.getDivnUpdatedBy());
			myStmt.setString(16, poDetails.getReExport());
			myStmt.setString(17, poDetails.getId());
			myStmt.setInt(18, setMaximumLineNumber);

			logType = myStmt.executeUpdate();
			System.out.println("LOG VALUE : " + logType);
		} catch (SQLException ex) {
			logType = -2;
			System.out.println("Exception in closing DB resources at the time updating division user po details by "
					+ poDetails.getDivnUpdatedBy() + "  for id  " + id + " log = " + logType);
			ex.printStackTrace();
		} finally {
			// close jdbc objects
			close(myStmt, myRes1); // Close ResultSet and PreparedStatement for the first query
			orcl.closeConnection(); // Close the DB connection
			// System.out.println("Updated and closed db Successfully ");
		}
		return logType;
	}

	public int deletePO(int sysId, int lineNo) throws SQLException {
		Connection myCon = null;
		PreparedStatement myStmt = null;
		ResultSet myRes = null;
		int retval = 0;
		OrclDBConnectionPool orcl = new OrclDBConnectionPool();

		try {
			myCon = orcl.getOrclConn();
			String sql = " DELETE FROM LOG_DB_TXN WHERE PH_SYS_ID=? AND LINE_NO=?";
			myStmt = myCon.prepareStatement(sql);
			myStmt.setInt(1, sysId);
			myStmt.setInt(2, lineNo);
			retval = myStmt.executeUpdate();
			return retval;
		} finally {
			// close jdbc objects
			close(myStmt, myRes);
			orcl.closeConnection();
		}
	}
}
