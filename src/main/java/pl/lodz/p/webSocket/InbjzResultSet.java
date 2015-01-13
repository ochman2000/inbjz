package pl.lodz.p.webSocket;

public class InbjzResultSet {
    
    private String content;
    private String expected;
    private String actual;
    private String difference;

    public InbjzResultSet(String content) {
        this.content = content;
    }

    public String getContent() {
        return content;
    }

}
