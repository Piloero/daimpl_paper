# Introduction to Partial Redundancy Elimination

This is the artifact for the paper on partial redundancy elimination, written
by Jonas Jahnal and Jan Groen. Here, we provide all the materials and code that 
we used when researching and creating the paper. The artifact and paper were
created for the "Design and Implementation of Modern Programming Languages"
Course at TU Darmstadt.

## LEAN Code

In order to demonstrate that the optimized examples we provide in the paper do 
not modify any of the program semantics, we've included some code written in
[LEAN](https://lean-lang.org/). This is also the programming language used
for the examples in the paper. The lean code that we present here, along with
test cases is contained in ``lean-examples/Main.lean``.

To run this file, we suggest you install [LEAN VSCode/VSCodium extension](https://marketplace.visualstudio.com/items?itemName=leanprover.lean4). This
will automatically install the LEAN version manager (ELAN) and the correct
LEAN version. When you open the Main file in VSCode, you'll find further
explanations of the code in there.

## LLVM Experiment

We wanted to see what kinds of partial redundancies LLVM can optimize on its 
own. Roy et. al. describe in their paper that they implemented their partial 
redundancy elimination as a sparate phase into LLVM, but don not go into detail 
on what cases their optimization covers that LLVM cannot already optimize. 
In order to test this, we have created an example program in 
``llvm-experiment/source.c``, which contains a partial redundancy in the 
``redundant()`` function. There, we calculate ``a + b`` twice, once in the
conditional block and once for the return value. The function is marked as
``static``, so function isn't inlined by LLVM during compilation.

Our experiments with LLVM and a decompiler have shown that this redundancy is
successfullly detected and eliminated when using LLVM. To be able to replicate
this example on other machines, we've used docker images from Docker Hub for 
compilation and disassembly. You can run the following commands to compile and 
decompile the ``source.c`` file yourself. To make the compilation reproducible,
we used compilers and decompilers that are packaged in docker images from
docker hub. To be able to run the examples below, you need to have Docker
installed. An easy way to do this is to install 
[Docker Desktop](https://www.docker.com/products/docker-desktop/).

```bash
# Enter the llvm-experiment directory
cd llvm-experiment

# First compile the source file with clang (clang uses llvm)
# Note: The files and directories created with this will be owned by root.
docker run --rm -it -v ./source.c:/data/source.c:ro -v ./compiled/:/data/ -w /data silkeh/clang:18 clang source.c

# Then decompile the compiled binary with retdec
# Note: The files and directories created with this will be owned by root.
docker run --rm -it -u 0 -v ./compiled/a.out:/home/retdec/decompiled:ro -v ./decompiled/:/home/retdec/ remnux/retdec retdec-decompiler.py decompiled
```

The decompiled code is then located in ``llvm-experiment/decompiled/decompiled.c``.
When looking at the decompiled source code, we can find our ``redundant()``
function. We've found the decompiled function to look like the following:

```c
// Address range: 0x1160 - 0x1198
int64_t redundant(int64_t a1, int64_t a2) {
    int64_t result = a2 + a1 & 0xffffffff;
    if ((int32_t)a1 >= 6) {
        // 0x1178
        printf("Going to return %i!\n", result);
    }
    // 0x118c
    return result;
}
```

This code is similar to that we put in and ignoring the platform specific 
compilation details, we can see that the compiler produced the same code that 
we put in, except that the redundant computation was optimized away.

## Figures

In the ``figures`` Folder, we included all the DrawIO files that we used in the
paper. They can be modified with the DrawIO website or the VSCode extension.
