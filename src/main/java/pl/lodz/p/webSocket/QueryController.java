package pl.lodz.p.webSocket;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import pl.lodz.p.core.InbjzResultSet;
import pl.lodz.p.core.Query;
import pl.lodz.p.dao.DatabaseDao;
import pl.lodz.p.h2.DatabaseImpl;

import java.util.Arrays;
import java.util.List;

@Controller
public class QueryController {

    @MessageMapping("/hello")
    @SendTo("/topic/greetings")
    public InbjzResultSet greeting(Query message) throws Exception {
        DatabaseDao database = new DatabaseImpl();
        List<String[]> result = database.executeQuery(message.getQuery());
        StringBuilder sb = new StringBuilder();
        for (String[] row : result) {
            sb.append(Arrays.toString(row));
            sb.append("\n");
        }
        return new InbjzResultSet(sb.toString());
    }

    @MessageMapping("/execute")
    @SendTo("/topic/execute")
    public InbjzResultSet execute(Query message) throws Exception {
        DatabaseDao database = new DatabaseImpl();
        List<String[]> result = database.executeQuery(message.getQuery());
        StringBuilder sb = new StringBuilder();
        for (String[] row : result) {
            sb.append(Arrays.toString(row));
            sb.append("\n");
        }
        return new InbjzResultSet(sb.toString());
    }

    @MessageMapping("/query")
    @SendTo("/topic/query")
    public InbjzResultSet select(Query message) throws Exception {
        DatabaseDao database = new DatabaseImpl();
        List<String[]> result = database.executeQuery(message.getQuery());
        InbjzResultSet res = new InbjzResultSet();
        res.setActual(result);
        res.setExpected(result);
        res.setTaskId(1);
        res.setContent("String representation of this result");
        return res;
    }
}
