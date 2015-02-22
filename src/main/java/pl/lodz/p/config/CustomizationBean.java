package pl.lodz.p.config;

/**
 * Created by Łukasz Ochmański on 2/22/2015.
 */
import org.springframework.boot.context.embedded.*;
import org.springframework.stereotype.Component;

@Component
public class CustomizationBean implements EmbeddedServletContainerCustomizer {

    @Override
    public void customize(ConfigurableEmbeddedServletContainer container) {
        container.setPort(80);
    }
}