package com.nhom7.ecommercebackend.service.impl;

import com.nhom7.ecommercebackend.exception.DataNotFoundException;
import com.nhom7.ecommercebackend.model.Cart;
import com.nhom7.ecommercebackend.model.CartItem;
import com.nhom7.ecommercebackend.model.Product;
import com.nhom7.ecommercebackend.repository.CartItemRepository;
import com.nhom7.ecommercebackend.repository.CartRepository;
import com.nhom7.ecommercebackend.repository.ProductRepository;
import com.nhom7.ecommercebackend.request.CartItemDTO;
import com.nhom7.ecommercebackend.service.CartItemService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class CartItemServiceImpl implements CartItemService {

    private final ProductRepository productRepository;
    private final CartItemRepository cartItemRepository;
    private final CartRepository cartRepository;

    @Override
    @Transactional
    public CartItem updateCartItemById(int cartItemId, CartItemDTO cartItemDTO) {
        if (cartItemDTO.getQuantity() == 0) {
            deleteCartItemById(cartItemId);
            return null;
        } else {
            CartItem cartItem = cartItemRepository.findById(cartItemId)
                    .orElseThrow(() -> new DataNotFoundException("Cart Item does not exist!"));
            cartItem.setQuantity(cartItemDTO.getQuantity());
            return cartItemRepository.save(cartItem);
        }
    }
    @Override
    @Transactional
    public void deleteCartItemById(int cartItemId) {
        CartItem cartItem = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new DataNotFoundException("Cart Item does not exist!"));
        cartItemRepository.deleteById(cartItemId);
    }
}
