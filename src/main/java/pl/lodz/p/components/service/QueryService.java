package pl.lodz.p.components.service;

import org.h2.jdbc.JdbcSQLException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pl.lodz.p.config.Application;
import pl.lodz.p.core.InbjzResultSet;
import pl.lodz.p.core.Mode;
import pl.lodz.p.core.Request;
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
    public InbjzResultSet select(Request request) {
        DatabaseDao database = getDatabase(request);
        List<String[]> actual = null;
        String[] actualHeaders = new String[]{"null"};
        InbjzResultSet res = new InbjzResultSet();
        res.setMode(Mode.QUERY);
        try {
            actual = database.executeQuery(request.getQuery());
            actualHeaders = database.getLabels(request.getQuery());
        } catch (DuplicateKeyException | UncategorizedSQLException | JdbcSQLException e) {
            if (e.getMessage().endsWith("[90002-176]")) {
                try {
                    return update(request);
                } catch (DuplicateKeyException e1) {
                    logger.severe(e1.getClass()+" "+e1.getMessage());
                    res.setSuccess(false);
                    res.setErrorMessage(e1.getCause().getMessage());
                } catch (DataIntegrityViolationException  | UncategorizedSQLException | SQLException e1) {
                    logger.severe(e1.getClass()+" "+e1.getMessage());
                    res.setSuccess(false);
                    res.setErrorMessage(e1.getCause().getMessage());
                } catch (Exception e1) {
                    logger.severe(e1.getClass()+" "+e1.getMessage());
                    res.setSuccess(false);
                    res.setErrorMessage(e1.getCause().getMessage());
                }
            } else {
                logger.severe(e.getClass()+" "+e.getMessage());
                res.setSuccess(false);
                res.setErrorMessage(e.getCause().getMessage());
            }
            return res;
        } catch (DataIntegrityViolationException | SQLException e) {
            logger.severe(e.getClass() + " " + e.getMessage());
            res.setSuccess(false);
            res.setErrorMessage(e.getCause().getMessage());
            return res;
        } catch (Exception e) {
            logger.severe(e.getClass() + " " + e.getMessage());
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
        res.setTaskId(request.getTaskId());
        res.setSuccess(true);
        res.setCorrect(equals(actual, expected));
        res.setContent("String representation of this result");
        return res;
    }

    private boolean equals(List<String[]> actual, List<String[]> expected) {
        if (actual==null && expected==null) {
            return true;
        }
        if (actual.size()!=expected.size()) {
            return false;
        }
        if (actual.size()>0) {
            if (actual.get(0).length!=expected.get(0).length) {
                return false;
            }
        }
        for (int i=0; i<actual.size(); i++) {
            for (int j=0; j<actual.get(i).length; j++) {
                if (!actual.get(i)[j].equals(expected.get(i)[j])) {
                    return false;
                }
            }
        }
        return true;
    }


    public InbjzResultSet greeting(Request request) {
        DatabaseDao database = getDatabase(request);
        List<String[]> result = null;
        try {
            result = database.executeQuery(request.getQuery());
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

    public InbjzResultSet execute(Request request) {
        DatabaseDao database = getDatabase(request);
        InbjzResultSet res = new InbjzResultSet();
        String output;
        res.setMode(Mode.EXECUTE);
        try {
            output = database.executeStmt(request.getQuery());
        } catch (DuplicateKeyException | UncategorizedSQLException | JdbcSQLException e) {
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
        res.setTaskId(request.getTaskId());
        res.setSuccess(true);
        res.setConsoleOutput(output);
        res.setContent("String representation of this result");
        return res;
    }

    public InbjzResultSet update(Request request) throws SQLException {
        DatabaseDao database = getDatabase(request);
        InbjzResultSet res = new InbjzResultSet();
        String output;
        res.setMode(Mode.EXECUTE);
        try {
            output = database.update(request.getQuery());
        } catch (DuplicateKeyException | UncategorizedSQLException e) {
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
        res.setTaskId(request.getTaskId());
        res.setSuccess(true);
        res.setConsoleOutput(output);
        res.setContent("String representation of this result");
        return res;
    }

    private DatabaseDao getDatabase(Request request) {
        DatabaseDao database;
        if ("execute".equals(request.getMode())) {
            database = DatabaseImpl.getInstance();
        } else {
            database = new DatabaseImpl();
        }
        return database;
    }
}
