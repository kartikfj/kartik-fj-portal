package servlets;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/downloadInsDocs")
public class DownloadInsDocServlet extends HttpServlet {

	private static final long serialVersionUID = 2067115822080269398L;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String fileName = request.getParameter("fileName");

		File file = new File("D://MEDICALINSURANCE/" + fileName);

		InputStream input = new FileInputStream(file);
		if (fileName.endsWith("xlsx")) {
			response.setHeader("Content-Type", "application/octet-stream");
		} else if (fileName.endsWith("pdf")) {
			response.setHeader("Content-Type", "application/pdf");
		} else {
			throw new RuntimeException("File type not found in downloadServlet");
		}

		response.setHeader("Content-Disposition", "attachment; filename=" + file.getName());
		System.out.println("file name " + file.getName());
		OutputStream osh = response.getOutputStream();
		DataInputStream disObj = null;
		try {
			disObj = new DataInputStream(input);
			int nlength = 0;
			byte[] bbuf = new byte[1024];
			while ((disObj != null) && ((nlength = disObj.read(bbuf)) != -1)) {
				osh.write(bbuf, 0, nlength);
			}
			osh.flush();
		} catch (org.apache.catalina.connector.ClientAbortException e) {
			System.out.println("Exception in DownloadServlet " + e);
		} catch (Exception e) {
			System.out.println("Exception in DownloadServlet: " + e);
		} finally {
			if (input != null) {
				input.close();
			}

			if (osh != null) {
				osh.close();
			}
		}
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

}