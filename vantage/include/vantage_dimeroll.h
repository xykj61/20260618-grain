#ifndef VANTAGE_DIMEROLL_H
#define VANTAGE_DIMEROLL_H

#include <stdint.h>

/* Dimeroll module manifest */
uint32_t dimeroll_module_count(void);
const char *dimeroll_module_label(uint32_t index);
const char *dimeroll_module_elf(uint32_t index);

/* Dimeroll query types */
uint32_t dimeroll_query_type_count(void);
const char *dimeroll_query_type_label(uint32_t index);
const char *dimeroll_query_type_elf(uint32_t index);
const char *dimeroll_query_type_placeholder(uint32_t index);

/* Column configurations per module */
uint32_t dimeroll_column_count(uint32_t module_index);
const char *dimeroll_column_title(uint32_t module_index,
                                  uint32_t col_index);
const char *dimeroll_column_ident(uint32_t module_index,
                                  uint32_t col_index);
uint32_t dimeroll_column_width(uint32_t module_index,
                               uint32_t col_index);

#endif
