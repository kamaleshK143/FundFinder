package com.fundfinder.enums;

/**
 * Declared in ascending order on purpose: the matching engine compares
 * education levels using ordinal() to check whether a student's level
 * falls within a scholarship's [min, max] range.
 */
public enum EducationLevel {
    CLASS_8_AND_BELOW,
    CLASS_9,
    CLASS_10,
    CLASS_11,
    CLASS_12,
    UNDERGRADUATE,
    POSTGRADUATE,
    PHD
}
