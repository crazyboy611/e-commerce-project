package com.nhom7.ecommercebackend.controller;

import com.nhom7.ecommercebackend.model.Order;
import com.nhom7.ecommercebackend.request.order.OrderDTO;
import com.nhom7.ecommercebackend.response.ApiResponse;
import com.nhom7.ecommercebackend.response.order.OrderDetailResponse;
import com.nhom7.ecommercebackend.response.order.OrderListResponse;
import com.nhom7.ecommercebackend.response.order.OrderResponse;
import com.nhom7.ecommercebackend.response.payment.VNPayResponse;
import com.nhom7.ecommercebackend.service.OrderService;
import com.nhom7.ecommercebackend.service.PaymentService;
import com.nhom7.ecommercebackend.service.UserService;
import io.swagger.annotations.Api;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.UUID;

import static java.net.HttpURLConnection.HTTP_OK;

@RequiredArgsConstructor
@RequestMapping("${api.prefix}/orders")
@RestController
public class OrderController {

    private final OrderService orderService;
    private final PaymentService paymentService;
    @PostMapping("")
    @PreAuthorize("hasRole('USER')")
    @SecurityRequirement(name = "bearer-key")
    public ApiResponse createOrder(@RequestBody OrderDTO orderDTO) {
        Order newOrder = orderService.createOrder(orderDTO);
        return ApiResponse.builder()
                .message("Place order successfully!")
                .status(HTTP_OK)
                .data(OrderResponse.fromOrder(newOrder))
                .build();
    }
    @GetMapping("/{orderId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    @SecurityRequirement(name = "bearer-key")
    public ApiResponse getOrderById(
            @PathVariable("orderId") String orderId
            ) {
        Order existingOrder = orderService.findOrderById(UUID.fromString(orderId));
        return ApiResponse.builder()
                .message("Get order successfully!")
                .status(HTTP_OK)
                .data(OrderResponse.fromOrder(existingOrder))
                .build();
    }
    @GetMapping("")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "bearer-key")
    public ApiResponse getAllOrder(
            @RequestParam(value = "keyword", defaultValue = "", required = false) String keyword,
            @RequestParam(value = "size", defaultValue = "5", required = false) int size,
            @RequestParam(value = "page", defaultValue = "0", required = false) int page
    ) {
        PageRequest request = PageRequest.of(page, size);
        Page<OrderResponse> existingOrders = orderService.getAllOrder(keyword, request);
        OrderListResponse orderListResponse = OrderListResponse.builder()
                .orders(existingOrders.getContent())
                .totalPages(existingOrders.getTotalPages())
                .build();
        return ApiResponse.builder()
                .message("Get all order successfully!")
                .status(HTTP_OK)
                .data(orderListResponse)
                .build();
    }
    @DeleteMapping("/{orderId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    @SecurityRequirement(name = "bearer-key")
    public ApiResponse deactivateOrder(@PathVariable("orderId") UUID orderId) {
        orderService.deleteOrder(orderId);
        return ApiResponse.builder()
                .status(HTTP_OK)
                .message("Deactivate Order successfully!")
                .build();
    }
    @PostMapping("/checkout/vn-pay")
    @PreAuthorize("hasRole('USER')")
    @SecurityRequirement(name = "bearer-key")
    public ApiResponse checkoutWithVNPAY(
            @RequestParam(name = "order_id", required = true) String orderId,
            @RequestParam(name = "amount", required = true) Long amount
    ) throws UnsupportedEncodingException {
        return ApiResponse.builder()
                .message("Success!")
                .data(paymentService.createVNPayURL(orderId, amount))
                .status(HTTP_OK)
                .build();
    }
    @GetMapping("/checkout/vn-pay/callback")
    public ApiResponse getVNPayResponse(
            @RequestParam(name = "vnp_Amount", required = true) Long vnpAmount,
            @RequestParam(name = "vnp_BankCode", required = true) String vnpBankCode,
            @RequestParam(name = "vnp_CardType", required = true) String vnpCardType,
            @RequestParam(name = "vnp_OrderInfo", required = true) String vnpOrderInfo,
            @RequestParam(name = "vnp_PayDate", required = true) String vnpPayDate,
            @RequestParam(name = "vnp_ResponseCode", required = true) String vnpResponseCode,
            @RequestParam(name = "vnp_TransactionStatus", required = true) String vnpTransactionStatus
    ) throws ParseException {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        Date payDate = formatter.parse(vnpPayDate);
        String paymentInfo = vnpOrderInfo.replace("+", " ");
        paymentInfo = URLDecoder.decode(paymentInfo, StandardCharsets.UTF_8);
        VNPayResponse vnPayResponse = VNPayResponse.builder()
                .vnpAmount(vnpAmount / 100L)
                .vnpBankCode(vnpBankCode)
                .vnpCartType(vnpCardType)
                .vnpOrderInfo(paymentInfo)
                .vnpResponseCode(Integer.parseInt(vnpResponseCode))
                .vnpTransactionStatus(Integer.parseInt(vnpTransactionStatus))
                .vnpPayDate(payDate)
                .build();
        String message = getMessage(vnpTransactionStatus);
        return ApiResponse.builder()
                .message(message)
                .data(vnPayResponse)
                .status(HTTP_OK)
                .build();
    }

    private static String getMessage(String vnpTransactionStatus) {
        String message = null;
        if(vnpTransactionStatus.equals("00")) {
            message = "Giao dịch thành công!";
        }
        if(vnpTransactionStatus.equals("01")) {
            message = "Giao dịch chưa hoàn tất!";
        }
        if(vnpTransactionStatus.equals("02")) {
            message = "Giao dịch bị lỗi!";
        }
        if(vnpTransactionStatus.equals("04")) {
            message = "Giao dịch đảo (Khách hàng đã bị trừ  tiền tại Ngân hàng nhưng GD " +
                    "chưa thành công ở VNPAY)!";
        }
        if(vnpTransactionStatus.equals("08")) {
            message = "Giao dịch quá thời gian thanh toán!";
        }
        if(vnpTransactionStatus.equals("11")) {
            message = "Giao dịch bị hủy!";
        }
        return message;
    }
}
