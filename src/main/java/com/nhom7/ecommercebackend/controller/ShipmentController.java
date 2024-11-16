package com.nhom7.ecommercebackend.controller;

import com.nhom7.ecommercebackend.model.Shipment;
import com.nhom7.ecommercebackend.request.shipment.ShipmentDTO;
import com.nhom7.ecommercebackend.response.ApiResponse;
import com.nhom7.ecommercebackend.service.ShipmentService;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import static java.net.HttpURLConnection.HTTP_CREATED;
import static java.net.HttpURLConnection.HTTP_OK;

@RestController
@RequiredArgsConstructor
@RequestMapping("${api.prefix}/shipments")
public class ShipmentController {
    private final ShipmentService shipmentService;

    @SecurityRequirement(name = "bearer-key")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("")
    public ApiResponse createShipment(@RequestBody ShipmentDTO shipment) {
        return ApiResponse.builder()
                .status(HTTP_CREATED)
                .message("Shipment created")
                .data(shipmentService.createShipment(shipment))
                .build();
    }
    @SecurityRequirement(name = "bearer-key")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    @GetMapping("")
    public ApiResponse getAllShipment() {
        return ApiResponse.builder()
                .status(HTTP_CREATED)
                .message("Shipment created")
                .data(shipmentService.findAll())
                .build();
    }
    @SecurityRequirement(name = "bearer-key")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{shipmentId}")
    public ApiResponse updateShipment(
            @PathVariable("shipmentId") int id,
            @RequestBody ShipmentDTO shipment
    ) {
        return ApiResponse.builder()
                .status(HTTP_OK)
                .message("Shipment created")
                .data(shipmentService.updateShipment(id, shipment))
                .build();
    }
    @SecurityRequirement(name = "bearer-key")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{shipmentId}")
    public ApiResponse deleteShipment(
            @PathVariable("shipmentId") int id
    ) {
        return ApiResponse.builder()
                .status(HTTP_OK)
                .message("Shipment created")
                .build();
    }


}
