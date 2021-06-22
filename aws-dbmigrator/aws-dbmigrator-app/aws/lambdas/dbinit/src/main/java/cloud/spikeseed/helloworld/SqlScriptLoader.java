package cloud.spikeseed.helloworld;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import software.amazon.awssdk.utils.StringUtils;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class SqlScriptLoader {

    private static final Logger LOGGER = LoggerFactory.getLogger(SqlScriptLoader.class);

    private static final int DEFAULT_BUFFER_SIZE = 8192;

    public static List<String> loadSqlScript(Configuration configuration) {
        var script = getInitSqlScript(configuration);

        LOGGER.info("Splitting SQL Script into commands");
        var sb = new StringBuilder();
        var commands = new ArrayList<String>();
        for (var line : script.lines().collect(Collectors.toList())) {
            if (!line.startsWith("--")) {
                line = line.trim();
                if (line.endsWith(";")) {
                    sb.append(line);
                    commands.add(sb.toString());
                    sb.setLength(0);
                } else if (!line.isEmpty()) {
                    sb.append(line);
                    sb.append(" ");
                }
            }
        }

        return commands;
    }

    private static String getInitSqlScript(Configuration configuration) {
        LOGGER.info("Reading sql/Init.sql");
        var classloader = Thread.currentThread().getContextClassLoader();
        try (var input = classloader.getResourceAsStream("sql/Init.sql")) {
            Objects.requireNonNull(input);
            var content = convertInputStreamToString(input);

            LOGGER.info("Replacing variables in sql/Init.sql");
            return StringUtils.replaceEach(content,
                    new String[]{
                            "$db_name_helloworld", "$db_user_name_helloworld", "$db_user_password_helloworld"
                    },
                    new String[]{
                            configuration.getDbHelloWorldName(), configuration.getDbHelloWorldSecret().getUsername(), configuration.getDbHelloWorldSecret().getPassword(),
                    }
            );
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static String convertInputStreamToString(InputStream is) throws IOException {
        var result = new ByteArrayOutputStream();
        var buffer = new byte[DEFAULT_BUFFER_SIZE];
        int length;
        while ((length = is.read(buffer)) != -1) {
            result.write(buffer, 0, length);
        }

        return result.toString(StandardCharsets.UTF_8);
    }
}
