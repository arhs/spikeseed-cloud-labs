package cloud.spikeseed.helloworld;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Handler implements RequestHandler<Object, Object> {

	private static final Logger LOGGER = LoggerFactory.getLogger(Handler.class);

	@Override
	public Object handleRequest(Object input, final Context context) {
		LOGGER.info("Loading the configuration");
		var configuration = new Configuration();
		LOGGER.info("Loading SQL Commands");
		var sqlCommands = SqlScriptLoader.loadSqlScript(configuration);
		var executor = new SqlExecutor();
		LOGGER.info("Executing SQL Commands");
		executor.execute(configuration, sqlCommands);
		return null;
	}

}