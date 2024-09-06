package servlets;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonIOException;

import beans.SalesmanPerformance;
import beans.SipJihvDetails;
import beans.SipJihvSummary;
import beans.SipOutRecvbleReprt;
import beans.Stage3Details;
import beans.Stage4Details;
import beans.Stage5Details;
import beans.fjtcouser;
import utils.SipChartDbUtil;

/**
 * Servlet implementation class salesManagerPerf
 */
@WebServlet("/salesManagerPerf")
public class salesManagerPerfController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private SipChartDbUtil sipChartDbUtil;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public salesManagerPerfController() {
		super();
		sipChartDbUtil = new SipChartDbUtil();

		// TODO Auto-generated constructor stub
	}

	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, SQLException {
		fjtcouser fjtuser = (fjtcouser) request.getSession().getAttribute("fjtuser");
		String action = request.getParameter("fjtco");// sipChart.jsp and sipDmChart.jsp , both page form
		// submitting "fjtco" as keyword to handle the services
		if (fjtuser.getEmp_code() == null || fjtuser.getSales_code() == null) {
			response.sendRedirect("logout.jsp");
		} else {

			String sales_eng_Emp_code = fjtuser.getEmp_code();
			if (fjtuser.getRole().equalsIgnoreCase("mg")) {
				// managment
				List<SipJihvSummary> theSalesEngList = sipChartDbUtil.getSalesMgrsListfor_Mg(sales_eng_Emp_code);
				request.setAttribute("SEngLst", theSalesEngList);
			} else {

				if (fjtuser.getSalesDMYn() >= 1) { // SALES Division Manager OR NOT
					// DM USER + SALES CODE
					List<SipJihvSummary> theSalesEngList = sipChartDbUtil.getSalesMgrsListfor_Dm(sales_eng_Emp_code);
					request.setAttribute("SEngLst", theSalesEngList);
				} else {
					// NORMAL SALES ENGINEER
					List<SipJihvSummary> theSalesEngList = sipChartDbUtil
							.getSalesEngListfor_SalesMgrs(sales_eng_Emp_code);
					request.setAttribute("SEngLst", theSalesEngList);
				}

			}

			if (action == null) {

				action = "salesChart_dafult";
			}

			switch (action) {

			case "list":
				try {
					goToSip(request, response);
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;

			case "salesChart_dafult":

				try {
					String theSalesEngCode = fjtuser.getSales_code();
					getOustndngRcvbleReportforSEng(request, response, theSalesEngCode);
					goToSip(request, response);
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;

			case "sm_perf":// Salesman Performance details
				try {
					getSmPerformanceData(request, response);
				} catch (Exception e) {
					e.printStackTrace();// TODO: handle exception
				}
				break;
			case "se_perf":// Salesman Performance details
				try {

					getSEPerformanceData(request, response);
				} catch (Exception e) {
					e.printStackTrace();// TODO: handle exception
				}
				break;
			case "allse_perf":
				try {
					getStage5_Details(request, response);
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			case "allse_perfBooking":
				try {
					getStage3_Details(request, response);
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			case "s2_dt":
				try {// handling jihv aging wise details
					getStage2Details(request, response);
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			case "s3_dt":
				try {// handling stage 3 details
					getStage3_Details(request, response);
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			case "s4_dt":
				try {// handling stage 4 details
					getStage4_Details(request, response);
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			case "s5_dt":
				try {// handling stage 4 details
					getStage5_Details(request, response);
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			default:// defaultly redirecting to jsp page
				try {
					goToSip(request, response);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

	}

	private void getOustndngRcvbleReportforSEng(HttpServletRequest request, HttpServletResponse response,
			String theSalesEngCode) throws SQLException {
		// this function for retreving sales oustanding recievable based on sales eng
		// code, aging wise
		List<SipOutRecvbleReprt> theReceivableList = sipChartDbUtil.getOutstandingRecievableforSaleEgr(theSalesEngCode);
		request.setAttribute("ORAR", theReceivableList);
	}

	private void getSmPerformanceData(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, IOException, JsonIOException {
		// Salesman Performance details
		String smCode = request.getParameter("c1");
		// List<SipJihvSummary> theSalesEngList =
		// sipChartDbUtil.getSalesMgrsListfor_Dm(smCode);
		// request.setAttribute("SEngLst", theSalesEngList);
		Map<String, SalesmanPerformance> smMap = sipChartDbUtil.getSalesManagerPerformance(smCode);
		response.setContentType("application/json");
		new Gson().toJson(smMap, response.getWriter());
//		if (smMap.isEmpty()) {
//			System.out.println("in null condi");
//			new Gson().toJson(theSalesEngList, response.getWriter());
//		}
		// request.setAttribute("SM_MAP", smMap);

	}

	private void getStage5_Details(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, IOException {
		try {
			fjtcouser fjtuser = (fjtcouser) request.getSession().getAttribute("fjtuser");
			String smCode = request.getParameter("c1");
			String dataType = request.getParameter("c2");
			String smEmpCode = null;
			if (dataType != null && dataType.equals("SC")) {
				smEmpCode = sipChartDbUtil.getEmployeeCodeBySalesCode(smCode);
			} else {
				smEmpCode = smCode;
			}

			List<Stage5Details> theStage5DtList = null;
			String result = sipChartDbUtil.checkSalesMgrPerfTabisAllowed(smEmpCode);
			if (fjtuser.getSalesDMYn() < 1 && !result.equals("Yes")) {
				theStage5DtList = sipChartDbUtil.stage5SummaryBillingDetailsForSE(smCode);
			} else {
				theStage5DtList = sipChartDbUtil.stage5SummaryBillingDetailsForPerf(smEmpCode);
			}

			response.setContentType("application/json");
			(new Gson()).toJson(theStage5DtList, response.getWriter());
		} catch (Exception var9) {
			response.setStatus(500);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			(new Gson()).toJson(Collections.singletonMap("error", "An error occurred"), response.getWriter());
			var9.printStackTrace();
		}

	}

	private void getStage3_Details(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, IOException {
		try {

			fjtcouser fjtuser = (fjtcouser) request.getSession().getAttribute("fjtuser");
			String smCode = request.getParameter("c1");
			String dataType = request.getParameter("c2");
			String smEmpCode = null;
			if (dataType != null && dataType.equals("SC")) {
				smEmpCode = sipChartDbUtil.getEmployeeCodeBySalesCode(smCode);
			} else {
				smEmpCode = smCode;
			}

			List<Stage3Details> theStage3DtList = null;
			String result = sipChartDbUtil.checkSalesMgrPerfTabisAllowed(smEmpCode);
			// Fetch data from the database

			if (fjtuser.getSalesDMYn() >= 1 || result.equals("Yes")) {
				theStage3DtList = sipChartDbUtil.stage3BookingDetailsForPerf(smEmpCode);
			} else {
				theStage3DtList = sipChartDbUtil.stage3SummaryDetails(smCode);
			}
			// Set response content type and write JSON
			response.setContentType("application/json");
			new Gson().toJson(theStage3DtList, response.getWriter());
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			new Gson().toJson(Collections.singletonMap("error", "An error occurred"), response.getWriter());
			e.printStackTrace();

		}

	}

	private void getStage2Details(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, JsonIOException, IOException {
		// Stage 2 details for sales engineer
		fjtcouser fjtuser = (fjtcouser) request.getSession().getAttribute("fjtuser");
		String smCode = request.getParameter("c1");
		String dataType = request.getParameter("c2");
		String smEmpCode = null;
		if (dataType != null && dataType.equals("SC")) {
			smEmpCode = sipChartDbUtil.getEmployeeCodeBySalesCode(smCode);
		} else {
			smEmpCode = smCode;
		}

		List<SipJihvDetails> theStage2DtList = null;
		String result = sipChartDbUtil.checkSalesMgrPerfTabisAllowed(smEmpCode);
		// Fetch data from the database

		if (fjtuser.getSalesDMYn() >= 1 || result.equals("Yes")) {
			theStage2DtList = sipChartDbUtil.getStage2DetailsForSalesManager(smEmpCode);
		} else {
			theStage2DtList = sipChartDbUtil.getStage2DetailsForSalesEngineer(smCode);
		}
		response.setContentType("application/json");
		new Gson().toJson(theStage2DtList, response.getWriter());
	}

	private void getStage4_Details(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, IOException {
		try {
			fjtcouser fjtuser = (fjtcouser) request.getSession().getAttribute("fjtuser");
			String smCode = request.getParameter("c1");
			String dataType = request.getParameter("c2");
			String smEmpCode = null;
			if (dataType != null && dataType.equals("SC")) {
				smEmpCode = sipChartDbUtil.getEmployeeCodeBySalesCode(smCode);
			} else {
				smEmpCode = smCode;
			}

			List<Stage4Details> theStage4DtList = null;
			String result = sipChartDbUtil.checkSalesMgrPerfTabisAllowed(smEmpCode);
			if (fjtuser.getSalesDMYn() < 1 && !result.equals("Yes")) {
				theStage4DtList = sipChartDbUtil.stage4SummaryDetails(smCode);
			} else {
				theStage4DtList = sipChartDbUtil.stage4SummaryBillingDetailsForPerf(smEmpCode);
			}

			response.setContentType("application/json");
			(new Gson()).toJson(theStage4DtList, response.getWriter());
		} catch (Exception var9) {
			response.setStatus(500);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			(new Gson()).toJson(Collections.singletonMap("error", "An error occurred"), response.getWriter());
			var9.printStackTrace();
		}

	}

	private void getSEPerformanceData(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, IOException, JsonIOException {
		// Salesman Performance details
		String smCode = request.getParameter("c1");
		String segEmplCode = sipChartDbUtil.getEmployeeCodeBySalesCode(smCode);
		Map<String, SalesmanPerformance> smMap = sipChartDbUtil.getSalesEngineerPerformance(smCode, segEmplCode);
		response.setContentType("application/json");
		new Gson().toJson(smMap, response.getWriter());
		// request.setAttribute("SM_MAP", smMap);

	}

	private void goToSip(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		fjtcouser fjtuser = (fjtcouser) request.getSession().getAttribute("fjtuser");
		RequestDispatcher dispatcher;
		if (fjtuser.getSalesDMYn() >= 1 || fjtuser.getRole().equalsIgnoreCase("mg")) {
			dispatcher = request.getRequestDispatcher("/salesMagrPerf.jsp");
		} else {
			dispatcher = request.getRequestDispatcher("/salesMagrPerf.jsp");
		}
		dispatcher.forward(request, response);

	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			fjtcouser fjtuser = (fjtcouser) request.getSession().getAttribute("fjtuser");
			if (fjtuser == null) {
				response.sendRedirect("logout.jsp");
			} else {
				processRequest(request, response);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			fjtcouser fjtuser = (fjtcouser) request.getSession().getAttribute("fjtuser");
			if (fjtuser == null) {
				response.sendRedirect("logout.jsp");
			} else {
				processRequest(request, response);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
