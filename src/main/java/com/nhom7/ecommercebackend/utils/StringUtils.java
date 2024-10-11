package com.nhom7.ecommercebackend.utils;

import java.text.Normalizer;

public class StringUtils {
    public static String normalizeString(String input) {
        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);
        return normalized.replaceAll("[\\p{InCombiningDiacriticalMarks}]", "").toLowerCase();
    }
}

