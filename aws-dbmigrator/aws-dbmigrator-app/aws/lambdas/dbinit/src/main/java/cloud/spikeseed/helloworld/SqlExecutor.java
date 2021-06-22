package cloud.spikeseed.helloworld;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

public class SqlExecutor {

	private static final Logger LOGGER = LoggerFactory.getLogger(SqlExecutor.class);

	public void execute(Configuration configuration, List<String> commands) {
		try {
			LOGGER.info("Loading MySQL JDBC Driver");
			Class.forName("com.mysql.cj.jdbc.Driver");

			LOGGER.info("Connecting to the Database");
			var url = configuration.getJdbcUrl();
			var user = configuration.getDbClusterSecret().getUsername();
			var password = configuration.getDbClusterSecret().getPassword();

			try (Connection connection = DriverManager.getConnection(url, user, password)) {
				connection.setAutoCommit(false);

				try (Statement statement = connection.createStatement()) {
					LOGGER.info("Executing commands");
					for (var command : commands) {
						statement.execute(command);
					}
					connection.commit();
				} catch (SQLException e) {
					connection.rollback();
					throw e;
				}
			}
		} catch (ClassNotFoundException | SQLException e) {
			throw new RuntimeException(e);
		}
	}

}
