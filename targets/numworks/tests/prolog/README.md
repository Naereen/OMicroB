# [Tiny-Prolog-in-OCaml-OneFile](https://github.com/Naereen/Tiny-Prolog-in-OCaml-OneFile) :tada: **running on a Numworks calculator**
> A tiny implementation of a small subset of the Prolog language, in OCaml. With small and fun examples.
>
> WARNING: this project only has an **educational purpose**, for a real-world use of Prolog, please refer to [GNU Prolog (gprolog)](http://gprolog.org/).

This folder contains [the code](prolog.ml), embeds one of the [examples](https://github.com/Naereen/Tiny-Prolog-in-OCaml-OneFile/tree/master/examples) I wrote in 2018/2020, for a tiny [Prolog](https://en.wikipedia.org/wiki/Prolog) implementation, written in [the OCaml language](https://ocaml.org/).

To build the project, it should be really easy: clone, run `make`, relax and enjoy :tada:. The implementation focuses on a very small subset of Prolog, see the examples for a good idea of what is supported.

## How to build the NWA Numworks app

First, you should `git clone` the [main project](https://github.com/Naereen/OMicroB/tree/numworks/) (my fork of `OMicroB`, branch `numworks`), having ran `make clean ; ./configure -target numworks ; make` to configure and compile `omicrob` for the Numworks...

Then, you can run, from this folder:
```bash
$ make
```
This should create the `prolog.nwa` app, which you can then [install on your Numworks calculator](https://my.numworks.com/apps).

## It now supports user defined theory/questions
> By default, the app runs the example below of Tom & Jerry, but you can define two files `prolog_theory.py` for the theory, and `prolog_questions.py` for the questions.

See my two files on [my user space on Numworks.com](https://my.numworks.com/python/lilian-besson-1/):

- Defining the "Tom & Jerry" theory: <https://my.numworks.com/python/lilian-besson-1/prolog_theory>
- three questions to ask to this "Tom & Jerry" theory: <https://my.numworks.com/python/lilian-besson-1/prolog_questions>

----

# **Old documentation**

## Example of use of the `prolog` binary
- A theory has this form, first with axioms (predicate):
```prolog
cat(tom).
mouse(jerry).
```
- Then maybe some rules, stating that [a mouse is fast and a cat can be stupid](https://en.wikipedia.org/wiki/Tom_and_Jerry):
```prolog
fast(X) <-- mouse(X).
stupid(X) <-- cat(X).
```

- If you save this file (see [this example](examples/tomandjerry.pl)), you can then load it with the `prolog` binary:

```bash
$ ./prolog/prolog ./examples/tomandjerry.pl
?- stupid(tom).
  { }
continue ? (o/n) [o] :
```

- This `{ }` is an empty model, meaning that `stupid(tom).` evaluates to True in an empty model (no need for instanciation).

- You can also ask your question directly in the command line:
```bash
$ ./prolog/prolog ./examples/tomandjerry.pl "fast(tom)."
?- fast(tom).
```
- An empty response mean that the term is false, no matter the model.

- You can add more rules, as you want.
```prolog
ishuntedby(X, Y) <-- mouse(X), cat(Y).
```
```bash
$ ./prolog/prolog ./examples/tomandjerry.pl "ishuntedby(tom, jerry)."
?- ishuntedby(tom, jerry).
$ ./prolog/prolog ./examples/tomandjerry.pl "ishuntedby(jerry, tom)."
?- ishuntedby(jerry, tom).
  { }
```

- You can also add comments, that are lines starting with one or more `#` character.
```prolog
# the mouse always espace the cat!
istrickedby(X, Y) <-- cat(X), mouse(Y).
```

## More examples ?

- See [this folder](examples/).

---

### :scroll: License ? [![GitHub license](https://img.shields.io/github/license/Naereen/Tiny-Prolog-in-OCaml-OneFile.svg)](https://github.com/Naereen/Tiny-Prolog-in-OCaml-OneFile/blob/master/LICENSE)
This (small) folder is published under the terms of the [MIT license](http://lbesson.mit-license.org/) (file [LICENSE](LICENSE)).
© [Lilian Besson](https://GitHub.com/Naereen), 2018-2024.

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/Tiny-Prolog-in-OCaml-OneFile/graphs/commit-activity)
[![Ask Me Anything !](https://img.shields.io/badge/Ask%20me-anything-1abc9c.svg)](https://GitHub.com/Naereen/Tiny-Prolog-in-OCaml)
[![Analytics](https://ga-beacon.appspot.com/UA-38514290-17/github.com/Naereen/Tiny-Prolog-in-OCaml-OneFile/README.md?pixel)](https://GitHub.com/Naereen/Tiny-Prolog-in-OCaml-OneFile/)

[![made-with-OCaml](https://img.shields.io/badge/Made%20with-OCaml-1f425f.svg)](https://ocaml.org/)
[![made-for-teaching](https://img.shields.io/badge/Made%20for-Teaching-6800ff.svg)](https://perso.crans.org/besson/teach/)

[![ForTheBadge built-with-science](http://ForTheBadge.com/images/badges/built-with-science.svg)](https://GitHub.com/Naereen/)
[![ForTheBadge uses-badges](http://ForTheBadge.com/images/badges/uses-badges.svg)](http://ForTheBadge.com)
[![ForTheBadge uses-git](http://ForTheBadge.com/images/badges/uses-git.svg)](https://GitHub.com/)
