package pl.lodz.p.components.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pl.lodz.p.core.InbjzResultSet;
import pl.lodz.p.core.Query;
import pl.lodz.p.dao.DatabaseDao;
import pl.lodz.p.h2.DatabaseImpl;

import java.util.Arrays;
import java.util.List;

/**
 * Created by Łukasz Ochmański on 1/14/2015.
 */

@Service
public class QueryService {



    @Transactional
    public InbjzResultSet select(Query message) {
        DatabaseDao database = new DatabaseImpl();
        List<String[]> result = database.executeQuery(message.getQuery());
        InbjzResultSet res = new InbjzResultSet();
        res.setActual(result);
        res.setExpected(result);
        res.setTaskId(1);
        res.setContent("String representation of this result");
        return res;
    }

    public InbjzResultSet greeting(Query message) {
        DatabaseDao database = new DatabaseImpl();
        List<String[]> result = database.executeQuery(message.getQuery());
        StringBuilder sb = new StringBuilder();
        for (String[] row : result) {
            sb.append(Arrays.toString(row));
            sb.append("\n");
        }
        return new InbjzResultSet(sb.toString());
    }

    public InbjzResultSet execute(Query message) {
        DatabaseDao database = new DatabaseImpl();
        List<String[]> result = database.executeQuery(message.getQuery());
        StringBuilder sb = new StringBuilder();
        for (String[] row : result) {
            sb.append(Arrays.toString(row));
            sb.append("\n");
        }
        return new InbjzResultSet(sb.toString());
    }
}
