/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package beans;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

//import org.bouncycastle.jsse.provider.BouncyCastleJsseProvider;

/**
 *
 * @author
 */
public class SSLMail {
	private String messageSub = null;
	private String toaddr = null;
	private String fromaddr = null;
	private String password = null;
	private String messagebody = "";
	private String host = null;
	private int port = 0;
	private int is_ssl = 0;
	private String userName = null;
	private String ccaddr = null;

//	public SSLMail() {
	// Add Bouncy Castle as a security provider
	// Security.addProvider(new BouncyCastleJsseProvider());
	// }

	@SuppressWarnings("finally")
	public int sendMail(String urlAddress) {
		/*
		 * readDefaultSenderMailProps(); Properties props = new Properties();
		 * props.put("mail.smtp.host", this.host); props.put("mail.smtp.auth", "true");
		 * props.setProperty("mail.smtp.ssl.enable", "true");
		 * props.put("mail.smtp.port", port);
		 * props.setProperty("mail.smtp.ssl.protocols", "TLSv1.2");
		 * props.put("mail.smtp.ssl.trust", "*");
		 */
		Properties props = new Properties();
		props.put("mail.smtp.host", this.host);
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.ssl.enable", "true");
		props.put("mail.smtp.port", String.valueOf(port));
		props.put("mail.smtp.ssl.protocols", "TLSv1.2");
		props.put("mail.smtp.ssl.trust", this.host); // Trust the server host

		// Debugging SSL/TLS
		System.setProperty("javax.net.debug", "ssl,handshake,data,trustmanager");

		int status = 0;
		Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(userName, password);
			}
		});

		try {

			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(this.fromaddr, "FJGroup No_Reply"));
			System.out.println(this.toaddr);
			// message.setRecipients(Message.RecipientType.TO,InternetAddress.parse("rafiuddin.m@fjtco.com"
			// + "," + "rajakumari.ch@fjtco.com" + ","+ "arun@fjtco.com" + "," +
			// "katrina.j@fjcare.com" + "," + "ashok.m@fjcare.com"));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse("rajakumari.ch@fjtco.com"));
			// message.setRecipients(Message.RecipientType.TO,
			// InternetAddress.parse(this.toaddr));
//			if (this.ccaddr != null) {
//				message.setRecipients(Message.RecipientType.CC, InternetAddress.parse(this.ccaddr));
//			}

			message.setSubject(this.messageSub);
			this.messagebody += getMessageFooter(urlAddress);
			message.setContent(this.messagebody, "text/html");
			Transport.send(message);
			status = 1;
			System.out.println("Done in SSLMail");

		} catch (MessagingException e) {
			System.out.print(e);
			// throw new RuntimeException(e);
			status = -1;
		} finally {
			System.out.println("finally in SSLMail");
			return status;
		}
	}

	/**
	 * @return the message
	 */
	public String getMessageSub() {
		return messageSub;
	}

	/**
	 * @param message the message to set
	 */
	public void setMessageSub(String message) {
		this.messageSub = message;
	}

	/**
	 * @return the toaddr
	 */
	public String getToaddr() {
		return toaddr;
	}

	/**
	 * @param toaddr the toaddr to set
	 */
	public void setToaddr(String toaddr) {
		this.toaddr = toaddr;
	}

	/**
	 * @return the fromaddr
	 */
	public String getFromaddr() {
		return fromaddr;
	}

	/**
	 * @param fromaddr the fromaddr to set
	 */
	public void setFromaddr(String fromaddr) {
		this.fromaddr = fromaddr;
	}

	/**
	 * @return the messagebody
	 */
	public String getMessagebody() {
		return messagebody;
	}

	/**
	 * @param messagebody the messagebody to set
	 */
	public void setMessagebody(String messagebody) {
		this.messagebody = messagebody;
	}

	/**
	 * @return the password
	 */
	public String getPassword() {
		return password;
	}

	/**
	 * @param password the password to set
	 */
	public void setPassword(String password) {
		this.password = password;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	private int readDefaultSenderMailProps() {
		MysqlDBConnectionPool con = new MysqlDBConnectionPool();
		Connection mcon = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		int retval = 0;
		String usql = "SELECT emailid, password, host, port, is_ssl, user_name FROM emailconf WHERE usagetype='ITDEPT'";

		try {
			mcon = con.getMysqlConn();
			if (mcon == null)
				return -2;

			psmt = mcon.prepareStatement(usql);
			rs = psmt.executeQuery();
			if (rs.next()) {
				this.fromaddr = rs.getString("emailid");
				this.password = rs.getString("password");
				this.host = rs.getString("host");
				this.port = rs.getInt("port");
				this.is_ssl = rs.getInt("is_ssl");
				this.userName = rs.getString("user_name");
			} else {
				System.out.println("No mail details found.");
				retval = -1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			retval = -2;
		} finally {
			try {

				if (rs != null)
					rs.close();
				if (psmt != null)
					psmt.close();

				con.closeConnection();

			} catch (SQLException e) {
				System.out.println("Exception in closing DB resources");
				e.printStackTrace();
				retval = -2;
			}
		}
		return retval;
	}

	/**
	 * @return the host
	 */
	public String getHost() {
		return host;
	}

	/**
	 * @param host the host to set
	 */
	public void setHost(String host) {
		this.host = host;
	}

	/**
	 * @return the port
	 */
	public int getPort() {
		return port;
	}

	/**
	 * @param port the port to set
	 */
	public void setPort(int port) {
		this.port = port;
	}

	/**
	 * @return the is_ssl
	 */
	public int getIs_ssl() {
		return is_ssl;
	}

	/**
	 * @param is_ssl the is_ssl to set
	 */
	public void setIs_ssl(int is_ssl) {
		this.is_ssl = is_ssl;
	}

	public String getCcaddr() {
		return ccaddr;
	}

	public void setCcaddr(String ccaddr) {
		this.ccaddr = ccaddr;
	}

	public String getMessageFooter(String urlAddress) {
		// System.out.println("URLA DDRES in MAIL "+urlAddress);
		String div = "<br/><br/><div style=\"width: auto;\n" + "padding: 5px 10px;\n" + "margin: 0 2px;\n"
				+ "font-family: Arial, Helvetica, sans-serif;\n" + "font-size: 15px;\n" + "\">";
		StringBuilder mbody = new StringBuilder("");
		mbody.append(div);
		mbody.append("FJPortal Link &nbsp;:&nbsp; <a href=" + urlAddress + ">FJGroup PORTAL</a>");
		mbody.append("<br/>...................................................................<br/>"
				+ "<p style=\"Margin:0;Margin-bottom:0;color:#848789;display:block;font-family:Tahoma,Geneva,sans-serif;font-size:13px;font-weight:normal;line-height:22px;margin:0;margin-bottom:6px;text-align:left;\">"
				+ "Disclaimer: This is an auto-generated email sent by our system. Please do not reply to this email.</p>"
				+ "Thank you, <br/>" + "<b>The FJ-Group Team. </b><br/>");
		mbody.append("</div>");
		return mbody.toString();
	}
}
