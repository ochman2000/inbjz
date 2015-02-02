package pl.lodz.p.dao;

import java.sql.SQLException;
import java.util.List;

/**
 * Created by Łukasz Ochmański on 1/13/2015.
 */
public interface DatabaseDao {
    static final int MAX_CHAR = 200;

    List<String[]> executeQuery(String sql) throws SQLException;

    String executeStmt(String sql) throws SQLException;

    String update(String sql);

    String[] getLabels(String sql);
}
