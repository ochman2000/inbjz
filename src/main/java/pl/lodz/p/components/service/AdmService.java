package pl.lodz.p.components.service;

import org.springframework.stereotype.Service;
import pl.lodz.p.core.Request;
import pl.lodz.p.dao.DatabaseDao;
import pl.lodz.p.h2.DatabaseAdmImpl;

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
