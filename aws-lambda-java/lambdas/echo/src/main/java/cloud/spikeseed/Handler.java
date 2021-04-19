package cloud.spikeseed;

import com.amazonaws.services.lambda.runtime.Context;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class Handler {
    private static final Gson GSON = new GsonBuilder().setPrettyPrinting().create();

    public String handleRequest(Object event, Context context) {
        return GSON.toJson(event);
    }
}