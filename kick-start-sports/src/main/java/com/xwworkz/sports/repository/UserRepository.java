package com.xwworkz.sports.repository;

import com.xwworkz.sports.entity.UserEntity;
import com.xwworkz.sports.entity.UserLoginEntity;
import java.time.LocalDateTime;
import java.util.List;

public interface UserRepository {

    boolean saveUser(UserEntity userEntity);

    UserEntity findByEmailId(String emailId);

    UserEntity findByContact(String contact);

    UserEntity findByEmailOrContact(String emailOrContact);

    boolean userLogin(UserLoginEntity loginEntity);

    boolean updateUser(UserEntity user);

    List<UserEntity> findByOtpNotNullAndOtpCreatedAtBefore(LocalDateTime time);
}
