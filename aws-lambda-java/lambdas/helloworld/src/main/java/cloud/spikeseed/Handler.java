package cloud.spikeseed;

import com.amazonaws.services.lambda.runtime.Context;

public class Handler {
    public Object handleRequest(Object event, Context context) {
        return "Hello World - " + event.getClass();
    }
}