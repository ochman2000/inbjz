package pl.lodz.p.webSocket;

import org.springframework.beans.factory.annotation.Autowired;
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

    @Autowired
    private QueryService queryService;

    @Autowired
    public QueryController(QueryService queryService) {
        this.queryService = queryService;
    }

    @MessageMapping("/hello")
    @SendTo("/topic/greetings")
    public InbjzResultSet greeting(Query message) throws Exception {
        return queryService.greeting(message);
    }

    @MessageMapping("/execute")
    @SendTo("/topic/execute")
    public InbjzResultSet execute(Query message) throws Exception {
       return queryService.execute(message);
    }

    @MessageMapping("/query")
    @SendTo("/topic/query")
    public InbjzResultSet select(Query message) throws Exception {
        return queryService.select(message);
    }
}
