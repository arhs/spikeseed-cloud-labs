package cloud.spikeseed.helloworld;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import software.amazon.awssdk.services.rdsdata.RdsDataClient;
import software.amazon.awssdk.services.rdsdata.model.ExecuteStatementRequest;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Handler implements RequestHandler<APIGatewayV2HTTPEvent, APIGatewayV2HTTPResponse> {
	private static final Logger LOG = LoggerFactory.getLogger(Handler.class);
	private final static ObjectMapper JSON_MAPPER = new ObjectMapper();

	private static final RdsDataClient rdsData = RdsDataClient.builder().build();

	private static final String DB_CLUSTER_ARN = System.getenv("DATABASE_CLUSTER_ARN");
	private static final String DB_SECRET_ARN = System.getenv("DATABASE_SECRET_ARN");
	private static final String DB_NAME = System.getenv("DATABASE_NAME");

	private List<Country> getCountries() {
		var statement = ExecuteStatementRequest.builder()
				.resourceArn(DB_CLUSTER_ARN)
				.secretArn(DB_SECRET_ARN)
				.database(DB_NAME)
				.sql("select alpha2, alpha3, name from country")
				.build();

		var result = rdsData.executeStatement(statement);

		return result.records().stream().map(fields -> {
			var alpha2 = fields.get(0).stringValue();
			var alpha3 = fields.get(1).stringValue();
			var name = fields.get(2).stringValue();
			return new Country(alpha2, alpha3, name);
		}).collect(Collectors.toList());
	}

	@Override
	public APIGatewayV2HTTPResponse handleRequest(APIGatewayV2HTTPEvent event, Context context) {
		try {
			JSON_MAPPER.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
			LOG.info("ENVIRONMENT VARIABLES: {}", JSON_MAPPER.writeValueAsString(System.getenv()));
			LOG.info("CONTEXT: {}", JSON_MAPPER.writeValueAsString(context));

			var countries = getCountries();

			return APIGatewayV2HTTPResponse.builder()
					.withStatusCode(200)
					.withHeaders(Map.of("Content-Type", "application/json"))
					.withBody(JSON_MAPPER.writeValueAsString(countries))
					.build();
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

}