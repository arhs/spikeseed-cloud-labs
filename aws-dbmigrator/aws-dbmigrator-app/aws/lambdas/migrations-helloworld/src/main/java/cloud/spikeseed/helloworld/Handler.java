package cloud.spikeseed.helloworld;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.flywaydb.core.Flyway;

import java.util.Map;

public class Handler implements RequestHandler<Map<String, String>, String> {

	@Override
	public String handleRequest(Map<String, String> input, Context context) {
		var config = new Configuration();
		var flyway = Flyway.configure().dataSource(
				config.getJdbcUrl(),
				config.getDbSecret().getUsername(),
				config.getDbSecret().getPassword()
		).load();

		if (input != null && "clean".equals(input.get("action"))) {
			flyway.clean();
		} else {
			flyway.migrate();
		}
		return null;
	}
}
