package pl.lodz.p.components.service;

import org.h2.jdbc.JdbcSQLException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.stereotype.Service;
import pl.lodz.p.core.InbjzResultSet;
import pl.lodz.p.core.Request;
import pl.lodz.p.core.Status;
import pl.lodz.p.core.Type;
import pl.lodz.p.dao.DatabaseDao;
import pl.lodz.p.h2.DatabaseStudImpl;

import java.sql.SQLException;
import java.util.List;

/**
 * Created by Łukasz Ochmański on 1/14/2015.
 */

@Service
public class QueryService extends DbService {

    @Autowired
    private AdmService admService;

    @Autowired
    public QueryService(AdmService admService) {
        this.admService = admService;
    }

    @Override
    protected DatabaseDao getDatabase(Request request) {
        DatabaseDao database;
        if ("real".equals(request.getMode())) {
            database = DatabaseStudImpl.getInstance();
        } else {
            database = new DatabaseStudImpl();
        }
        return database;
    }

    public InbjzResultSet select(Request request, String clientId) {
        DatabaseDao database = getDatabase(request);
        String[] actualHeaders;
        List<String[]> actual;
        String answer = admService.getAnswer(request.getTaskId());
        String definedType = admService.getType(request.getTaskId());
        String[] expectedHeaders = new String[]{"null"};
        List<String[]> expected = null;
        InbjzResultSet res = new InbjzResultSet();
        res.setTaskId(request.getTaskId());
        res.setType(Type.QUERY);
        try {
            actual = database.executeQuery(request.getQuery());
            actualHeaders = database.getLabels(request.getQuery());
            if ("QUERY".equals(definedType) && answer!=null) {
                expected = database.executeQuery(answer);
                expectedHeaders = database.getLabels(answer);
            }
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
        res.setActualHeaders(actualHeaders);
        res.setActual(actual);
        res.setExpected(expected);
        res.setExpectedHeaders(expectedHeaders);
        res.setTaskId(request.getTaskId());
        res.setStatus(Status.OK);
        res.setCorrect("QUERY".equals(definedType) ? equals(actual, expected) : true);
        res.setContent("String representation of this result");
        return res;
    }
}
