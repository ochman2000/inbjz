package pl.lodz.p.core;

import java.util.List;

/**
 * Created by Łukasz Ochmański on 1/13/2015.
 */
public interface TaskRepository {

    Task getTaskById();
    Task getTask(int chapter, int number);
    List<Task> getTasks(int chapter);
    List<Task> getTasks();
}
