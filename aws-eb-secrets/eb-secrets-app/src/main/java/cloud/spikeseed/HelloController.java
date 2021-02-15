package cloud.spikeseed;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/v1")
public class HelloController {

    @Value("${DATABASE_PASSWORD_1}")
    private String databasePassword1;

    @Value("${DATABASE_PASSWORD_2}")
    private String databasePassword2;

    private static final Logger LOGGER = LoggerFactory.getLogger(HelloController.class);

    @RequestMapping(path = "/hello", method = RequestMethod.GET)
    public Response health() {
        LOGGER.info("GET /v1/hello");
        return new Response(200, "OK - " + databasePassword1 + " - " + databasePassword2);
    }

}

class Response {
    private int status;
    private String message;

    public Response() {
    }

    public Response(int status, String message) {
        this.status = status;
        this.message = message;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
