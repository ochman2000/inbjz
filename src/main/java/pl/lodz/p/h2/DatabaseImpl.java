package pl.lodz.p.h2;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.jdbc.support.rowset.SqlRowSetMetaData;
import pl.lodz.p.core.User;
import pl.lodz.p.dao.DatabaseDao;

import java.sql.SQLException;
import java.util.List;

public class DatabaseImpl implements DatabaseDao {

    private JdbcTemplate jdbcTemplate;
    private static final Logger logger = LoggerFactory.getLogger(DatabaseImpl.class);
    private static DatabaseImpl instance;


    public DatabaseImpl() {
        SimpleDriverDataSource dataSource = getDataSource(User.SA);
        jdbcTemplate = new JdbcTemplate(dataSource);
        init(jdbcTemplate);
    }

    private SimpleDriverDataSource getDataSource(User user) {
        SimpleDriverDataSource dataSource = new SimpleDriverDataSource();
        dataSource.setDriverClass(org.h2.Driver.class);

        if (user==User.SA) {
            dataSource.setUsername("SA");
            dataSource.setUrl("jdbc:h2:./mem");
            @SuppressWarnings("unused")
            String salt = "Politechnika";
            @SuppressWarnings("unused")
            String password = "2lkj2lkj";
            String sha512 = "ACE1533DF199C233735FA02F4AC80410F49D3DD" +
                    "5CBEDEF4D1DDCFC972ACE8BF84F099B9374B50542ADFF6AE211ED839E703F24E7C2298B6A33E42DD4FE8A5A97";
            dataSource.setPassword(sha512);
        }
        if (user==User.STUDENT) {
            dataSource.setUsername("STUDENT");
            dataSource.setUrl("jdbc:h2:./mem");
            dataSource.setPassword("abc");
        }
        return dataSource;
    }

    public static DatabaseImpl getInstance() {
        return instance = instance == null ? new DatabaseImpl() : instance;
    }

    private void init(JdbcTemplate jdbcTemplate) {
        logger.info("Creating tables");
        logger.info("Creating schema HR");
        jdbcTemplate.execute(DatabaseUtils.getHrSchema());
        logger.info("Inserting data to HR");
        jdbcTemplate.execute(DatabaseUtils.getHrData());
        logger.info("Inserting data finished.");
        logger.info("Creaating schema test_pracownicy");
        jdbcTemplate.execute(DatabaseUtils.getTworzPracownicy());
        jdbcTemplate.execute(DatabaseUtils.getWstawDanePracownicy());
        logger.info("Inserting data finished.");
    }

    @Override
    public List<String[]> executeQuery(String sql) throws SQLException {
        logger.info("Querying: " + sql);
        if (hasProhibitedCommand(sql)) {
            throw new SQLException("You gotta be kiddin'");
        }
        return jdbcTemplate.query(sql,
                (rs, rowNum) -> {
                    int columnCount = rs.getMetaData().getColumnCount();
                    String[] row = new String[columnCount];
                    for (int i = 0; i < columnCount; i++) {
                        row[i] = rs.getString(i + 1);
                    }
                    return row;
                });
    }

    private boolean hasProhibitedCommand(String sql) {
        sql = sql.replaceAll("\\s+", " ").toLowerCase();
        if (sql.contains("drop schema superuser")) {
            logger.error("Input contatins drop schema");
            return true;
        }
        if (sql.contains("drop user")) {
            logger.error("Input contatins drop user");
            return true;
        }
        if (sql.contains("drop all")) {
            logger.error("Input contatins drop all");
            return true;
        }
        return false;
    }

    @Override
    public String executeStmt(String sql) {
        jdbcTemplate.execute(sql);
        return sql +" executed.";
    }

    @Override
    public String update(String sql) {
        int rows = jdbcTemplate.update(sql);
        return rows + " row"+ (rows==1 ? "" : "s") +" affected.";
    }

    @Override
    public String[] getLabels(String sql) {
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