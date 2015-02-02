package pl.lodz.p.components.contoller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.MessageHeaders;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import pl.lodz.p.components.service.AdmService;
import pl.lodz.p.components.service.AdmStudentService;
import pl.lodz.p.core.InbjzResultSet;
import pl.lodz.p.core.Request;
import pl.lodz.p.core.Task;

import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Created by Łukasz Ochmański on 1/13/2015.
 */

@Controller
public class TaskController {

    @Autowired
    private AdmService admService;
    @Autowired
    AdmStudentService admStudentService;
    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;
    @Autowired
    private HttpSession session;

    private static final Logger logger = LoggerFactory.getLogger(QueryController.class);

    @Autowired
    public TaskController(AdmService admService,
                          AdmStudentService admStudentService,
                          SimpMessagingTemplate simpMessagingTemplate,
                          HttpSession session) {
        this.admService = admService;
        this.admStudentService = admStudentService;
        this.simpMessagingTemplate = simpMessagingTemplate;
        this.session = session;
    }

    @MessageMapping("/task/query")
    @SendToUser("/queue/position-updates")
    public InbjzResultSet executeQuery(Request message, MessageHeaders messageHeaders) {
        String clientId = getClientString(messageHeaders);
        logger.info("Client ID: "+clientId);
        return admStudentService.select(message);
    }

    private String getClientString(MessageHeaders messageHeaders) {
        if (messageHeaders==null) { return null; }
        LinkedMultiValueMap<String, String> nativeHeaders =
                (LinkedMultiValueMap<String, String>) messageHeaders.get("nativeHeaders");
        if (nativeHeaders==null) { return null; }
        List<String> strings = nativeHeaders.get("client-id");
        if (strings==null || strings.size()==0) { return null; }
        return strings.get(0);
    }

    private String getTimestamp() {
        LocalDateTime date = LocalDateTime.now();
        return date.format(DateTimeFormatter.ISO_DATE_TIME);
    }

    @ResponseBody
    @RequestMapping("/task/sessionId")
    public String sessionId() {
        return this.session.getId();
    }

    @MessageMapping("/getTaskById")
    @SendToUser("/queue/getTaskById")
    public Task getTaskById(int id) throws Exception {
        return null;
    }

    @MessageMapping("/getTask")
    @SendToUser("/queue/getTask")
    public Task getTask(int chapter, int number) throws Exception {
        return null;
    }

    @MessageMapping("/getAllTasks")
    @SendToUser("/queue/getAllTasks")
    public List<Task> getTasks() throws Exception {
        return null;
    }
}
