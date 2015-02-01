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
import pl.lodz.p.h2.DatabaseAdmImpl;

import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

/**
 * Created by Łukasz Ochmański on 1/14/2015.
 */

@Service
public class AdmService extends DbService {

    @Override
    protected DatabaseDao getDatabase(Request request) {
        DatabaseDao database;
        if ("real".equals(request.getMode())) {
            database = DatabaseAdmImpl.getInstance();
        } else {
            database = new DatabaseAdmImpl();
        }
        return database;
    }
}
