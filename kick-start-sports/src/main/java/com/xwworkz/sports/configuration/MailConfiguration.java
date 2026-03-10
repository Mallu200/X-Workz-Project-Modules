package com.xwworkz.sports.configuration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

import java.util.Properties;

@Configuration
public class MailConfiguration {


    private static final Logger logger = LoggerFactory.getLogger(MailConfiguration.class);


    @Bean
    public JavaMailSender getMailSender(){
        logger.info("Initializing JavaMailSender with Gmail SMTP settings");

        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
        mailSender.setHost("smtp.gmail.com");
        mailSender.setPort(587);

        mailSender.setUsername("chapisgarmallikarjun@gmail.com");
        mailSender.setPassword("tgyd smhg hizf cesk");

        Properties props = mailSender.getJavaMailProperties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.debug", "true");

        logger.debug("Mail properties set: protocol={}, auth={}, starttls={}, debug={}",
                props.get("mail.transport.protocol"),
                props.get("mail.smtp.auth"),
                props.get("mail.smtp.starttls.enable"),
                props.get("mail.debug"));

        logger.info("JavaMailSender configured for host: {}, port: {}",
                mailSender.getHost(), mailSender.getPort());

        return mailSender;
    }
}
