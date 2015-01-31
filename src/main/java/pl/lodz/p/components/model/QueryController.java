package pl.lodz.p.components.model;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import pl.lodz.p.core.InbjzResultSet;
import pl.lodz.p.core.Request;
import pl.lodz.p.components.service.QueryService;

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
    public InbjzResultSet greeting(Request message) throws Exception {
        return queryService.greeting(message);
    }

    @MessageMapping("/execute")
    @SendTo("/topic/execute")
    public InbjzResultSet execute(Request message) throws Exception {
       return queryService.execute(message);
    }

    @MessageMapping("/query")
    @SendTo("/topic/query")
    public InbjzResultSet select(Request message) throws Exception {
        return queryService.select(message);
    }
}
