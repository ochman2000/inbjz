package pl.lodz.p.components.contoller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.MessageHeaders;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import pl.lodz.p.components.model.ChatMessage;
import pl.lodz.p.components.service.QueryService;
import pl.lodz.p.core.InbjzResultSet;
import pl.lodz.p.core.Request;

import javax.servlet.http.HttpSession;
import java.security.Principal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Controller
public class QueryController {

    @Autowired
    private QueryService queryService;
    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;
    @Autowired
    private HttpSession session;

    private static final Logger logger = LoggerFactory.getLogger(QueryController.class);

    @Autowired
    public QueryController(QueryService queryService, SimpMessagingTemplate simpMessagingTemplate, HttpSession session) {
        this.queryService = queryService;
        this.simpMessagingTemplate = simpMessagingTemplate;
        this.session = session;
    }

    @MessageMapping("/chats/{chatRoomId}")
    public void handleChat(@Payload ChatMessage message,
                           @DestinationVariable("chatRoomId") String chatRoomId,
                           MessageHeaders messageHeaders, Principal user) {
        logger.info(messageHeaders.toString());
        this.simpMessagingTemplate.convertAndSend("/topic/chats." + chatRoomId,
                "[" + getTimestamp() + "]:" + user.getName() + ":" + message.getMessage());
    }

    private String getTimestamp() {
        LocalDateTime date = LocalDateTime.now();
        return date.format(DateTimeFormatter.ISO_DATE_TIME);
    }

    @ResponseBody
    @RequestMapping("/sessionId")
    public String sessionId() {
        return this.session.getId();
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