package pl.lodz.p.components.service;

import org.springframework.stereotype.Service;
import pl.lodz.p.core.Request;
import pl.lodz.p.dao.DatabaseDao;
import pl.lodz.p.h2.DatabaseStudImpl;

/**
 * Created by Łukasz Ochmański on 1/14/2015.
 */

@Service
public class QueryService extends DbService {

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
}
