# Documentation for the target Numworks

## Initial discussion
See <https://discuss.ocaml.org/t/could-we-add-a-tiny-ocaml-interpreter-to-numworks-graphical-calculators/7652/11>

## Useful links
- <https://my.numworks.com/apps>
- <https://ti-planet.github.io/webdfu_numworks/n0110/>

Example of apps written in C/C++/Rust for the Numworks:
- in C : <https://github.com/numworks/epsilon-sample-app-c>
- in C++ : <https://github.com/numworks/epsilon-sample-app-cpp>
- in Rust : <https://github.com/numworks/epsilon-sample-app-rust>
- in OCaml : see below :tada: !

## What I already ported
- :tada: Successfully: an example of all the possible functions that can be used in a Numworks app written in OCaml: <tests/hello_world>
- :tada: Successfully: [my One-File Prolog implementation in OCaml](https://github.com/Naereen/Tiny-Prolog-in-OCaml-OneFile/): <tests/prolog>
- Not yet successfully: TODO: finish <tests/minicaml/> from <https://github.com/ViRoLam/Mini-Caml-Interpreter>

### A list of inspiration
- <https://github.com/dacabdi/bc-ocaml/blob/master/bc.ml>
- <https://github.com/bnjones/ocaml-minilisp>

## Another direction: write microOCaml.py or microOCaml.c ?
See:
- <https://ruslanspivak.com/lsbasi-part1/>
- <https://khamidou.com/compilers/lisp.py/>
- <https://plzoo.andrej.com/>
- <https://ocaml.org/p/minicaml/0.4>
- <https://github.com/codecrafters-io/build-your-own-x?tab=readme-ov-file#build-your-own-text-editor>