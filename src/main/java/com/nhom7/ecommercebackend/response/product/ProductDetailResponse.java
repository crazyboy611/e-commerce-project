package com.nhom7.ecommercebackend.response.product;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.nhom7.ecommercebackend.model.*;
import com.nhom7.ecommercebackend.request.category.CategoryDTO;
import com.nhom7.ecommercebackend.request.category.SubCategoryDTO;
import com.nhom7.ecommercebackend.response.CategoryResponse;
import lombok.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class ProductDetailResponse {

    private Long id;
    private String name;
    private String description;
    private String thumbnail;
    private BigDecimal price;
    private boolean active;
    private Long quantity;
    private boolean isHot;
    private List<SubCategory> subcategory;
    private CategoryResponse category;
    @JsonProperty("product_images")
    private List<ProductImage> productImages;
    private List<ProductAttributeValueResponse> attributes;
    public static ProductDetailResponse fromProduct(Product product) {

        List<ProductAttributeValueResponse> attributeValues = new ArrayList<>();
        List<ProductAttributeValue> productAttributeValues =
                product
                        .getAttributeValues()
                        .stream()
                        .filter(productAttributeValue -> productAttributeValue.getProductAttribute().isActive())
                        .toList();
        productAttributeValues.forEach(attributeValue -> {
            ProductAttributeValueResponse response = ProductAttributeValueResponse.builder()
                    .name(attributeValue.getProductAttribute().getName())
                    .value(attributeValue.getValue())
                    .build();
            attributeValues.add(response);
        });

        return ProductDetailResponse.builder()
                .id(product.getId())
                .name(product.getName())
                .description(product.getDescription())
                .thumbnail(product.getThumbnail())
                .active(product.getActive())
                .price(product.getPrice())
                .quantity(product.getQuantity())
                .isHot(product.isHot())
                .subcategory(product.getSubcategory())
                .category(CategoryResponse
                        .builder()
                        .id(product.getSubcategory().getFirst().getCategory().getId())
                        .name(product.getSubcategory().getFirst().getCategory().getName())
                        .build()
                )
                .attributes(attributeValues)
                .productImages(product.getProductImages())
                .build();
    }
}
