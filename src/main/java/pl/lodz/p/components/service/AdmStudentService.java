package pl.lodz.p.components.service;

import org.h2.jdbc.JdbcSQLException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.stereotype.Service;
import pl.lodz.p.core.*;
import pl.lodz.p.dao.DatabaseDao;
import pl.lodz.p.h2.DatabaseAdmImpl;

import java.sql.SQLException;
import java.util.List;

/**
 * Created by Łukasz Ochmański on 1/14/2015.
 */

@Service
public class AdmStudentService extends DbService {

    @Override
    protected DatabaseDao getDatabase(Request request) {
//        return DatabaseAdmImpl.getInstance(User.STUDENT);
        return DatabaseAdmImpl.getInstance(User.SA);
    }


}
