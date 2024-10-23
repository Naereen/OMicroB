#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

const char eadk_app_name[] __attribute__((section(".rodata.eadk_app_name"))) = "OMicroB OCaml";
const uint32_t eadk_api_level  __attribute__((section(".rodata.eadk_api_level"))) = 0;

extern int main(int, char**);

void default_start() {
  printf("Launching the OCaml VM...\n");
  main(0, NULL); // Run the VM
  printf("Returned from the OCaml VM.\n");
  /* printf("External data : '%s'\n", eadk_external_data); */
}

void __start(void) __attribute((weak, alias("default_start")));
