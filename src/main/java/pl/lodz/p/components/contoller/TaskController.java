package pl.lodz.p.components.contoller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.stereotype.Controller;
import pl.lodz.p.core.Task;

import java.util.List;

/**
 * Created by Łukasz Ochmański on 1/13/2015.
 */

@Controller
public class TaskController {

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
