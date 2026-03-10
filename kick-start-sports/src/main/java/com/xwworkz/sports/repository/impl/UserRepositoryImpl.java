package com.xwworkz.sports.repository.impl;

import com.xwworkz.sports.entity.UserEntity;
import com.xwworkz.sports.entity.UserLoginEntity;
import com.xwworkz.sports.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.NoResultException;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

@Repository
public class UserRepositoryImpl implements UserRepository {

    private static final Logger logger = LoggerFactory.getLogger(UserRepositoryImpl.class);

    @Autowired
    private EntityManagerFactory factory;

    @Override
    public boolean saveUser(UserEntity userEntity) {
        EntityManager manager = factory.createEntityManager();
        try {
            manager.getTransaction().begin();
            manager.persist(userEntity);
            manager.getTransaction().commit();
            logger.info("[saveUser] User saved: {}", userEntity.getEmailId());
            return true;
        } catch (Exception e) {
            logger.error("[saveUser] Failed to save user: {}", userEntity.getEmailId(), e);
            if (manager.getTransaction().isActive()) {
                manager.getTransaction().rollback();
            }
            System.out.println("[saveUser] Failed to save user: " + userEntity.getEmailId());
            return false;
        } finally {
            manager.close();
        }
    }

    @Override
    public UserEntity findByEmailId(String emailId) {
        EntityManager manager = factory.createEntityManager();
        try {
            UserEntity user = manager.createNamedQuery("UserEntity.findByEmail", UserEntity.class)
                    .setParameter("emailId", emailId)
                    .getSingleResult();
            logger.info("[findByEmailId] User found: {}", emailId);
            return user;
        } catch (NoResultException e) {
            logger.warn("[findByEmailId] No user found with email: {}", emailId);
            return null;
        } catch (Exception e) {
            logger.error("[findByEmailId] Exception while fetching user: {}", emailId, e);
            return null;
        } finally {
            manager.close();
        }
    }

    @Override
    public UserEntity findByContact(String contact) {
        EntityManager manager = factory.createEntityManager();
        try {
            UserEntity user = manager.createNamedQuery("UserEntity.findByContact", UserEntity.class)
                    .setParameter("contact", contact)
                    .getSingleResult();
            logger.info("[findByContact] User found: {}", contact);
            return user;
        } catch (NoResultException e) {
            logger.warn("[findByContact] No user found with contact: {}", contact);
            return null;
        } catch (Exception e) {
            logger.error("[findByContact] Exception while fetching user: {}", contact, e);
            return null;
        } finally {
            manager.close();
        }
    }

    @Override
    public UserEntity findByEmailOrContact(String emailOrContact) {
        EntityManager manager = factory.createEntityManager();
        try {
            UserEntity user = manager.createNamedQuery("UserEntity.findByEmailOrContact", UserEntity.class)
                    .setParameter("emailOrContact", emailOrContact)
                    .getSingleResult();
            logger.info("[findByEmailOrContact] User found: {}", emailOrContact);
            return user;
        } catch (NoResultException e) {
            logger.warn("[findByEmailOrContact] No user found with email/contact: {}", emailOrContact);
            return null;
        } catch (Exception e) {
            logger.error("[findByEmailOrContact] Exception while fetching user: {}", emailOrContact, e);
            return null;
        } finally {
            manager.close();
        }
    }

    @Override
    public boolean userLogin(UserLoginEntity loginEntity) {
        EntityManager manager = factory.createEntityManager();
        try {
            manager.getTransaction().begin();
            manager.persist(loginEntity);
            manager.getTransaction().commit();
            logger.info("[userLogin] Login saved for: {}", loginEntity.getEmailOrContact());
            return true;
        } catch (Exception e) {
            logger.error("[userLogin] Failed to save login for: {}", loginEntity.getEmailOrContact(), e);
            if (manager.getTransaction().isActive()) manager.getTransaction().rollback();
            System.out.println("[userLogin] Failed to save login for: " + loginEntity.getEmailOrContact());
            return false;
        } finally {
            manager.close();
        }
    }

    @Override
    public boolean updateUser(UserEntity user) {
        EntityManager manager = factory.createEntityManager();
        try {
            manager.getTransaction().begin();
            UserEntity updated = manager.merge(user);
            manager.getTransaction().commit();
            logger.info("[updateUser] Updated for: {}", updated.getEmailId());
            return true;
        } catch (Exception e) {
            logger.error("[updateUser] Failed to update for: {}", user.getEmailId(), e);
            if (manager.getTransaction().isActive()) manager.getTransaction().rollback();
            System.out.println("[updateUser] Failed to update for: " + user.getEmailId());
            return false;
        } finally {
            manager.close();
        }
    }

    @Override
    public List<UserEntity> findByOtpNotNullAndOtpCreatedAtBefore(LocalDateTime time) {
        EntityManager manager = factory.createEntityManager();
        try {
            List<UserEntity> result = manager.createNamedQuery("UserEntity.findExpiredOtps", UserEntity.class)
                    .setParameter("time", time)
                    .getResultList();
            logger.info("[findByOtpNotNullAndOtpCreatedAtBefore] Found {} expired OTPs", result.size());
            return result;
        } catch (Exception e) {
            logger.error("[findByOtpNotNullAndOtpCreatedAtBefore] Exception while fetching expired OTPs", e);
            return Collections.emptyList();
        } finally {
            manager.close();
        }
    }
}