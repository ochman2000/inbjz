package pl.lodz.p.core;

import pl.lodz.p.dao.TaskRepository;

import java.util.List;
import java.util.Map;

/**
 * Created by Łukasz Ochmański on 1/13/2015.
 */
public class TaskRepositoryImpl implements TaskRepository {

    private Map<Integer, Task> tasks;

    public TaskRepositoryImpl(){
        Task t01 = new Task();
        t01.setChapter(1);
        t01.setId(1);
        t01.setNumber(1);
        t01.setAnswer("se");
        tasks.put(1, new Task());
    }

    @Override
    public Task getTaskById() {
        return null;
    }

    @Override
    public Task getTask(int chapter, int number) {
        return null;
    }

    @Override
    public List<Task> getTasks(int chapter) {
        return null;
    }

    @Override
    public List<Task> getTasks() {
        return null;
    }
}
