package pl.lodz.p.components.service;

import org.h2.jdbc.JdbcSQLException;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pl.lodz.p.config.Application;
import pl.lodz.p.core.InbjzResultSet;
import pl.lodz.p.core.Mode;
import pl.lodz.p.core.Query;
import pl.lodz.p.dao.DatabaseDao;
import pl.lodz.p.h2.DatabaseImpl;

import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Logger;

/**
 * Created by Łukasz Ochmański on 1/14/2015.
 */

@Service
public class QueryService {

    private Logger logger = Application.getCustomLogger();

    @Transactional
    public InbjzResultSet select(Query message) {
        DatabaseDao database = DatabaseImpl.getInstance();

        List<String[]> actual = null;
        String[] actualHeaders = new String[]{"null"};
        InbjzResultSet res = new InbjzResultSet();
        res.setMode(Mode.QUERY);
        try {
            actual = database.executeQuery(message.getQuery());
            actualHeaders = database.getLabels(message.getQuery());
        } catch (UncategorizedSQLException | JdbcSQLException e) {
            logger.severe(e.getClass()+" "+e.getMessage());
            res.setSuccess(false);
            if (e.getMessage().endsWith("[90002-176]")) {
                return update(message);
//                res.setErrorMessage("Aby wykonać polecenie typu DDL "
//                        "należy jawnie wskazać tryb przyciskiem EXECUTE w lewym górnym rogu panelu i " +
//                        "wykonać polecenie ponownie.");
            } else {
                res.setErrorMessage(e.getCause().getMessage());
            }
            return res;
        } catch (SQLException | BadSqlGrammarException e) {
            logger.severe(e.getClass()+" "+e.getMessage());
            res.setSuccess(false);
            res.setErrorMessage(e.getCause().getMessage());
            return res;
        }
        res.setActualHeaders(actualHeaders);
        res.setActual(actual);
        String[] expectedHeaders = actualHeaders;
        res.setExpectedHeaders(expectedHeaders);
        List<String[]> expected = actual;
        res.setExpected(expected);
        res.setTaskId(message.getTaskId());
        res.setSuccess(true);
        res.setContent("String representation of this result");
        return res;
    }

    public InbjzResultSet greeting(Query message) {
        DatabaseDao database = DatabaseImpl.getInstance();
        List<String[]> result = null;
        try {
            result = database.executeQuery(message.getQuery());
        } catch (SQLException e) {
            logger.severe(e.getMessage());
        }
        StringBuilder sb = new StringBuilder();
        for (String[] row : result) {
            sb.append(Arrays.toString(row));
            sb.append("\n");
        }
        return new InbjzResultSet(sb.toString());
    }

    public InbjzResultSet execute(Query message) {
        DatabaseDao database = DatabaseImpl.getInstance();
        InbjzResultSet res = new InbjzResultSet();
        String output;
        res.setMode(Mode.EXECUTE);
        try {
            output = database.executeStmt(message.getQuery());
        } catch (UncategorizedSQLException | JdbcSQLException e) {
            logger.severe(e.getClass()+" "+e.getMessage());
            res.setSuccess(false);
            res.setErrorMessage(e.getCause().getMessage());
            return res;
        } catch (SQLException | BadSqlGrammarException e) {
            logger.severe(e.getClass()+" "+e.getMessage());
            res.setSuccess(false);
            res.setErrorMessage(e.getCause().getMessage());
            return res;
        }
        res.setTaskId(message.getTaskId());
        res.setSuccess(true);
        res.setConsoleOutput(output);
        res.setContent("String representation of this result");
        return res;
    }

    public InbjzResultSet update(Query message) {
        DatabaseDao database = DatabaseImpl.getInstance();
        InbjzResultSet res = new InbjzResultSet();
        String output;
        res.setMode(Mode.EXECUTE);
        try {
            output = database.update(message.getQuery());
        } catch (UncategorizedSQLException e) {
            logger.severe(e.getClass()+" "+e.getMessage());
            res.setSuccess(false);
            res.setErrorMessage(e.getCause().getMessage());
            return res;
        } catch (BadSqlGrammarException e) {
            logger.severe(e.getClass()+" "+e.getMessage());
            res.setSuccess(false);
            res.setErrorMessage(e.getCause().getMessage());
            return res;
        }
        res.setTaskId(message.getTaskId());
        res.setSuccess(true);
        res.setConsoleOutput(output);
        res.setContent("String representation of this result");
        return res;
    }
}
