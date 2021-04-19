package cloud.spikeseed;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import software.amazon.awssdk.services.ssm.SsmClient;
import software.amazon.awssdk.services.ssm.model.GetParameterRequest;

import java.io.IOException;
import java.util.Map;

public class Handler implements RequestHandler<Map<String, String>, String> {
    private static final Logger LOG = LoggerFactory.getLogger(Handler.class);
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

    @Override
    public String handleRequest(Map<String, String> event, Context context) {
        try {
            JSON_MAPPER.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
            LOG.info("ENVIRONMENT VARIABLES: {}", JSON_MAPPER.writeValueAsString(System.getenv()));
            LOG.info("CONTEXT: {}", JSON_MAPPER.writeValueAsString(context));

            var body = Map.of(
                    "status", 200,
                    "message", "ok",
                    "secured", getSsmParameter("/lambdajava/database/rds/password")
            );
            return JSON_MAPPER.writeValueAsString(body);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

}