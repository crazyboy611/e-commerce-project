package com.nhom7.ecommercebackend.service.impl;

import com.nhom7.ecommercebackend.exception.DataNotFoundException;
import com.nhom7.ecommercebackend.model.Category;
import com.nhom7.ecommercebackend.model.Product;
import com.nhom7.ecommercebackend.model.SubCategory;
import com.nhom7.ecommercebackend.repository.CategoryRepository;
import com.nhom7.ecommercebackend.repository.ProductRepository;
import com.nhom7.ecommercebackend.repository.SubCategoryRepository;
import com.nhom7.ecommercebackend.request.CategoryDTO;
import com.nhom7.ecommercebackend.request.SubCategoryDTO;
import com.nhom7.ecommercebackend.service.CategoryService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository categoryRepository;
    private final SubCategoryRepository subCategoryRepository;

    @Override
    @Transactional
    public Category creatCategory(CategoryDTO categoryDTO) throws DataNotFoundException {
        if(!categoryDTO.getName().isBlank() && categoryRepository.existsByName(categoryDTO.getName())) {
            throw new DataIntegrityViolationException("Category name has already exist!");
        }
        Category newCategory = Category.builder().name(categoryDTO.getName()).build();
        newCategory.setSubCategoryList(new ArrayList<>());
        categoryRepository.save(newCategory);
        return newCategory;
    }

    @Override
    @Transactional
    public void deleteCategory(Long categoryId) {
        Category category = categoryRepository.findById(categoryId).orElseThrow(() ->
                 new DataNotFoundException("Category does not exist!"));
        List<SubCategory> subCategories = subCategoryRepository.findByCategory(category);
        subCategories.forEach(subCategory -> {
            subCategory.setCategory(null);
            subCategoryRepository.save(subCategory);
        });
        categoryRepository.delete(category);
    }

    @Override
    public Category updateCategory(Long categoryId, CategoryDTO categoryDTO) {
        Category category = categoryRepository.findById(categoryId).orElseThrow(() ->
                new DataNotFoundException("Category does not exist!"));
        category.setName(categoryDTO.getName());
        return categoryRepository.save(category);
    }

    @Override
    public List<Category> getAllCategory() {
        return categoryRepository.findAll();
    }

    @Override
    public Category getCategoryById(Long categoryId) {
        return categoryRepository.findById(categoryId).orElseThrow(() ->
                new DataNotFoundException("Category does not exist!"));
    }

    @Override
    public Category addSubcategory(Long categoryId, SubCategoryDTO subCategoryDTO) {
        SubCategory existSubcategory = subCategoryRepository.findByName(subCategoryDTO.getSubCategoryName())
                .orElseThrow(() -> new DataNotFoundException("Subcategory does not exist!"));
        Category category = getCategoryById(categoryId);
        category.getSubCategoryList().add(existSubcategory);
        existSubcategory.setCategory(category);
        return categoryRepository.save(category);
    }

}
