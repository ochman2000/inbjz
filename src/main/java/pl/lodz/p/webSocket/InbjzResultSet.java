package pl.lodz.p.webSocket;

public class InbjzResultSet {
    
    private String content;
    private String expected;
    private String actual;

    public InbjzResultSet(String content) {
        this.content = content;
    }

    public String getContent() {
        return content;
    }

}
