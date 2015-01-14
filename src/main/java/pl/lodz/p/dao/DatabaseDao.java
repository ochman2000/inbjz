package pl.lodz.p.dao;

import java.util.List;

/**
 * Created by Łukasz Ochmański on 1/13/2015.
 */
public interface DatabaseDao {
    List<String[]> executeQuery(String sql);

    void executeStmt(String sql);

    void update(String sql);
}
