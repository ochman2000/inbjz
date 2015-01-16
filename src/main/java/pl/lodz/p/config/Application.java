package pl.lodz.p.config;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.SpringApplication;
import org.springframework.context.annotation.ComponentScan;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.logging.ConsoleHandler;
import java.util.logging.Formatter;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;

@ComponentScan
@EnableAutoConfiguration
public class Application {

    public static void main(String[] args) {
        getCustomLogger();
        SpringApplication.run(Application.class, args);
    }

    public static Logger getCustomLogger() {
            Logger.getGlobal().setUseParentHandlers(false);
            Handler conHdlr = new ConsoleHandler();
            conHdlr.setFormatter(new Formatter() {
                public String format(LogRecord record) {
                    StringBuilder sb = new StringBuilder();
                    sb.append("[");
                    sb.append(record.getLevel());
                    sb.append("] ");
                    final Calendar cal = Calendar.getInstance();
                    cal.setTimeInMillis(record.getMillis());
                    sb.append(new SimpleDateFormat("HH:mm:ss:SSS").format(cal
                            .getTime()));
                    sb.append("\t");
                    sb.append(record.getSourceClassName());
                    sb.append("\tmethod: ");
                    sb.append(record.getSourceMethodName());
                    sb.append("()\t");
                    sb.append(record.getMessage());
                    sb.append("\n");
                    return sb.toString();
                }
            });
            Logger.getGlobal().addHandler(conHdlr);
            Logger.getGlobal().setLevel(Level.FINE);
            Logger.getGlobal().info("Custom Logger created");
            return Logger.getGlobal();
        }

    }
