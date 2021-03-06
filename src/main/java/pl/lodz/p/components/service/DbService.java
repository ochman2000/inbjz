package pl.lodz.p.components.service;

import org.h2.jdbc.JdbcSQLException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pl.lodz.p.core.InbjzResultSet;
import pl.lodz.p.core.Request;
import pl.lodz.p.core.Status;
import pl.lodz.p.core.Type;
import pl.lodz.p.dao.DatabaseDao;
import pl.lodz.p.h2.DatabaseStudImpl;

import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

@Service
public class DbService {

    private static final Logger logger = LoggerFactory.getLogger(DbService.class);

    @Transactional
    public InbjzResultSet select(Request request) {
        DatabaseDao database = getDatabase(request);
        List<String[]> actual;
        String[] actualHeaders;
        InbjzResultSet res = new InbjzResultSet();
        res.setTaskId(request.getTaskId());
        res.setType(Type.QUERY);
        try {
            actual = database.executeQuery(request.getQuery());
            actualHeaders = database.getLabels(request.getQuery());
        } catch (UncategorizedSQLException e) {
            if (e.getSQLException().getErrorCode()==90002){
                return fallBackUpdate(request, res);
            } else {
                return handleException(e, res);
            }
        } catch (DuplicateKeyException | JdbcSQLException e) {
            return handleException(e, res);
        } catch (DataIntegrityViolationException | SQLException e) {
            return handleException(e, res);
        } catch (Exception e) {
            return handleException(e, res);
        }
        setValues(request, actual, actualHeaders, res);
        return res;
    }

    private void setValues(Request request, List<String[]> actual, String[] actualHeaders, InbjzResultSet res) {
        res.setActualHeaders(actualHeaders);
        res.setActual(actual);
        res.setTaskId(request.getTaskId());
        res.setExpectedHeaders(res.getActualHeaders());
        res.setExpected(res.getActual());
        res.setStatus(Status.OK);
        res.setCorrect(true);
        res.setContent("String representation of this result");
    }

    protected InbjzResultSet handleException(Throwable t, InbjzResultSet res) {
        logger.error(t.getClass() + " " + t.getMessage());
        res.setStatus(Status.ERROR);
        res.setCorrect(false);
        res.setErrorMessage(t.getCause().getMessage());
        return res;
    }

    protected InbjzResultSet fallBackUpdate(Request request,InbjzResultSet res) {
        try {
            return update(request);
        } catch (DuplicateKeyException e1) {
            return handleException(e1, res);
        } catch (DataIntegrityViolationException | UncategorizedSQLException | SQLException e1) {
            return handleException(e1, res);
        } catch (Exception e1) {
            return handleException(e1, res);
        }
    }

    protected boolean equals(List<String[]> actual, List<String[]> expected) {
        if (actual==null && expected==null) {
            return true;
        }
        if (actual==null || expected==null) {
            return false;
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
                if (actual.get(i)[j]==null && expected.get(i)[j]==null){
                    continue;
                }
                if (actual.get(i)[j]==null || !actual.get(i)[j].equals(expected.get(i)[j])) {
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
            logger.error(e.getMessage());
        }
        StringBuilder sb = new StringBuilder();
        if (result != null) {
            for (String[] row : result) {
                sb.append(Arrays.toString(row));
                sb.append("\n");
            }
        } else {
            sb.append("Nie znaleziono żadnych wyników zapytania.");
        }
        return new InbjzResultSet(sb.toString());
    }

    public InbjzResultSet execute(Request request) {
        DatabaseDao database = getDatabase(request);
        InbjzResultSet res = new InbjzResultSet();
        String output;
        res.setTaskId(request.getTaskId());
        res.setType(Type.EXECUTE);
        try {
            output = database.executeStmt(request.getQuery());
        } catch (DuplicateKeyException | UncategorizedSQLException | JdbcSQLException e) {
            return handleException(e, res);
        } catch (SQLException | BadSqlGrammarException e) {
            return handleException(e, res);
        } catch (Exception e) {
            return handleException(e, res);
        }
        res.setTaskId(request.getTaskId());
        res.setStatus(Status.OK);
        res.setCorrect(true);
        res.setConsoleOutput(output);
        res.setContent("String representation of this result");
        return res;
    }

    public InbjzResultSet update(Request request) throws SQLException {
        DatabaseDao database = getDatabase(request);
        InbjzResultSet res = new InbjzResultSet();
        String output;
        res.setTaskId(request.getTaskId());
        res.setType(Type.EXECUTE);
        try {
            output = database.update(request.getQuery());
        } catch (DuplicateKeyException | UncategorizedSQLException e) {
            return handleException(e, res);
        } catch (BadSqlGrammarException e) {
            return handleException(e, res);
        }
        res.setTaskId(request.getTaskId());
        res.setStatus(Status.OK);
        res.setCorrect(true);
        res.setConsoleOutput(output);
        res.setContent("String representation of this result");
        try {
            getAdmService().logPoint(request.getTaskId(), request.getStudentId(), request.getQuery(),
                    res.isCorrect());
        } catch (Throwable t) {
            logger.error("Problem with a logging module.");
        }
        res.setContent("String representation of this result");
        return res;
    }

    protected DatabaseDao getDatabase(Request request) {
        DatabaseDao database;
        if ("real".equals(request.getMode())) {
            database = DatabaseStudImpl.getInstance();
        } else {
            database = new DatabaseStudImpl();
        }
        return database;
    }

    public AdmService getAdmService() {
        return null;
    }
}
