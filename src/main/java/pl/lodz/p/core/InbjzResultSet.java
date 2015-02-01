package pl.lodz.p.core;

import java.util.List;

public class InbjzResultSet {

    private String info;
    private int taskId;
    private String status;
    private boolean correct;
    private String type;
    private String consoleOutput;
    private String errorMessage;
    private String[] expectedHeaders;
    private List<String[]> expected;
    private String[] actualHeaders;
    private List<String[]> actual;
    private List<Integer> missingRowIds;
    private List<Integer> extraRowIds;
    private List<String[]> missingRows;
    private List<String[]> extraRows;

    public InbjzResultSet() {

    }

    public InbjzResultSet(String info) {
        this.info = info;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status == Status.ERROR ? "ERROR" : "OK";
    }

    public boolean isCorrect() {
        return correct;
    }

    public void setCorrect(boolean correct) {
        this.correct = correct;
    }

    public String getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type == Type.EXECUTE ? "execute" : "query";
    }

    public String getConsoleOutput() {
        return consoleOutput;
    }

    public void setConsoleOutput(String consoleOutput) {
        this.consoleOutput = consoleOutput;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getInfo() {
        return info;
    }

    public void setContent(String content) {
        this.info = info;
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

    public List<Integer> getMissingRowIds() {
        return missingRowIds;
    }

    public void setMissingRowIds(List<Integer> missingRowIds) {
        this.missingRowIds = missingRowIds;
    }

    public List<Integer> getExtraRowIds() {
        return extraRowIds;
    }

    public void setExtraRowIds(List<Integer> extraRowIds) {
        this.extraRowIds = extraRowIds;
    }

    public List<String[]> getMissingRows() {
        return missingRows;
    }

    public void setMissingRows(List<String[]> missingRows) {
        this.missingRows = missingRows;
    }

    public List<String[]> getExtraRows() {
        return extraRows;
    }

    public void setExtraRows(List<String[]> extraRows) {
        this.extraRows = extraRows;
    }

    public String[] getExpectedHeaders() {
        return expectedHeaders;
    }

    public void setExpectedHeaders(String[] expectedHeaders) {
        this.expectedHeaders = expectedHeaders;
    }

    public String[] getActualHeaders() {
        return actualHeaders;
    }

    public void setActualHeaders(String[] actualHeaders) {
        this.actualHeaders = actualHeaders;
    }
}
