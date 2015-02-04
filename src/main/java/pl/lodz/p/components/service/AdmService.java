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
        return "select answer from answers where task_id="+taskId;
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

    public void logPoint(int taskId, String clientId, String givenAnswer) {
        DatabaseDao database = getDatabase();
        try {
            database.executeStmt("insert into logs (id, student_id, client_id, task_id, answer, correct) values (id, "+
            clientId +", "+
    //                session_id + ", "+
                    clientId + ", "+
                    taskId + ", " +
                    givenAnswer +", " +
                    "TRUE" +");");
        } catch (SQLException e) {
            logger.error(e.getCause().getMessage());
        }

//        ID INT NOT NULL,
//        STUDENT_ID INT,
//        SESSION_ID VARCHAR(100),
//                CLIENT_ID VARCHAR(20),
//                TASK_ID INT,
//                ANSWER VARCHAR(2000),
//                CORRECT VARCHAR(5),
//                LOG_DATE DATETIME DEFAULT CURRENT_TIMESTAMP()
    }
}
