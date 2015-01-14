package pl.lodz.p.h2;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.jdbc.support.rowset.SqlRowSetMetaData;
import pl.lodz.p.dao.DatabaseDao;
import pl.lodz.p.config.Application;

public class DatabaseImpl implements DatabaseDao {

    private JdbcTemplate jdbcTemplate;
    private Logger logger = Application.getCustomLogger();


    public DatabaseImpl() {

        SimpleDriverDataSource dataSource = new SimpleDriverDataSource();
        dataSource.setDriverClass(org.h2.Driver.class);
        dataSource.setUsername("sa");
        dataSource.setUrl("jdbc:h2:mem");
        dataSource.setPassword("");

        jdbcTemplate = new JdbcTemplate(dataSource);
        init(jdbcTemplate);
    }

    private void init(JdbcTemplate jdbcTemplate) {
        logger.info("Creating tables");
        jdbcTemplate.execute("drop table customers if exists");
        jdbcTemplate.execute("create table customers(" +
                "id serial, first_name varchar(255), last_name varchar(255))");

        String[] names = "John Woo;Jeff Dean;Josh Bloch;Josh Long".split(";");
        for (String fullname : names) {
            String[] name = fullname.split(" ");
            System.out.printf("Inserting customer record for %s %s\n", name[0], name[1]);
            jdbcTemplate.update(
                    "INSERT INTO customers(first_name,last_name) values(?,?)",
                    name[0], name[1]);
        }
    }

    @Override
    public List<String[]> executeQuery(String sql) {
        logger.info("Querying: " + sql);
        List<String[]> strLst = jdbcTemplate.query(sql,
                new RowMapper<String[]>() {
                    @Override
                    public String[] mapRow(ResultSet rs, int rowNum) throws SQLException {
                        int columnCount = rs.getMetaData().getColumnCount();
                        String[] row = new String[columnCount];
                        for (int i = 0; i < columnCount; i++) {
                            row[i] = rs.getString(i + 1);
                        }
                        return row;
                    }
                });
        return strLst;
    }

    public List<String[]> getResultsWithLabels(String sql) {
        List<Map<String, Object>> table = jdbcTemplate.queryForList(sql);
        return null;
    }

    @Override
    public void executeStmt(String sql) {

    }

    @Override
    public void update(String sql) {

    }

    @Override
    public String[] getLabels(String sql) {
        System.out.println("Querying: " + sql);
        SqlRowSet rs = jdbcTemplate.queryForRowSet(sql);
        if (rs==null) return new String[] {"null"};
        SqlRowSetMetaData metaData = rs.getMetaData();
        String[] columns = metaData.getColumnNames();
        String[] columnNames = new String[columns.length];
        for (int i=0; i<columns.length; i++) {
            String columnLabel = metaData.getColumnLabel(i+1);
            columnNames[i] = columnLabel != null ? columnLabel : metaData.getColumnName(i+1);
        }

        return columnNames;
    }
}