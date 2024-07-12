package servlets;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import beans.ConsultantLeads;
import beans.MktSalesLeads;
import beans.fjtcouser;
import utils.MarketingLeadsDbUtil;

/**
 * Servlet implementation class ConsultantProductReportController
 */
@WebServlet(name = "ConsultantProductReport", urlPatterns = { "/ConsultantProductReport" })
public class ConsultantProductReportController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private MarketingLeadsDbUtil marketingLeadsDbUtil;

	@Override
	public void init() throws ServletException {
		super.init();
		marketingLeadsDbUtil = new MarketingLeadsDbUtil();
		try {
		} catch (Exception ex) {
			throw new ServletException(ex);
		}
	}

	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, SQLException {
		fjtcouser fjtuser = (fjtcouser) request.getSession().getAttribute("fjtuser");

		if (fjtuser.getEmp_code() == null) {
			response.sendRedirect("logout.jsp");

		} else {
			String consultypeforQuery = "";
			String[] selconsultantType = request.getParameterValues("consultantType");
			StringBuilder contypebuilder = new StringBuilder();
			if (selconsultantType != null && selconsultantType.length > 0) {

				for (String selcontypelist : selconsultantType) {
					contypebuilder.append("'" + selcontypelist + "',");
				}
				consultypeforQuery = contypebuilder.deleteCharAt(contypebuilder.length() - 1).toString();
				System.out.println("consultypeforQuery==" + consultypeforQuery);
			} else {
				consultypeforQuery = "''";
			}
			List<MktSalesLeads> productList = marketingLeadsDbUtil.getProductList();
			List<ConsultantLeads> consultantList = marketingLeadsDbUtil.getAllConsultantList();
			request.setAttribute("PLFCL", productList);
			request.setAttribute("CLFCL", consultantList);
			// request.setAttribute("selectedConsultTypeCheckBoxes",
			// selectedConsltCheckboxes);

		}
		String theDataFromHr = request.getParameter("fjtco");

		if (theDataFromHr == null) {
			theDataFromHr = "list";

		}

		switch (theDataFromHr) {
		case "list":

			try {
				goToConsultantProductPage(request, response);
			} catch (Exception e) {
				e.printStackTrace();
			}
			break;
		case "consultlist":

			try {
				goToConsultantProductPage(request, response);
			} catch (Exception e) {
				e.printStackTrace();
			}
			break;
		case "rpeotrpad1":
			goToFilterConsultantType(request, response);
			break;
		case "rpeotrpad":

			try {
				goToConsultantProductReport(request, response);
				goToConsultantProductPage(request, response);
			} catch (Exception e) {
				e.printStackTrace();
			}
			break;
		default:

			try {
				// goToRegularisePage(request, response);
			} catch (Exception e) {
				e.printStackTrace();
			}

		}

	}

	private void goToConsultantProductPage(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("/marketing/consultantProductReport.jsp");
		dispatcher.forward(request, response);

	}

	/*
	 * private void goToFilterConsultantType(HttpServletRequest request,
	 * HttpServletResponse response) throws SQLException, ServletException,
	 * IOException { // Log all parameters for debugging
	 * System.out.println("Received parameters:");
	 * request.getParameterMap().forEach((key, value) -> System.out.println(key +
	 * " = " + Arrays.toString(value)));
	 * 
	 * // Correct parameter name check String[] consultantTypes =
	 * request.getParameterValues("consultantTypeList1");
	 * 
	 * // Log the received data to the server console if (consultantTypes != null) {
	 * System.out.println("Received Consultant Types: " +
	 * Arrays.toString(consultantTypes)); } else {
	 * System.out.println("No Consultant Types were received."); }
	 * List<ConsultantLeads> filteredConsultants = new ArrayList<>(); if
	 * (consultantTypes != null) { filteredConsultants =
	 * marketingLeadsDbUtil.getFilteredConsultantList(consultantTypes); }
	 * 
	 * // Convert the filtered list to JSON Gson gson = new Gson(); String json =
	 * gson.toJson(filteredConsultants); request.setAttribute("filteredConsultants",
	 * filteredConsultants); // Set the response type to JSON and send the response
	 * response.setContentType("application/json");
	 * response.setCharacterEncoding("UTF-8"); response.getWriter().write(json);
	 * 
	 * // Log the JSON response for debugging
	 * System.out.println("Filtered Consultants JSON: " + json); // Optionally, you
	 * can send a response back to the client response.setContentType("text/plain");
	 * response.getWriter().write("Consultant Types received: " +
	 * Arrays.toString(consultantTypes)); }
	 */

	private void goToFilterConsultantType(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		System.out.println("Received parameters:");
		request.getParameterMap().forEach((key, value) -> System.out.println(key + " = " + Arrays.toString(value)));

		String[] consultantTypes = request.getParameterValues("consultantTypeList1");

		if (consultantTypes != null) {
			System.out.println("Received Consultant Types: " + Arrays.toString(consultantTypes));
		} else {
			System.out.println("No Consultant Types were received.");
		}

		List<ConsultantLeads> filteredConsultants = new ArrayList<>();
		if (consultantTypes != null) {
			filteredConsultants = marketingLeadsDbUtil.getFilteredConsultantList(consultantTypes);
		}

		Gson gson = new Gson();
		String json = gson.toJson(filteredConsultants);

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(json);

		// Debugging log to ensure only JSON is sent
		System.out.println("Filtered Consultants JSON: " + json);
	}

	private void goToConsultantProductReport(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, SQLException {
		final String[] consultantList1 = request.getParameterValues("consltList");
		String[] consultantList = request.getParameterValues("filteredConsultantList");
		String[] productList = request.getParameterValues("productList");

		if (consultantList1 != null && consultantList1.length > 0) {
			List<String> combinedConsultantList = new ArrayList<>(
					Arrays.asList(consultantList != null ? consultantList : new String[0]));
			combinedConsultantList.addAll(Arrays.asList(consultantList1));
			consultantList = combinedConsultantList.toArray(new String[0]);
		}

		List<String> selectedConsltCheckboxes = null;
		List<String> selectedProductCheckboxes = null;
		int totalSelectedConsulCnt = (consultantList.length) / 10;

		if (consultantList.length % 10 > 0)
			totalSelectedConsulCnt++;

		System.out.println("totalSelectedConsul" + totalSelectedConsulCnt);
		if (consultantList != null && consultantList.length > 0) {
			selectedConsltCheckboxes = Arrays.asList(consultantList);
		}
		if (productList != null && productList.length > 0) {
			selectedProductCheckboxes = Arrays.asList(productList);
		}

		request.setAttribute("selectedConsultCheckBoxes", selectedConsltCheckboxes);
		request.setAttribute("selectedProdcutCheckBoxes", selectedProductCheckboxes);
		int count = 1;

		String[] consultantArray = new String[totalSelectedConsulCnt];
		StringBuilder consultantListforQuery = new StringBuilder();
		int i = 0;
		StringBuilder probuilder = new StringBuilder();
		if (consultantList.length > 0) {
			String prodctList = String.join(",", productList);

			for (String prlist : productList) {
				probuilder.append("'" + prlist + "',");
			}
			String productListforQuery = probuilder.deleteCharAt(probuilder.length() - 1).toString();
			System.out.println("productListforQuery==" + productListforQuery);
			StringBuilder builder = new StringBuilder();
			for (String list : consultantList) {
				builder.append("'" + list + "',");
				System.out.println("builder== " + builder);
				count++;
				System.out.println("cout== " + count);
				if (count > 10) {
					consultantArray[i++] = builder.deleteCharAt(builder.length() - 1).toString();
					count = 1;
					builder = new StringBuilder();
					System.out.println("consultantArray[0]== " + consultantArray[i - 1]);
				}
			}

			if (count > 1)
				consultantArray[i++] = builder.deleteCharAt(builder.length() - 1).toString();

			for (int j = 0; j < consultantArray.length; j++) {
				if (j > 0)
					consultantListforQuery.append(" or ");
				consultantListforQuery.append(" consultant IN (");
				consultantListforQuery.append(consultantArray[j]);
				consultantListforQuery.append(" )");
			}

			// String consultantListforQuery = builder.deleteCharAt(builder.length() -
			// 1).toString();
			String[][] theConsltProductList = marketingLeadsDbUtil.getConsultantProductReport(
					consultantListforQuery.toString(), productListforQuery, consultantList, productList);
			request.setAttribute("CON_PRO_MATRIX_LIST", theConsltProductList);

		} else {
			request.setAttribute("UPDATE_MSG", "<div class=\"alert alert-info\">\r\n"
					+ "  <strong>Info!</strong> Please Complete Selection\r\n" + "</div> ");
		}

		// RequestDispatcher dispatcher =
		// request.getRequestDispatcher("/marketing/consultantProductReport.jsp");
		RequestDispatcher dispatcher = request.getRequestDispatcher("/marketing/consultantProductReport.jsp");
		dispatcher.forward(request, response);
	}

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ConsultantProductReportController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			fjtcouser fjtuser = (fjtcouser) request.getSession().getAttribute("fjtuser");
			if (fjtuser == null) {
				response.sendRedirect("logout.jsp");
			} else if ("rpeotrpad1".equals(request.getParameter("fjtco"))) {
				// Directly handle the consultant type submission
				goToFilterConsultantType(request, response);
			} else {
				processRequest(request, response);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}