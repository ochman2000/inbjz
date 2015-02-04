package pl.lodz.p.components.service;

import org.h2.jdbc.JdbcSQLException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.stereotype.Service;
import pl.lodz.p.core.InbjzResultSet;
import pl.lodz.p.core.Request;
import pl.lodz.p.core.Type;
import pl.lodz.p.core.User;
import pl.lodz.p.dao.DatabaseDao;
import pl.lodz.p.h2.DatabaseAdmImpl;

import java.sql.SQLException;
import java.util.List;

/**
 * Created by Łukasz Ochmański on 1/14/2015.
 */

@Service
public class AdmService extends DbService {

    private static final Logger logger = LoggerFactory.getLogger(AdmService.class);

    @Override
    protected DatabaseDao getDatabase(Request request) {
        return getDatabase();
    }

    protected DatabaseDao getDatabase() {
        return DatabaseAdmImpl.getInstance(User.SA);
    }

    public String getAnswer(int taskId) {
        DatabaseDao database = getDatabase();
        List<String[]> actual = null;
        try {
            actual = database.executeQuery(getQuery(taskId));
        } catch (UncategorizedSQLException e) {
            logger.error(e.getCause().getMessage());
            return "Could not retrieve answer for this ID:"+taskId;
        } catch (DuplicateKeyException | JdbcSQLException e) {
            logger.error(e.getCause().getMessage());
            return "Could not retrieve answer for this ID:"+taskId;
        } catch (DataIntegrityViolationException | SQLException e) {
            logger.error(e.getCause().getMessage());
            return "Could not retrieve answer for this ID:"+taskId;
        } catch (Exception e) {
            logger.error(e.getCause().getMessage());
            return "Could not retrieve answer for this ID:"+taskId;
        }
        if (actual!=null && actual.size()==1 && actual.get(0)!=null && actual.get(0).length==1) {
            return actual.get(0)[0];
        } else {
            return null;
        }
    }

    private String getQuery(int taskId) {
        return "select a.answer from tasks t join answers a on t.answer_id=a.id where t.id="+taskId;
    }

    public String getType(int taskId) {
        DatabaseDao database = getDatabase();
        List<String[]> actual = null;
        try {
            actual = database.executeQuery("select type from tasks where id="+taskId);
        } catch (UncategorizedSQLException e) {
            logger.error(e.getCause().getMessage());
            return "Could not retrieve type for this ID:"+taskId;
        } catch (DuplicateKeyException | JdbcSQLException e) {
            logger.error(e.getCause().getMessage());
            return "Could not retrieve type for this ID:"+taskId;
        } catch (DataIntegrityViolationException | SQLException e) {
            logger.error(e.getCause().getMessage());
            return "Could not retrieve type for this ID:"+taskId;
        } catch (Exception e) {
            logger.error(e.getCause().getMessage());
            return "Could not retrieve type for this ID:"+taskId;
        }
        if (actual!=null && actual.size()==1 && actual.get(0)!=null && actual.get(0).length==1) {
            return actual.get(0)[0];
        } else {
            return null;
        }
    }

    public int logPoint(int taskId, String clientId, String givenAnswer, boolean correct) {
        DatabaseDao database = getDatabase();
        int answerId = getNextAnswerSeq();
        if (answerId==-1) {
            logger.error("Could not retrieve a sequence number for logged_answer");
            return -1;
        }
        try {
            database.executeStmt("insert into logged_answers values (" +
                    answerId +", '"+givenAnswer+"');");

            database.executeStmt("insert into logs (id, student_id, client_id, task_id, answer_id, correct) " +
                    "values (" +
                    "LOGS_SEQ_ID.nextval," +
                    clientId +", "+
//                    session_id + ", "+
                    clientId + ", "+
                    taskId + ", " +
                    answerId +", " +
                    (correct ? "'TRUE'" : "'FALSE'")
                    +");");
        } catch (SQLException e) {
            logger.error(e.getCause().getMessage());
        }
        logger.info("Student "+clientId+" has answered question ID "+taskId+" correctly.");
        return 0;
    }

    private int getNextAnswerSeq() {
        DatabaseDao database = getDatabase();
        List<String[]> actual = null;
        try {
            actual = database.executeQuery("select LOGGED_ANSWERS_SEQ_ID.nextval;");
        } catch (UncategorizedSQLException e) {
            logger.error(e.getCause().getMessage());
        } catch (DuplicateKeyException | JdbcSQLException e) {
            logger.error(e.getCause().getMessage());
        } catch (DataIntegrityViolationException | SQLException e) {
            logger.error(e.getCause().getMessage());
        } catch (Exception e) {
            logger.error(e.getCause().getMessage());
        }
        if (actual!=null && actual.size()==1 && actual.get(0)!=null && actual.get(0).length==1) {
            return Integer.parseInt(actual.get(0)[0]);
        } else {
            return -1;
        }
    }
}
