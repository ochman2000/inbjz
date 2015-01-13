package pl.lodz.p.webSocket;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import pl.lodz.p.h2.Database;

import java.util.Arrays;
import java.util.List;

@Controller
public class QueryController {

    @MessageMapping("/hello")
    @SendTo("/topic/greetings")
    public InbjzResultSet greeting(Query message) throws Exception {
        Database database = new Database();
        List<String[]> result = database.executeQuery(message.getQuery());
        StringBuilder sb = new StringBuilder();
        for (String[] row : result) {
            sb.append(Arrays.toString(row));
            sb.append("\n");
        }
        return new InbjzResultSet(sb.toString());
    }

    @MessageMapping("/execute")
    @SendTo("/type/execute")
    public InbjzResultSet execute(Query message) throws Exception {
        Database database = new Database();
        List<String[]> result = database.executeQuery(message.getQuery());
        StringBuilder sb = new StringBuilder();
        for (String[] row : result) {
            sb.append(Arrays.toString(row));
            sb.append("\n");
        }
        return new InbjzResultSet(sb.toString());
    }

    @MessageMapping("/query")
    @SendTo("/type/query")
    public InbjzResultSet select(Query message) throws Exception {
        Database database = new Database();
        List<String[]> result = database.executeQuery(message.getQuery());
        StringBuilder sb = new StringBuilder();
        for (String[] row : result) {
            sb.append(Arrays.toString(row));
            sb.append("\n");
        }
        return new InbjzResultSet(sb.toString());
    }
}
