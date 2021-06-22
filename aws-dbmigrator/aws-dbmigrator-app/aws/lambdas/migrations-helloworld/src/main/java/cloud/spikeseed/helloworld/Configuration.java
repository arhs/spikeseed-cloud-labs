package cloud.spikeseed.helloworld;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueRequest;

import java.io.IOException;
import java.util.Map;

class DbSecret {
	private final String username;
	private final String password;

	public DbSecret(String username, String password) {
		this.username = username;
		this.password = password;
	}

	public String getUsername() {
		return username;
	}

	public String getPassword() {
		return password;
	}
}

public class Configuration {
	private static final ObjectMapper JSON_MAPPER = new ObjectMapper();

	private final String jdbcUrl;
	private final DbSecret dbSecret;

	public Configuration() {
		var smClient = SecretsManagerClient.create();

		this.jdbcUrl = System.getenv("DATABASE_JDBC_URL");
		var dbSecretName = System.getenv("DATABASE_SECRET_NAME");

		try {
			this.dbSecret = getDbSecret(smClient, dbSecretName);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	private DbSecret getDbSecret(SecretsManagerClient client, String secretName) throws JsonProcessingException {
		var secretResponse = client.getSecretValue(
				GetSecretValueRequest.builder().secretId(secretName).build()
		);
		@SuppressWarnings("unchecked")
		var secretJson = (Map<String, String>) JSON_MAPPER.readValue(secretResponse.secretString(), Map.class);

		return new DbSecret(secretJson.get("username"), secretJson.get("password"));
	}

	public String getJdbcUrl() {
		return jdbcUrl;
	}

	public DbSecret getDbSecret() {
		return dbSecret;
	}
}
