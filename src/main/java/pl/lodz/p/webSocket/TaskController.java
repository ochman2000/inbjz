package pl.lodz.p.webSocket;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import pl.lodz.p.core.Task;

import java.util.List;

/**
 * Created by Łukasz Ochmański on 1/13/2015.
 */

@Controller
public class TaskController {

    @MessageMapping("/getTaskById")
    @SendTo("/topic/getTaskById")
    public Task getTaskById(int id) throws Exception {
        return null;
    }

    @MessageMapping("/getTask")
    @SendTo("/topic/getTask")
    public Task getTask(int chapter, int number) throws Exception {
        return null;
    }

    @MessageMapping("/getAllTasks")
    @SendTo("/topic/getAllTasks")
    public List<Task> getTasks() throws Exception {
        return null;
    }
}
