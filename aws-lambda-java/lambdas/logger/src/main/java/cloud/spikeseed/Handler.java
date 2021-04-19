package cloud.spikeseed;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.Map;

public class Handler implements RequestHandler<Map<String, String>, String> {
    private static final Gson GSON = new GsonBuilder().setPrettyPrinting().create();

    @Override
    public String handleRequest(Map<String, String> event, Context context) {
        var logger = context.getLogger();
        logger.log("ENVIRONMENT VARIABLES: " + GSON.toJson(System.getenv()));
        logger.log("CONTEXT: " + GSON.toJson(context));

        var body = Map.of("status", 200, "message", "ok");
        return GSON.toJson(body);
    }

}