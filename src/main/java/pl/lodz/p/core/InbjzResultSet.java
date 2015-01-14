package pl.lodz.p.core;

import java.util.List;

public class InbjzResultSet {

    private String content;
    private int taskId;
    private boolean success;
    private String mode;
    private String consoleOutput;
    private String errorMessage;
    private String[] expectedHeaders;
    private List<String[]> expected;
    private String[] actualHeaders;
    private List<String[]> actual;
    private List<Integer> missingRowsId;
    private List<Integer> extraRowsId;
    private List<String[]> missingRows;
    private List<String[]> extraRows;

    public InbjzResultSet() {

    }

    public InbjzResultSet(String content) {
        this.content = content;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMode() {
        return mode;
    }

    public void setMode(Mode mode) {
        this.mode = mode == Mode.EXECUTE ? "execute" : "query";
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

    public List<Integer> getMissingRowsId() {
        return missingRowsId;
    }

    public void setMissingRowsId(List<Integer> missingRowsId) {
        this.missingRowsId = missingRowsId;
    }

    public List<Integer> getExtraRowsId() {
        return extraRowsId;
    }

    public void setExtraRowsId(List<Integer> extraRowsId) {
        this.extraRowsId = extraRowsId;
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
