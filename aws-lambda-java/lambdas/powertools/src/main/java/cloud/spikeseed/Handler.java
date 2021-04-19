package cloud.spikeseed;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import software.amazon.awssdk.services.ssm.SsmClient;
import software.amazon.awssdk.services.ssm.model.GetParameterRequest;
import software.amazon.lambda.powertools.logging.Logging;
import software.amazon.lambda.powertools.tracing.Tracing;

import java.io.IOException;
import java.util.Map;

public class Handler implements RequestHandler<APIGatewayV2HTTPEvent, APIGatewayV2HTTPResponse> {
    private static final ObjectMapper JSON_MAPPER = new ObjectMapper();

    private static final SsmClient SSM_CLIENT = SsmClient.create();

    private String getSsmParameter(String name) {
        var response = SSM_CLIENT.getParameter(
                GetParameterRequest.builder()
                        .name(name)
                        .withDecryption(true)
                        .build()
        );
        return response.parameter().value();
    }

    @Tracing
    @Logging(logEvent = true)
    @Override
    public APIGatewayV2HTTPResponse handleRequest(APIGatewayV2HTTPEvent event, Context context) {
        try {
            var body = Map.of(
                    "status", 200,
                    "message", "ok",
                    "secured", getSsmParameter("/lambdajava/database/rds/password")
            );
            return APIGatewayV2HTTPResponse.builder()
                    .withStatusCode(200)
                    .withHeaders(Map.of("Content-Type", "application/json"))
                    .withBody(JSON_MAPPER.writeValueAsString(body))
                    .build();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}