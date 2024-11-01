package com.nhom7.ecommercebackend.service.impl;

import com.nhom7.ecommercebackend.exception.DataNotFoundException;
import com.nhom7.ecommercebackend.exception.PermissionDenyException;
import com.nhom7.ecommercebackend.exception.TokenException;
import com.nhom7.ecommercebackend.exception.UnsupportedLoginException;
import com.nhom7.ecommercebackend.model.User;
import com.nhom7.ecommercebackend.repository.UserRepository;
import com.nhom7.ecommercebackend.request.login.AuthenticationRequest;
import com.nhom7.ecommercebackend.request.login.IntrospectRequest;
import com.nhom7.ecommercebackend.request.login.LogoutRequest;
import com.nhom7.ecommercebackend.request.token.RefreshTokenRequest;
import com.nhom7.ecommercebackend.response.login.AuthenticationResponse;
import com.nhom7.ecommercebackend.service.AuthenticateService;
import com.nhom7.ecommercebackend.utils.AuthenticationUtils;
import com.nimbusds.jose.JOSEException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthenticateServiceImpl implements AuthenticateService {

    private final AuthenticationUtils authenticationUtils;
    private final UserRepository userRepository;
    private final AuthenticationManager authenticationManager;

    @Override
    public AuthenticationResponse login(AuthenticationRequest loginRequest) throws PermissionDenyException {
        Optional<User> user = Optional.empty();
        String subject = null;
        if(!loginRequest.getUserName().isBlank()) {
            Optional<User> userEmailOptional = userRepository.findByEmail(loginRequest.getUserName());
            if(userEmailOptional.isPresent()) {
                if(userEmailOptional.get().isActive()) {
                    user = userEmailOptional;
                    subject = user.get().getEmail();
                }else{
                    throw new PermissionDenyException("Your account has bean lock!");
                }
            } else {
                Optional<User> userPhoneOptional = userRepository.findByPhoneNumber(loginRequest.getUserName());
                if (userPhoneOptional.isPresent()) {
                    if (userPhoneOptional.get().isActive()) {
                        user = userPhoneOptional;
                        subject = user.get().getPhoneNumber();
                    } else {
                        throw new PermissionDenyException("Your account has bean lock!");
                    }
                } else {
                    throw new DataNotFoundException("Your account does not exits!");
                }
            }
        }

        User existiongUser = user.get();

        if(!existiongUser.getPassword().isEmpty()
            && Objects.isNull(existiongUser.getProvider())
            && Objects.isNull(existiongUser.getProviderId())) {
            UsernamePasswordAuthenticationToken authenticationToken
                    = new UsernamePasswordAuthenticationToken(subject, loginRequest.getPassword(), existiongUser.getAuthorities());
            authenticationManager.authenticate(authenticationToken);

            return AuthenticationResponse.builder()
                    .userFullName(existiongUser.getFullName())
                    .accessToken(authenticationUtils.generateToken(existiongUser))
                    .authenticated(true)
                    .build();
        } else {
            if (existiongUser.getPassword().isEmpty()
                    && !Objects.isNull(existiongUser.getProvider())
                    && !Objects.isNull(existiongUser.getProviderId())) {
                UsernamePasswordAuthenticationToken authenticationToken
                        = new UsernamePasswordAuthenticationToken(subject, null, existiongUser.getAuthorities());
                authenticationManager.authenticate(authenticationToken);

                return AuthenticationResponse.builder()
                        .userFullName(existiongUser.getFullName())
                        .accessToken(authenticationUtils.generateToken(existiongUser))
                        .authenticated(true)
                        .build();
            }
        }
        throw new DataNotFoundException("Your account does not exits!");
    }

    @Override
    public AuthenticationResponse introspectToken(IntrospectRequest introspectRequest) throws ParseException, JOSEException {
        return authenticationUtils.introspectToken(introspectRequest);
    }

    @Override
    public AuthenticationResponse refreshToken(RefreshTokenRequest request) throws TokenException, ParseException, JOSEException {
        return authenticationUtils.refreshToken(request);
    }


    @Override
    public void logout(LogoutRequest logoutRequest) throws TokenException, ParseException, JOSEException {
        authenticationUtils.logout(logoutRequest);
    }


    @Override
    public AuthenticationRequest exchangeToken(String code, String loginType) throws UnsupportedLoginException {
        return authenticationUtils.exchangeToken(code, loginType);
    }

    @Override
    public String getOauth2LoginURL(String loginType) {
        return authenticationUtils.generateAuthUrl(loginType);
    }
}
