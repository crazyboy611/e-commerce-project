package com.nhom7.ecommercebackend.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "payment_details")
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class Payment extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(columnDefinition = "DECIMAL(38, 0)")
    private BigDecimal amount;

    private boolean paid;

    @Enumerated(EnumType.STRING)
    private PaymentProvider provider;

    @OneToOne
    @JoinColumn(name = "order_id")
    private Order order;

}
