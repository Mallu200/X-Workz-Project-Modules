package com.xwworkz.sports.configuration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

import javax.servlet.MultipartConfigElement;
import javax.servlet.ServletRegistration;
import java.io.File;

public class KickWebInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {


    private static final Logger logger = LoggerFactory.getLogger(KickWebInitializer.class);

    private int maxUploadSizeInMb = 5 * 1024 * 1024; // 5 MB

    @Override
    protected Class<?>[] getRootConfigClasses() {
        logger.info("Loading RootConfigClasses: KickWebConfiguration");
        return new Class[]{ KickWebConfiguration.class };
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        logger.info("Loading ServletConfigClasses: KickWebConfiguration");
        return new Class[]{ KickWebConfiguration.class };
    }

    @Override
    protected String[] getServletMappings() {
        logger.info("Mapping DispatcherServlet to '/'");
        return new String[]{"/"};
    }

    @Override
    protected void customizeRegistration(ServletRegistration.Dynamic registration) {
        logger.info("Customizing ServletRegistration for multipart support");

        // upload temp file will put here
        File uploadDirectory = new File(System.getProperty("java.io.tmpdir"));
        logger.debug("Upload directory set to: {}", uploadDirectory.getAbsolutePath());

        // register a MultipartConfigElement
        MultipartConfigElement multipartConfigElement =
                new MultipartConfigElement(uploadDirectory.getAbsolutePath(),
                        maxUploadSizeInMb, maxUploadSizeInMb * 2, maxUploadSizeInMb / 2);

        logger.info("MultipartConfigElement initialized with max upload size: {} MB", maxUploadSizeInMb / (1024 * 1024));
        registration.setMultipartConfig(multipartConfigElement);
    }
}
