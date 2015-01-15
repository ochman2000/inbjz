package pl.lodz.p.h2;

import pl.lodz.p.config.Application;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.*;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.logging.Logger;

/**
 * Created by Łukasz Ochmański on 1/15/2015.
 */
public class HR {
    public static String script;
    static {
        URL url = Application.class.getClassLoader().getResource("sql/HR.sql");
        List<String> lines = null;
        try {
//          Path path = Paths.get("build/resources/main/sql/HR.sql");
            Path path = resourceToPath(url);
            lines = Files.readAllLines(path);
        } catch (IOException | URISyntaxException e) {
            Logger.getGlobal().severe(e.getMessage());
        }
        StringBuilder sb = new StringBuilder();
        for (String s : lines) {
            sb.append(s);
        }
        script = sb.toString();
        System.out.println(script);
    }

    static Path resourceToPath(URL resource)
            throws IOException,
            URISyntaxException {

        Objects.requireNonNull(resource, "Resource URL cannot be null");
        URI uri = resource.toURI();

        String scheme = uri.getScheme();
        if (scheme.equals("file")) {
            return Paths.get(uri);
        }

        if (!scheme.equals("jar")) {
            throw new IllegalArgumentException("Cannot convert to Path: " + uri);
        }

        String s = uri.toString();
        int separator = s.indexOf("!/");
        String entryName = s.substring(separator + 2);
        URI fileURI = URI.create(s.substring(0, separator));

        FileSystem fs = FileSystems.newFileSystem(fileURI,
                Collections.<String, Object>emptyMap());
        return fs.getPath(entryName);
    }
}
