package beans;

import java.security.Security;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;

import org.bouncycastle.jsse.provider.BouncyCastleJsseProvider;

public class SSLConfiguration {
	public static void configureSSL() {
		Security.addProvider(new BouncyCastleJsseProvider());
		try {
			// Initialize TrustManagerFactory with default TrustManager
			TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
			tmf.init((java.security.KeyStore) null); // Use default (empty) KeyStore
			TrustManager[] trustManagers = tmf.getTrustManagers();

			// Initialize SSLContext with TLSv1.2 protocol
			SSLContext sslContext = SSLContext.getInstance("TLSv1.2");
			sslContext.init(null, trustManagers, null);
			SSLContext.setDefault(sslContext);

			System.out.println("SSL/TLS configuration set successfully.");
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("Failed to configure SSL/TLS.");
		}
	}

}
