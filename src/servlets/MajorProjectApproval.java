package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import utils.MarketingLeadsDbUtil;

/**
 * Servlet implementation class MajorProjectApproval
 */
@WebServlet("/MajorProjectApproval")
public class MajorProjectApproval extends HttpServlet {
	private MarketingLeadsDbUtil marketingLeadsDbUtil;

	private static final long serialVersionUID = 1L;

	@Override
	public void init() throws ServletException {
		super.init();
		try {
			marketingLeadsDbUtil = new MarketingLeadsDbUtil(); // Assuming the constructor initializes everything needed
		} catch (Exception e) {
			throw new ServletException("Failed to initialize MarketingLeadsDbUtil", e);
		}
	}

	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, SQLException {
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();

		// Retrieve leadId from request
		String leadId = request.getParameter("leadId");
		System.out.print(leadId); // For debugging purposes

		// Check if leadId is provided
		if (leadId != null) {
			// Attempt to approve the marketing lead
			boolean isUpdated = marketingLeadsDbUtil.updateApproveMarketingLeads(leadId);
			// If the lead is successfully approved
			if (isUpdated) {
				out.println("<html><body>");
				out.println("<h3>New Project has been approved successfully!</h3>");
				out.println("</body></html>");
			} else {
				// If the approval failed, show an error message
				out.println("<html><body>");
				out.println("<h3>Error: Unable to approve marketing lead.</h3>");
				out.println("</body></html>");
			}
		}
	}

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public MajorProjectApproval() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			processRequest(request, response);
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
		doGet(request, response);
	}

}
