package pl.lodz.p.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
 * Created by Łukasz Ochmański on 1/14/2015.
 */

@Configuration
@ComponentScan(value={"pl.lodz.p.components"})
public class SpringConfiguration {

}