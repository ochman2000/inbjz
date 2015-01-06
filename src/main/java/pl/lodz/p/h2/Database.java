package pl.lodz.p.h2;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;

public class Database {

    private JdbcTemplate jdbcTemplate;

    public Database(String query) {

        SimpleDriverDataSource dataSource = new SimpleDriverDataSource();
        dataSource.setDriverClass(org.h2.Driver.class);
        dataSource.setUsername("sa");
        dataSource.setUrl("jdbc:h2:mem");
        dataSource.setPassword("");

        jdbcTemplate = new JdbcTemplate(dataSource);
        init(jdbcTemplate);
    }

    private void init(JdbcTemplate jdbcTemplate) {
        System.out.println("Creating tables");
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

    public List<String[]> executeStmt(String sql) {
        System.out.println("Querying: " + sql);
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
}