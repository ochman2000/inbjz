package pl.lodz.p.h2;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.*;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

/**
 * Created by Łukasz Ochmański on 1/15/2015.
 */
public class DatabaseUtils {

    private static String HR_SCHEMA;
    private static String HR_DATA;
    private static String TWORZ_PRACOWNICY;
    private static String WSTAW_DANE_PRACOWNICY;
    private static final Logger logger = LoggerFactory.getLogger(DatabaseUtils.class);

    public static void refreshAll() {
        HR_SCHEMA = getScript("sql/hr_schemat.sql");
        HR_DATA = getScript("sql/hr_dane.sql");
        TWORZ_PRACOWNICY = getScript("sql/tworz_pracownicy.sql");
        WSTAW_DANE_PRACOWNICY = getScript("sql/wstaw_dane_prac.sql");
    }

    public static String getHrSchema() {
        if (HR_SCHEMA==null) {
            HR_SCHEMA = getScript("sql/hr_schemat.sql");
        }
        return HR_SCHEMA;
    }

    public static String getHrData() {
        if (HR_DATA==null) {
            HR_DATA = getScript("sql/hr_dane.sql");
        }
        return HR_DATA;
    }

    public static String getTworzPracownicy() {
        if (TWORZ_PRACOWNICY==null) {
            TWORZ_PRACOWNICY = getScript("sql/tworz_pracownicy.sql");
        }
        return TWORZ_PRACOWNICY;
    }

    public static String getWstawDanePracownicy() {
        if (WSTAW_DANE_PRACOWNICY==null) {
            WSTAW_DANE_PRACOWNICY = getScript("sql/wstaw_dane_prac.sql");
        }
        return WSTAW_DANE_PRACOWNICY;
    }

    public static String getScript(String resource) {
        URL url = DatabaseUtils.class.getClassLoader().getResource(resource);
        List<String> lines = null;
        try {
            Path path = resourceToPath(url);
            lines = Files.readAllLines(path);
        } catch (IOException | URISyntaxException e) {
            logger.error(e.getMessage());
            return null;
        } catch (Throwable t) {
            logger.error(t.getCause().getMessage());
            return null;
        }
        StringBuilder sb = new StringBuilder();
        for (String s : lines) {
            sb.append(s);
        }
        return sb.toString();
    }

    private static Path resourceToPath(URL resource)
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
        FileSystem fs;
        try {
             fs = FileSystems.getFileSystem(fileURI);
        } catch (FileSystemNotFoundException e) {
            fs = FileSystems.newFileSystem(fileURI,
                    Collections.<String, Object>emptyMap());
//        } catch (FileSystemAlreadyExistsException e ) {
//
        }
        return fs.getPath(entryName);
    }
}
