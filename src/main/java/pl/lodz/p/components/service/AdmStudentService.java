package pl.lodz.p.components.service;

import org.springframework.stereotype.Service;
import pl.lodz.p.core.Request;
import pl.lodz.p.core.User;
import pl.lodz.p.dao.DatabaseDao;
import pl.lodz.p.h2.DatabaseAdmImpl;

/**
 * Created by Łukasz Ochmański on 1/14/2015.
 */

@Service
public class AdmStudentService extends DbService {

    @Override
    protected DatabaseDao getDatabase(Request request) {
        return DatabaseAdmImpl.getInstance(User.STUDENT);
    }
}
