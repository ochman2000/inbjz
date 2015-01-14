package pl.lodz.p.webSocket;

import java.util.List;

public class InbjzResultSet {

    private String content;
    private int taskId;
    private List<String[]> expected;
    private List<String[]> actual;
    private List<String[]> difference;

    public InbjzResultSet(String content) {
        this.content = content;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public List<String[]> getExpected() {
        return expected;
    }

    public void setExpected(List<String[]> expected) {
        this.expected = expected;
    }

    public List<String[]> getActual() {
        return actual;
    }

    public void setActual(List<String[]> actual) {
        this.actual = actual;
    }

    public List<String[]> getDifference() {
        return difference;
    }

    public void setDifference(List<String[]> difference) {
        this.difference = difference;
    }
}
