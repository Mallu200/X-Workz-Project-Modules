package com.xwworkz.sports.configuration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import javax.sql.DataSource;
import java.util.Properties;

@Configuration
@ComponentScan(basePackages = "com.xwworkz.sports")
@EnableWebMvc
@EnableScheduling
public class KickWebConfiguration implements WebMvcConfigurer {

    private static final Logger logger = LoggerFactory.getLogger(KickWebConfiguration.class);

    @Bean
    public InternalResourceViewResolver viewResolver(){
        logger.info("Configuring InternalResourceViewResolver  with prefix '/' and suffix '.jsp'");
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/");
        resolver.setSuffix(".jsp");
        return resolver;
    }

    @Bean
    public DataSource dataSource() {
        logger.info("Setting up DataSource with MySQL connection to 'models' database");
        DriverManagerDataSource ds = new DriverManagerDataSource();
        ds.setDriverClassName("com.mysql.cj.jdbc.Driver");
        ds.setUrl("jdbc:mysql://localhost:3306/models");
        ds.setUsername("root");
        ds.setPassword("Mallu@2K3");
        logger.debug("Datasource configured with URL: {}", ds.getUrl());
        return ds;
    }

    @Bean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory() {
        logger.info("Initializing LocalContainerEntityManagerFactoryBean");
        LocalContainerEntityManagerFactoryBean emf = new LocalContainerEntityManagerFactoryBean();
        emf.setDataSource(dataSource());
        emf.setPackagesToScan("com.xwworkz.sports.entity");
        emf.setJpaVendorAdapter(new HibernateJpaVendorAdapter());

        Properties props = new Properties();
        props.setProperty("hibernate.dialect", "org.hibernate.dialect.MySQL8Dialect");
        props.setProperty("hibernate.hbm2ddl.auto", "update");
        props.setProperty("hibernate.show_sql", "true");

        logger.debug("Hibernate JPA properties set: {}", props);
        emf.setJpaProperties(props);
        return emf;
    }

    @Bean
    public PasswordEncoder passwordEncoder(){
        logger.info("Creating BCryptPasswordEncoder bean");
        return new BCryptPasswordEncoder();
    }

    @Bean
    public ThreadPoolTaskScheduler threadPoolTaskScheduler(){
        logger.info("Configuring ThreadPoolTaskScheduler with pool size 5 and prefix 'thread'");
        ThreadPoolTaskScheduler threadPoolTaskScheduler=new ThreadPoolTaskScheduler();
        threadPoolTaskScheduler.setPoolSize(5);
        threadPoolTaskScheduler.setThreadNamePrefix("thread");
        return threadPoolTaskScheduler;
    }

    @Bean
    public MultipartResolver multipartResolver() {
        logger.info("Registering StandardServletMultipartResolver bean for file uploads");
        return new StandardServletMultipartResolver();
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        logger.info("Adding resource handler mapping '/images/**' to '/images/' folder");
        registry.addResourceHandler("/images/**")
                .addResourceLocations("/images/");
    }
}